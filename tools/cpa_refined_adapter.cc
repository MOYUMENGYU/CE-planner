#include <algorithm>
#include <cerrno>
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <map>
#include <set>
#include <sstream>
#include <stdexcept>
#include <string>
#include <vector>

struct Node {
    bool atom;
    std::string value;
    std::vector<Node> children;
    Node() : atom(false) {}
    explicit Node(const std::string &v) : atom(true), value(v) {}
};

typedef std::vector<std::string> AtomKey;
typedef std::map<AtomKey, bool> Assignment;

class AdapterError : public std::runtime_error {
public:
    explicit AdapterError(const std::string &m) : std::runtime_error(m) {}
};

static std::string lower_ascii(std::string s) {
    for (std::size_t i = 0; i < s.size(); ++i) {
        if (s[i] >= 'A' && s[i] <= 'Z') s[i] = char(s[i] - 'A' + 'a');
    }
    return s;
}

static std::vector<std::string> tokenize(const std::string &text) {
    std::vector<std::string> out;
    for (std::size_t i = 0; i < text.size();) {
        const char c = text[i];
        if (c == ';') {
            while (i < text.size() && text[i] != '\n') ++i;
        } else if (c == ' ' || c == '\t' || c == '\r' || c == '\n') {
            ++i;
        } else if (c == '(' || c == ')') {
            out.push_back(std::string(1, c));
            ++i;
        } else {
            std::size_t j = i;
            while (j < text.size()) {
                const char d = text[j];
                if (d == '(' || d == ')' || d == ';' || d == ' ' || d == '\t' || d == '\r' || d == '\n') break;
                ++j;
            }
            out.push_back(text.substr(i, j - i));
            i = j;
        }
    }
    return out;
}

static Node parse_one(const std::vector<std::string> &tokens, std::size_t &pos) {
    if (pos >= tokens.size()) throw AdapterError("unexpected end of PDDL");
    const std::string token = tokens[pos++];
    if (token != "(") {
        if (token == ")") throw AdapterError("unexpected closing parenthesis");
        return Node(token);
    }
    Node result;
    while (true) {
        if (pos >= tokens.size()) throw AdapterError("unterminated PDDL form");
        if (tokens[pos] == ")") {
            ++pos;
            return result;
        }
        result.children.push_back(parse_one(tokens, pos));
    }
}

static std::vector<Node> parse_all(const std::string &text) {
    const std::vector<std::string> tokens = tokenize(text);
    std::vector<Node> forms;
    std::size_t pos = 0;
    while (pos < tokens.size()) forms.push_back(parse_one(tokens, pos));
    return forms;
}

static std::string head(const Node &node) {
    if (node.atom || node.children.empty() || !node.children[0].atom) return std::string();
    return lower_ascii(node.children[0].value);
}

static bool is_logical_head(const std::string &h) {
    static const char *names[] = {
        "and", "or", "oneof", "not", "when", "forall", "exists", "imply", "=",
        "increase", "decrease", "assign", "scale-up", "scale-down"
    };
    for (std::size_t i = 0; i < sizeof(names) / sizeof(names[0]); ++i)
        if (h == names[i]) return true;
    return false;
}

static bool atom_key(const Node &node, AtomKey *key) {
    key->clear();
    if (node.atom || node.children.empty() || !node.children[0].atom) return false;
    const std::string h = lower_ascii(node.children[0].value);
    if (is_logical_head(h) || (!h.empty() && h[0] == ':')) return false;
    for (std::size_t i = 0; i < node.children.size(); ++i) {
        if (!node.children[i].atom) return false;
        key->push_back(lower_ascii(node.children[i].value));
    }
    return true;
}

static bool literal_info(const Node &node, AtomKey *key, bool *positive) {
    if (atom_key(node, key)) {
        *positive = true;
        return true;
    }
    if (head(node) == "not" && node.children.size() == 2 && atom_key(node.children[1], key)) {
        *positive = false;
        return true;
    }
    return false;
}

static Node atom_node(const AtomKey &key) {
    Node n;
    for (std::size_t i = 0; i < key.size(); ++i) n.children.push_back(Node(key[i]));
    return n;
}

static Node not_node(const Node &child) {
    Node n;
    n.children.push_back(Node("not"));
    n.children.push_back(child);
    return n;
}

static Node literal_node(const AtomKey &key, bool positive) {
    const Node atom = atom_node(key);
    return positive ? atom : not_node(atom);
}

static Node or_node(const Node &a, const Node &b) {
    Node n;
    n.children.push_back(Node("or"));
    n.children.push_back(a);
    n.children.push_back(b);
    return n;
}

static Node oneof_node(const std::vector<Node> &items) {
    Node n;
    n.children.push_back(Node("oneof"));
    for (std::size_t i = 0; i < items.size(); ++i) n.children.push_back(items[i]);
    return n;
}

static Node *find_define(std::vector<Node> &forms, const std::string &kind) {
    for (std::size_t i = 0; i < forms.size(); ++i) {
        Node &f = forms[i];
        if (head(f) != "define" || f.children.size() < 2) continue;
        if (head(f.children[1]) == kind) return &f;
    }
    throw AdapterError("missing " + kind + " definition");
}

static Node *find_section(Node &container, const std::string &wanted) {
    for (std::size_t i = 0; i < container.children.size(); ++i) {
        if (head(container.children[i]) == lower_ascii(wanted)) return &container.children[i];
    }
    throw AdapterError("missing " + wanted + " section");
}

static void collect_effect_predicates(const Node &expr, std::set<std::string> *out) {
    if (expr.atom || expr.children.empty()) return;
    const std::string h = head(expr);
    if (h == "and") {
        for (std::size_t i = 1; i < expr.children.size(); ++i) collect_effect_predicates(expr.children[i], out);
    } else if (h == "when") {
        if (expr.children.size() >= 3) collect_effect_predicates(expr.children[2], out);
    } else if (h == "forall" || h == "exists") {
        if (expr.children.size() >= 2) collect_effect_predicates(expr.children.back(), out);
    } else if (h == "not") {
        AtomKey key;
        if (expr.children.size() == 2 && atom_key(expr.children[1], &key) && !key.empty()) out->insert(key[0]);
    } else {
        AtomKey key;
        if (atom_key(expr, &key) && !key.empty()) out->insert(key[0]);
    }
}

static std::set<std::string> collect_dynamic_predicates(Node &domain) {
    std::set<std::string> out;
    for (std::size_t i = 0; i < domain.children.size(); ++i) {
        Node &action = domain.children[i];
        if (head(action) != ":action") continue;
        for (std::size_t j = 0; j + 1 < action.children.size(); ++j) {
            if (action.children[j].atom && lower_ascii(action.children[j].value) == ":effect") {
                collect_effect_predicates(action.children[j + 1], &out);
                break;
            }
        }
    }
    if (out.empty()) throw AdapterError("domain contains no dynamic predicates");
    return out;
}

static std::vector<Node> split_init(Node &init) {
    if (init.children.size() == 2 && head(init.children[1]) == "and") {
        std::vector<Node> result;
        for (std::size_t i = 1; i < init.children[1].children.size(); ++i)
            result.push_back(init.children[1].children[i]);
        return result;
    }
    std::vector<Node> result;
    for (std::size_t i = 1; i < init.children.size(); ++i) result.push_back(init.children[i]);
    return result;
}

static bool selector_name(const std::string &name) {
    const std::string x = lower_ascii(name);
    if (x.size() < 16 || x.compare(0, 7, "igc-ce-") != 0) return false;
    const std::size_t p = x.rfind("-sel-");
    if (p == std::string::npos || p + 9 != x.size()) return false;
    for (std::size_t i = p + 5; i < x.size(); ++i)
        if (x[i] < '0' || x[i] > '9') return false;
    return true;
}

static bool selector_atom(const Node &node, std::string *name) {
    AtomKey key;
    if (!atom_key(node, &key) || key.size() != 1 || !selector_name(key[0])) return false;
    *name = key[0];
    return true;
}

static bool selector_oneof(const Node &form, std::vector<std::string> *selectors) {
    selectors->clear();
    if (head(form) != "oneof" || form.children.size() < 2) return false;
    for (std::size_t i = 1; i < form.children.size(); ++i) {
        std::string name;
        if (!selector_atom(form.children[i], &name)) {
            selectors->clear();
            return false;
        }
        selectors->push_back(name);
    }
    return true;
}

static bool selector_implication(const Node &form, std::string *selector,
                                 AtomKey *key, bool *positive) {
    if (head(form) != "or" || form.children.size() != 3) return false;
    for (int pass = 0; pass < 2; ++pass) {
        const int si = pass == 0 ? 1 : 2;
        const int li = pass == 0 ? 2 : 1;
        const Node &neg = form.children[si];
        if (head(neg) != "not" || neg.children.size() != 2) continue;
        if (selector_atom(neg.children[1], selector) && literal_info(form.children[li], key, positive)) return true;
    }
    return false;
}

static void set_assignment(Assignment *a, const AtomKey &key, bool value,
                           const std::string &source) {
    Assignment::iterator it = a->find(key);
    if (it != a->end() && it->second != value) {
        std::ostringstream msg;
        msg << "contradictory assignment from " << source << ':';
        for (std::size_t i = 0; i < key.size(); ++i) msg << ' ' << key[i];
        throw AdapterError(msg.str());
    }
    (*a)[key] = value;
}

static std::string assignment_signature(const Assignment &a) {
    std::ostringstream out;
    for (Assignment::const_iterator it = a.begin(); it != a.end(); ++it) {
        for (std::size_t i = 0; i < it->first.size(); ++i) out << it->first[i] << '\037';
        out << (it->second ? '1' : '0') << '\036';
    }
    return out.str();
}

static void remove_selector_predicates(Node &predicates) {
    std::vector<Node> kept;
    if (!predicates.children.empty()) kept.push_back(predicates.children[0]);
    for (std::size_t i = 1; i < predicates.children.size(); ++i) {
        std::string name;
        if (!selector_atom(predicates.children[i], &name)) kept.push_back(predicates.children[i]);
    }
    predicates.children.swap(kept);
}

static std::string flat_render(const Node &node) {
    if (node.atom) return node.value;
    std::ostringstream out;
    out << '(';
    for (std::size_t i = 0; i < node.children.size(); ++i) {
        if (i) out << ' ';
        out << flat_render(node.children[i]);
    }
    out << ')';
    return out.str();
}

static void render_node(const Node &node, std::ostream &out, int indent) {
    if (node.atom) {
        out << node.value;
        return;
    }
    const std::string compact = flat_render(node);
    bool all_atoms = true;
    for (std::size_t i = 1; i < node.children.size(); ++i)
        if (!node.children[i].atom) all_atoms = false;
    if (all_atoms && indent + static_cast<int>(compact.size()) <= 100) {
        out << compact;
        return;
    }
    if (node.children.empty()) {
        out << "()";
        return;
    }
    out << '(';
    render_node(node.children[0], out, indent + 1);
    for (std::size_t i = 1; i < node.children.size(); ++i) {
        out << '\n' << std::string(indent + 2, ' ');
        render_node(node.children[i], out, indent + 2);
    }
    out << ')';
}

static std::string render_all(const std::vector<Node> &forms) {
    std::ostringstream out;
    for (std::size_t i = 0; i < forms.size(); ++i) {
        if (i) out << "\n\n";
        render_node(forms[i], out, 0);
    }
    out << '\n';
    return out.str();
}

static bool read_file(const std::string &path, std::string *content) {
    std::ifstream in(path.c_str(), std::ios::in | std::ios::binary);
    if (!in) return false;
    std::ostringstream buffer;
    buffer << in.rdbuf();
    *content = buffer.str();
    return in.good() || in.eof();
}

static bool write_file(const std::string &path, const std::string &content) {
    const std::string tmp = path + ".tmp";
    std::ofstream out(tmp.c_str(), std::ios::out | std::ios::binary | std::ios::trunc);
    if (!out) return false;
    out.write(content.data(), static_cast<std::streamsize>(content.size()));
    out.close();
    if (!out) return false;
    if (std::rename(tmp.c_str(), path.c_str()) != 0) {
        std::remove(tmp.c_str());
        return false;
    }
    return true;
}

struct Stats {
    std::size_t projected_worlds;
    std::size_t encoded_atoms;
    std::size_t common_atoms;
    std::size_t varying_atoms;
    std::size_t emitted_or_groups;
    std::size_t emitted_oneof_groups;
    std::size_t removed_direct_dynamic_literals;
    std::size_t removed_static_negative_literals;
    std::size_t replaced_selector_constraints;
    std::string encoding;
    Stats() : projected_worlds(0), encoded_atoms(0), common_atoms(0), varying_atoms(0),
              emitted_or_groups(0), emitted_oneof_groups(0),
              removed_direct_dynamic_literals(0), removed_static_negative_literals(0),
              replaced_selector_constraints(0) {}
};

static Stats adapt(std::vector<Node> *forms) {
    Node *domain = find_define(*forms, "domain");
    Node *problem = find_define(*forms, "problem");
    Node *predicates = find_section(*domain, ":predicates");
    Node *init = find_section(*problem, ":init");
    const std::set<std::string> dynamic = collect_dynamic_predicates(*domain);

    std::vector<std::string> selectors;
    Assignment common;
    std::map<std::string, Assignment> per_selector;
    std::vector<Node> retained;
    Stats stats;

    const std::vector<Node> init_forms = split_init(*init);
    for (std::size_t i = 0; i < init_forms.size(); ++i) {
        std::vector<std::string> group;
        if (selector_oneof(init_forms[i], &group)) {
            if (!selectors.empty() && selectors != group)
                throw AdapterError("multiple incompatible selector ONEOF groups");
            selectors = group;
            for (std::size_t j = 0; j < group.size(); ++j) per_selector[group[j]];
            ++stats.replaced_selector_constraints;
            continue;
        }
        std::string selector;
        AtomKey key;
        bool positive = false;
        if (selector_implication(init_forms[i], &selector, &key, &positive)) {
            set_assignment(&per_selector[selector], key, positive, "selector implication");
            if (std::find(selectors.begin(), selectors.end(), selector) == selectors.end())
                selectors.push_back(selector);
            ++stats.replaced_selector_constraints;
            continue;
        }
        const std::string h = head(init_forms[i]);
        if (h == "oneof" || h == "or" || h == "unknown")
            throw AdapterError("unexpected non-selector uncertainty form: " + flat_render(init_forms[i]));

        if (literal_info(init_forms[i], &key, &positive)) {
            if (!key.empty() && dynamic.find(key[0]) != dynamic.end()) {
                set_assignment(&common, key, positive, "direct dynamic literal");
                ++stats.removed_direct_dynamic_literals;
                continue;
            }
            if (!positive) {
                ++stats.removed_static_negative_literals;
                continue;
            }
        }
        retained.push_back(init_forms[i]);
    }

    if (common.empty() && per_selector.empty())
        throw AdapterError("refined problem contains no dynamic sample assignments");

    std::vector<Assignment> worlds;
    if (selectors.empty()) {
        worlds.push_back(common);
    } else {
        for (std::size_t i = 0; i < selectors.size(); ++i) {
            Assignment world = common;
            const Assignment &specific = per_selector[selectors[i]];
            for (Assignment::const_iterator it = specific.begin(); it != specific.end(); ++it)
                set_assignment(&world, it->first, it->second, selectors[i]);
            worlds.push_back(world);
        }
    }

    std::set<AtomKey> keys;
    for (std::size_t i = 0; i < worlds.size(); ++i)
        for (Assignment::const_iterator it = worlds[i].begin(); it != worlds[i].end(); ++it)
            keys.insert(it->first);
    if (keys.empty()) throw AdapterError("sample projection is empty");
    for (std::size_t i = 0; i < worlds.size(); ++i) {
        for (std::set<AtomKey>::const_iterator it = keys.begin(); it != keys.end(); ++it)
            if (worlds[i].find(*it) == worlds[i].end())
                throw AdapterError("sample world lacks a dynamic assignment");
    }

    std::set<std::string> unique;
    std::vector<Assignment> dedup;
    for (std::size_t i = 0; i < worlds.size(); ++i) {
        const std::string sig = assignment_signature(worlds[i]);
        if (unique.insert(sig).second) dedup.push_back(worlds[i]);
    }
    worlds.swap(dedup);
    stats.projected_worlds = worlds.size();
    stats.encoded_atoms = keys.size();

    remove_selector_predicates(*predicates);

    std::vector<AtomKey> common_keys;
    std::vector<AtomKey> varying_keys;
    for (std::set<AtomKey>::const_iterator it = keys.begin(); it != keys.end(); ++it) {
        bool same = true;
        for (std::size_t wi = 1; wi < worlds.size(); ++wi) {
            if (worlds[wi].find(*it)->second != worlds[0].find(*it)->second) {
                same = false;
                break;
            }
        }
        if (same) common_keys.push_back(*it);
        else varying_keys.push_back(*it);
    }
    stats.common_atoms = common_keys.size();
    stats.varying_atoms = varying_keys.size();

    std::vector<Node> rebuilt = retained;
    for (std::size_t i = 0; i < common_keys.size(); ++i) {
        const bool value = worlds[0].find(common_keys[i])->second;
        const Node lit = literal_node(common_keys[i], value);
        rebuilt.push_back(or_node(lit, lit));
        ++stats.emitted_or_groups;
    }

    if (worlds.size() == 1) {
        stats.encoding = "forced-or-singleton";
    } else if (worlds.size() == 2) {
        stats.encoding = "native-two-world-2cnf";
        if (varying_keys.empty()) throw AdapterError("two distinct worlds have no varying atom");
        const AtomKey pivot = varying_keys[0];
        const Node pivot_pos = literal_node(pivot, true);
        const Node pivot_neg = literal_node(pivot, false);
        std::vector<Node> pivot_choices;
        pivot_choices.push_back(pivot_pos);
        pivot_choices.push_back(pivot_neg);
        rebuilt.push_back(oneof_node(pivot_choices));
        ++stats.emitted_oneof_groups;

        const bool p0 = worlds[0].find(pivot)->second;
        const bool p1 = worlds[1].find(pivot)->second;
        if (p0 == p1) throw AdapterError("selected pivot does not vary");
        for (std::size_t i = 1; i < varying_keys.size(); ++i) {
            const AtomKey &q = varying_keys[i];
            const bool q0 = worlds[0].find(q)->second;
            const bool q1 = worlds[1].find(q)->second;
            const bool same_relation = (p0 == q0 && p1 == q1);
            if (same_relation) {
                rebuilt.push_back(or_node(pivot_neg, literal_node(q, true)));
                rebuilt.push_back(or_node(pivot_pos, literal_node(q, false)));
            } else {
                if (!(p0 != q0 && p1 != q1))
                    throw AdapterError("two-world relation is not Boolean-complete");
                rebuilt.push_back(or_node(pivot_neg, literal_node(q, false)));
                rebuilt.push_back(or_node(pivot_pos, literal_node(q, true)));
            }
            stats.emitted_or_groups += 2;
        }
    } else {
        stats.encoding = "selector-complete-worlds";
        std::vector<Node> selector_atoms;
        for (std::size_t wi = 0; wi < worlds.size(); ++wi) {
            std::ostringstream name;
            name << "igc-ce-cpa-sel-";
            name.width(4);
            name.fill('0');
            name << wi;
            AtomKey key(1, name.str());
            predicates->children.push_back(atom_node(key));
            selector_atoms.push_back(atom_node(key));
        }
        rebuilt.push_back(oneof_node(selector_atoms));
        ++stats.emitted_oneof_groups;
        for (std::size_t wi = 0; wi < worlds.size(); ++wi) {
            const Node not_selector = not_node(selector_atoms[wi]);
            for (std::set<AtomKey>::const_iterator it = keys.begin(); it != keys.end(); ++it) {
                rebuilt.push_back(or_node(not_selector, literal_node(*it, worlds[wi].find(*it)->second)));
                ++stats.emitted_or_groups;
            }
        }
    }

    Node initial_and;
    initial_and.children.push_back(Node("and"));
    for (std::size_t i = 0; i < rebuilt.size(); ++i) initial_and.children.push_back(rebuilt[i]);
    init->children.clear();
    init->children.push_back(Node(":init"));
    init->children.push_back(initial_and);
    return stats;
}

static std::string json_escape(const std::string &s) {
    std::ostringstream out;
    for (std::size_t i = 0; i < s.size(); ++i) {
        const char c = s[i];
        if (c == '"' || c == '\\') out << '\\' << c;
        else if (c == '\n') out << "\\n";
        else out << c;
    }
    return out.str();
}

static std::string stats_json(const Stats &s) {
    std::ostringstream out;
    out << "{\n"
        << "  \"schema_version\": \"ce-planner-cpa-cpp-adapter-v2\",\n"
        << "  \"encoding\": \"" << json_escape(s.encoding) << "\",\n"
        << "  \"projected_worlds\": " << s.projected_worlds << ",\n"
        << "  \"encoded_atoms\": " << s.encoded_atoms << ",\n"
        << "  \"common_atoms\": " << s.common_atoms << ",\n"
        << "  \"varying_atoms\": " << s.varying_atoms << ",\n"
        << "  \"emitted_oneof_groups\": " << s.emitted_oneof_groups << ",\n"
        << "  \"emitted_or_groups\": " << s.emitted_or_groups << ",\n"
        << "  \"removed_direct_dynamic_literals\": " << s.removed_direct_dynamic_literals << ",\n"
        << "  \"removed_static_negative_literals\": " << s.removed_static_negative_literals << ",\n"
        << "  \"replaced_selector_constraints\": " << s.replaced_selector_constraints << "\n"
        << "}\n";
    return out.str();
}

static std::string dirname_of(const std::string &path) {
    const std::size_t p = path.find_last_of("/\\");
    return p == std::string::npos ? "." : path.substr(0, p);
}

int main(int argc, char **argv) {
    if (argc != 2) {
        std::cerr << "Usage: cpa_refined_adapter <combined-domain-problem.pddl>\n";
        return 2;
    }
    try {
        const std::string path = argv[1];
        std::string original;
        if (!read_file(path, &original)) throw AdapterError("cannot read " + path);
        std::vector<Node> forms = parse_all(original);
        const Stats stats = adapt(&forms);
        const std::string adapted = render_all(forms);
        (void)parse_all(adapted);

        const std::string backup = path + ".before-cpa-adapter";
        std::ifstream existing(backup.c_str());
        if (!existing.good() && !write_file(backup, original))
            throw AdapterError("cannot write backup " + backup);
        if (!write_file(path, adapted)) throw AdapterError("cannot replace " + path);
        const std::string metadata = dirname_of(path) + "/cpa-pddl-adapter.json";
        if (!write_file(metadata, stats_json(stats)))
            throw AdapterError("cannot write " + metadata);

        std::cout << "[CPA-PDDL-ADAPTER] implementation=C++ encoding=" << stats.encoding
                  << " projected_worlds=" << stats.projected_worlds
                  << " encoded_atoms=" << stats.encoded_atoms
                  << " common_atoms=" << stats.common_atoms
                  << " varying_atoms=" << stats.varying_atoms
                  << " oneof=" << stats.emitted_oneof_groups
                  << " or=" << stats.emitted_or_groups << std::endl;
        return 0;
    } catch (const std::exception &e) {
        std::cerr << "[CPA-PDDL-ADAPTER] ERROR: " << e.what() << std::endl;
        return 65;
    }
}
