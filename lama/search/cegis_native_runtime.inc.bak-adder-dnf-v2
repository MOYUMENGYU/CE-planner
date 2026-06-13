    StatusCode run_native(const std::string &domain,
                          const std::string &problem,
                          const std::string &iter_dir,
                          int timeout_seconds,
                          std::string *result_path) const {
        if (kind_ == CANDIDATE_PLANNER_T1)
            return run_t1_native(domain, problem, iter_dir, timeout_seconds, result_path);
        if (kind_ == CANDIDATE_PLANNER_CFF)
            return run_cff_native(domain, problem, iter_dir, timeout_seconds, result_path);
        if (kind_ == CANDIDATE_PLANNER_CPAH)
            return run_cpah_native(domain, problem, iter_dir, timeout_seconds, result_path);
        if (kind_ == CANDIDATE_PLANNER_IGC_ORIGIN ||
            kind_ == CANDIDATE_PLANNER_GC_LAMA)
            return run_gc_family_native(domain, problem, iter_dir, timeout_seconds, result_path);
        if (kind_ == CANDIDATE_PLANNER_GCPCES)
            return run_gcpces_native(domain, problem, iter_dir, timeout_seconds, result_path);
        if (kind_ == CANDIDATE_PLANNER_ICPCES) {
            const StatusCode st = run_icpces(
                domain, problem, iter_dir, timeout_seconds, result_path);
            if (st == STATUS_OK)
                ::unlink((iter_dir + "/icpces-output.plan").c_str());
            return st;
        }
        return run_cpa_family_native(
            domain, problem, iter_dir, timeout_seconds, result_path);
    }

    StatusCode run_t1_native(const std::string &domain,
                             const std::string &problem,
                             const std::string &iter_dir,
                             int timeout_seconds,
                             std::string *result_path) const {
        const std::string prefix = "[T1-RUNNER]";
        const std::string stable = iter_dir + "/planner.result";
        const std::string stdout_path = iter_dir + "/planner.stdout";
        const std::string stderr_path = iter_dir + "/planner.stderr";
        const std::string mock = getenv_string("IGC_T1_MOCK_RESULT", "");
        if (!mock.empty()) {
            std::cout << prefix << " mock mode; copying " << mock << std::endl;
            if (!copy_file(mock, stable)) return STATUS_IO_ERROR;
            if (result_path) *result_path = stable;
            return STATUS_OK;
        }

        const std::string exec_abs = absolute_path(
            getenv_string("IGC_T1_EXEC", "./T1/t1"));
        if (!executable_file(exec_abs)) {
            std::cout << prefix << " executable is missing or not executable: "
                      << exec_abs << std::endl;
            return STATUS_PLANNER_FAILED;
        }
        const std::string root = path_dirname(exec_abs);
        const std::string native_result = root + "/planner.result";
        const std::string c2d_error_path = root + "/c2d.stderr";
        const std::string args = getenv_string(
            "IGC_T1_ARGS", "-p -x -S dqbfs -f 10 -X count -W 1");

        ::unlink(native_result.c_str());
        ::unlink((root + "/c2d.stdout").c_str());
        ::unlink(c2d_error_path.c_str());
        ::unlink((root + "/inp.cnf.nnf").c_str());
        ::unlink(stable.c_str());
        ::unlink(stdout_path.c_str());
        ::unlink(stderr_path.c_str());

        std::ostringstream command;
        command << "cd " << shell_quote(root) << " && "
                << shell_quote(exec_abs) << ' ' << args
                << " -d " << shell_quote(absolute_path(domain))
                << " -i " << shell_quote(absolute_path(problem))
                << " > " << shell_quote(absolute_path(stdout_path))
                << " 2> " << shell_quote(absolute_path(stderr_path));
        write_file_atomic(iter_dir + "/planner.command", command.str() + "\n");
        std::cout << prefix << " mode=NATIVE cwd=" << root << std::endl;
        std::cout << prefix << " command=" << command.str() << std::endl;

        int exit_code = -1, term_signal = 0;
        StatusCode st = run_shell_command(
            command.str(), timeout_seconds, prefix, &exit_code, &term_signal);
        if (st != STATUS_OK) {
            if (term_signal)
                std::cout << prefix << " process terminated by signal="
                          << term_signal << std::endl;
            else if (exit_code >= 0)
                std::cout << prefix << " process exit_code="
                          << exit_code << std::endl;
            print_common_diagnostics(
                prefix, stdout_path, stderr_path, c2d_error_path);
            return st;
        }

        const std::string c2d_error = one_line_excerpt(c2d_error_path, 500);
        const std::string c2d_error_low = lower_ascii(c2d_error);
        if (!c2d_error.empty() &&
            (c2d_error_low.find("error doing execv") != std::string::npos ||
             c2d_error_low.find("check path to compiler") != std::string::npos ||
             c2d_error_low.find("permission denied") != std::string::npos ||
             c2d_error_low.find("not found") != std::string::npos)) {
            std::cout << prefix << " d-DNNF compiler failure: "
                      << c2d_error << std::endl;
            print_common_diagnostics(
                prefix, stdout_path, stderr_path, c2d_error_path);
            return STATUS_PLANNER_FAILED;
        }

        std::string result_text;
        if (!read_file(native_result, &result_text) || result_text.empty()) {
            std::cout << prefix << " planner.result is missing or empty: "
                      << native_result << std::endl;
            print_common_diagnostics(
                prefix, stdout_path, stderr_path, c2d_error_path);
            return STATUS_PLANNER_PARSE_ERROR;
        }
        if (contains_no_plan_marker(result_text))
            return STATUS_PLANNER_NO_PLAN;
        if (!copy_file(native_result, stable)) return STATUS_IO_ERROR;
        if (result_path) *result_path = stable;
        return STATUS_OK;
    }

    StatusCode run_cff_native(const std::string &domain,
                              const std::string &problem,
                              const std::string &iter_dir,
                              int timeout_seconds,
                              std::string *result_path) const {
        const std::string prefix = "[CFF-RUNNER]";
        const std::string stdout_path = iter_dir + "/planner.stdout";
        const std::string stderr_path = iter_dir + "/planner.stderr";
        const std::string stable = iter_dir + "/plan-result";
        const std::string mock = getenv_string("IGC_CFF_MOCK_OUTPUT", "");
        std::string output_text;

        if (!mock.empty()) {
            std::cout << prefix << " mock mode; copying " << mock << std::endl;
            if (!copy_file(mock, stdout_path)) return STATUS_IO_ERROR;
            if (!read_file(stdout_path, &output_text)) return STATUS_IO_ERROR;
        } else {
            const std::string configured_exec = trim(
                getenv_string("IGC_CFF_EXEC", ""));
            const std::string root = cff_runtime_root();
            const std::string exec_abs = configured_exec.empty()
                ? root + "/ff" : absolute_path(configured_exec);
            if (!executable_file(exec_abs)) {
                std::cout << prefix
                          << " executable is missing or not executable: "
                          << exec_abs << std::endl;
                return STATUS_PLANNER_FAILED;
            }
            const std::string cwd = path_dirname(exec_abs);
            const std::string args = trim(
                getenv_string("IGC_CFF_ARGS", ""));
            ::unlink(stdout_path.c_str());
            ::unlink(stderr_path.c_str());
            ::unlink(stable.c_str());

            std::ostringstream command;
            command << "cd " << shell_quote(cwd) << " && "
                    << shell_quote(exec_abs);
            if (!args.empty()) command << ' ' << args;
            command << " -o " << shell_quote(absolute_path(domain))
                    << " -f " << shell_quote(absolute_path(problem))
                    << " > " << shell_quote(absolute_path(stdout_path))
                    << " 2> " << shell_quote(absolute_path(stderr_path));
            write_file_atomic(iter_dir + "/planner.command", command.str() + "\n");
            std::cout << prefix << " mode=NATIVE cwd=" << cwd << std::endl;
            std::cout << prefix << " command=" << command.str() << std::endl;

            int exit_code = -1, term_signal = 0;
            const StatusCode run_status = run_shell_command(
                command.str(), timeout_seconds, prefix,
                &exit_code, &term_signal);
            if (!read_file(stdout_path, &output_text))
                output_text.clear();
            if (run_status != STATUS_OK) {
                std::vector<std::string> probe_actions;
                std::string probe_error;
                const StatusCode probe_status =
                    extract_cff_console_plan_actions(
                        output_text, &probe_actions, &probe_error);
                if (probe_status == STATUS_PLANNER_NO_PLAN)
                    return STATUS_PLANNER_NO_PLAN;
                if (probe_status != STATUS_OK) {
                    if (term_signal > 0)
                        std::cout << prefix << " signal="
                                  << term_signal << std::endl;
                    else if (exit_code >= 0)
                        std::cout << prefix << " exit_code="
                                  << exit_code << std::endl;
                    print_common_diagnostics(
                        prefix, stdout_path, stderr_path, "");
                    return run_status;
                }
                std::cout << prefix
                          << " accepted CFF console outcome despite process exit_code="
                          << exit_code << std::endl;
            }
        }

        std::vector<std::string> actions;
        std::string parse_error;
        const StatusCode parsed = extract_cff_console_plan_actions(
            output_text, &actions, &parse_error);
        if (parsed != STATUS_OK) {
            std::cout << prefix << " plan extraction failed: "
                      << parse_error << std::endl;
            print_common_diagnostics(
                prefix, stdout_path, stderr_path, "");
            return parsed;
        }
        if (!write_plain_plan_artifact(actions, stable))
            return STATUS_IO_ERROR;
        std::ostringstream source;
        source << "{\"primary_planner\":\"CFF\""
               << ",\"primary_status\":\"EXPLICIT_PLAN\""
               << ",\"runtime\":\"native_project_directory\""
               << ",\"artifact\":\"planner.stdout\""
               << ",\"actions\":" << actions.size() << "}\n";
        write_file_atomic(iter_dir + "/candidate-source.json", source.str());
        if (result_path) *result_path = stable;
        return STATUS_OK;
    }

    StatusCode run_gc_family_native(const std::string &domain,
                                    const std::string &problem,
                                    const std::string &iter_dir,
                                    int timeout_seconds,
                                    std::string *result_path) const {
        const bool igc = kind_ == CANDIDATE_PLANNER_IGC_ORIGIN;
        const std::string prefix = igc
            ? "[iGC-RUNNER]" : "[GC-LAMA-RUNNER]";
        const std::string stdout_path = iter_dir + "/planner.stdout";
        const std::string stderr_path = iter_dir + "/planner.stderr";
        const std::string stable = iter_dir + "/plan-result";
        const std::string mock = getenv_string(
            igc ? "IGC_IGC_MOCK_OUTPUT" : "IGC_GC_LAMA_MOCK_OUTPUT", "");
        if (!mock.empty()) {
            std::string text;
            if (!read_file(mock, &text)) return STATUS_IO_ERROR;
            std::vector<std::string> parsed;
            std::string parse_error;
            StatusCode st = extract_gc_console_plan_actions(
                text, kind_, &parsed, &parse_error);
            if (st != STATUS_OK)
                st = extract_plain_plan_actions(text, &parsed, &parse_error);
            if (st != STATUS_OK) {
                std::cout << prefix << " mock parse failure: "
                          << parse_error << std::endl;
                return st;
            }
            if (!write_plain_plan_artifact(parsed, stable))
                return STATUS_IO_ERROR;
            copy_file(mock, stdout_path);
            if (result_path) *result_path = stable;
            return STATUS_OK;
        }

        const std::string root = gc_family_runtime_root();
        const std::string translator = root + "/lama/translate/translate.py";
        const std::string preprocess = root + "/lama/preprocess/preprocess";
        const std::string search_exec = root + "/lama/search/release-search";
        if (!readable_regular_file(translator) ||
            !executable_file(preprocess) ||
            !executable_file(search_exec)) {
            std::cout << prefix
                      << " native runtime is incomplete or not executable under "
                      << root << std::endl;
            return STATUS_PLANNER_FAILED;
        }

        const std::string python = getenv_string(
            igc ? "IGC_IGC_PYTHON" : "IGC_GC_LAMA_PYTHON",
            getenv_string("IGC_GC_PYTHON", "python2"));
        const std::string flags = getenv_string(
            igc ? "IGC_IGC_SEARCH_FLAGS" : "IGC_GC_LAMA_SEARCH_FLAGS",
            igc ? "pdaMfF" : "fF");
        const std::string result_prefix = root + "/result";
        ::unlink(stdout_path.c_str());
        ::unlink(stderr_path.c_str());
        ::unlink(stable.c_str());

        std::ostringstream frontend;
        frontend << "( cd " << shell_quote(root) << " && "
                 << "rm -f trans_file output.sas output belief oneof oneof_initial "
                 << "oneofcombine all.groups test.groups finalplan C_Plan result result.* "
                 << "runtime-normalization.json && "
                 << shell_quote(python) << ' ' << shell_quote(translator) << ' '
                 << shell_quote(absolute_path(domain)) << ' '
                 << shell_quote(absolute_path(problem)) << " > trans_file && "
                 << "test -s output.sas && "
                 << shell_quote(preprocess)
                 << " < output.sas && test -s output )"
                 << " > " << shell_quote(absolute_path(stdout_path))
                 << " 2> " << shell_quote(absolute_path(stderr_path));

        std::ostringstream search;
        search << "( cd " << shell_quote(root) << " && "
               << shell_quote(search_exec) << ' ' << shell_quote(flags) << ' '
               << shell_quote(result_prefix) << " false < output )"
               << " >> " << shell_quote(absolute_path(stdout_path))
               << " 2>> " << shell_quote(absolute_path(stderr_path));

        std::ostringstream recorded;
        recorded << frontend.str() << "\n"
                 << "# adapter runtime normalization occurs here\n"
                 << search.str() << "\n";
        write_file_atomic(iter_dir + "/planner.command", recorded.str());
        std::cout << prefix << " mode=NATIVE cwd=" << root << std::endl;
        std::cout << prefix << " frontend_command="
                  << frontend.str() << std::endl;

        int exit_code = -1, term_signal = 0;
        StatusCode st = run_shell_command(
            frontend.str(), timeout_seconds,
            prefix + "[frontend]", &exit_code, &term_signal);
        if (st != STATUS_OK) {
            if (term_signal > 0)
                std::cout << prefix << " frontend signal="
                          << term_signal << std::endl;
            else if (exit_code >= 0)
                std::cout << prefix << " frontend exit_code="
                          << exit_code << std::endl;
            print_common_diagnostics(
                prefix, stdout_path, stderr_path, root + "/trans_file");
            return st;
        }

        std::string normalization;
        st = normalize_gc_family_frontend(
            root, absolute_path(problem), igc, &normalization);
        if (st != STATUS_OK) {
            std::cout << prefix << " runtime normalization failed: "
                      << normalization << std::endl;
            print_common_diagnostics(
                prefix, stdout_path, stderr_path, root + "/trans_file");
            return st;
        }
        std::cout << prefix << " normalization="
                  << normalization << std::endl;
        std::cout << prefix << " search_command="
                  << search.str() << std::endl;

        exit_code = -1;
        term_signal = 0;
        st = run_shell_command(
            search.str(), timeout_seconds,
            prefix + "[search]", &exit_code, &term_signal);
        std::string stdout_text;
        read_file(stdout_path, &stdout_text);
        if (st != STATUS_OK) {
            if (contains_no_plan_marker(stdout_text))
                return STATUS_PLANNER_NO_PLAN;
            if (term_signal > 0)
                std::cout << prefix << " search signal="
                          << term_signal << std::endl;
            else if (exit_code >= 0)
                std::cout << prefix << " search exit_code="
                          << exit_code << std::endl;
            print_common_diagnostics(
                prefix, stdout_path, stderr_path, root + "/trans_file");
            return st;
        }

        std::vector<std::string> actions;
        std::string parse_error;
        std::string artifact;
        const std::string finalplan = root + "/finalplan";
        const std::string c_plan = root + "/C_Plan";
        std::string final_text;
        struct stat final_stat;
        if (::stat(finalplan.c_str(), &final_stat) == 0 &&
            S_ISREG(final_stat.st_mode)) {
            read_file(finalplan, &final_text);
            if (final_text.empty()) {
                const bool success = igc
                    ? stdout_text.find("没有反例，找到最终解！") != std::string::npos
                    : lower_ascii(stdout_text).find("\nfinal plan\n") != std::string::npos;
                if (success) {
                    actions.clear();
                    st = STATUS_OK;
                } else {
                    st = STATUS_PLANNER_PARSE_ERROR;
                    parse_error =
                        "empty finalplan without a final-plan success marker";
                }
            } else {
                st = extract_plain_plan_actions(
                    final_text, &actions, &parse_error);
            }
            if (st == STATUS_OK) artifact = "finalplan";
        } else {
            st = STATUS_PLANNER_PARSE_ERROR;
            parse_error = "finalplan is missing";
        }

        if (st != STATUS_OK && readable_regular_file(c_plan)) {
            std::string c_text;
            if (read_file(c_plan, &c_text)) {
                std::string c_error;
                const StatusCode c_status = extract_cpah_plan_actions(
                    c_text, &actions, &c_error);
                if (c_status == STATUS_OK) {
                    st = STATUS_OK;
                    artifact = "C_Plan";
                } else if (!c_error.empty()) {
                    parse_error = c_error;
                }
            }
        }
        if (st != STATUS_OK) {
            std::string console_error;
            const StatusCode console_status =
                extract_gc_console_plan_actions(
                    stdout_text, kind_, &actions, &console_error);
            if (console_status == STATUS_OK) {
                st = STATUS_OK;
                artifact = "planner.stdout";
            } else if (!console_error.empty()) {
                parse_error = console_error;
            }
        }
        if (st != STATUS_OK) {
            std::cout << prefix << " plan extraction failed: "
                      << parse_error << std::endl;
            print_common_diagnostics(
                prefix, stdout_path, stderr_path, root + "/trans_file");
            return st;
        }

        if (!write_plain_plan_artifact(actions, stable))
            return STATUS_IO_ERROR;
        std::ostringstream source;
        source << "{\"primary_planner\":\""
               << candidate_planner_display_name(kind_)
               << "\",\"primary_status\":\"EXPLICIT_PLAN\""
               << ",\"runtime\":\"native_project_directory\""
               << ",\"artifact\":\"" << artifact << "\""
               << ",\"actions\":" << actions.size() << "}\n";
        write_file_atomic(iter_dir + "/candidate-source.json", source.str());
        if (result_path) *result_path = stable;
        return STATUS_OK;
    }

    StatusCode run_gcpces_native(const std::string &domain,
                                 const std::string &problem,
                                 const std::string &iter_dir,
                                 int timeout_seconds,
                                 std::string *result_path) const {
        const std::string prefix = "[gCPCES-RUNNER]";
        const std::string stdout_path = iter_dir + "/planner.stdout";
        const std::string stderr_path = iter_dir + "/planner.stderr";
        const std::string stable = iter_dir + "/plan-result";
        const std::string raw_plan = iter_dir + "/gcpces.raw.plan";
        const std::string mock = getenv_string("IGC_GCPCES_MOCK_OUTPUT", "");
        if (!mock.empty()) {
            if (!copy_file(mock, stdout_path)) return STATUS_IO_ERROR;
            std::string text;
            if (!read_file(stdout_path, &text)) return STATUS_IO_ERROR;
            std::vector<std::string> actions;
            std::string parse_error;
            const StatusCode parsed = extract_gcpces_console_plan_actions(
                text, &actions, &parse_error);
            if (parsed != STATUS_OK) return parsed;
            if (!write_plain_plan_artifact(actions, stable))
                return STATUS_IO_ERROR;
            if (result_path) *result_path = stable;
            return STATUS_OK;
        }

        const std::string root = gcpces_runtime_root();
        if (!readable_regular_file(root + "/build/main.class") ||
            !readable_directory(root + "/libs")) {
            std::cout << prefix << " missing build/main.class or libs under "
                      << root << std::endl;
            return STATUS_PLANNER_FAILED;
        }
        if (!executable_file(root + "/ff")) {
            std::cout << prefix
                      << " default classical planner is missing or not executable: "
                      << root + "/ff" << std::endl;
            return STATUS_PLANNER_FAILED;
        }
        const std::string java_exec = getenv_string(
            "IGC_GCPCES_JAVA", "java");
        const std::string args = trim(
            getenv_string("IGC_GCPCES_ARGS", ""));
        const std::string classpath = root + "/build:" + root + "/libs/*";
        ::unlink(stdout_path.c_str());
        ::unlink(stderr_path.c_str());
        ::unlink(raw_plan.c_str());
        ::unlink(stable.c_str());

        std::ostringstream command;
        command << "( cd " << shell_quote(root) << " && "
                << "export LD_LIBRARY_PATH=" << shell_quote(root + "/libs")
                << "${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}; "
                << shell_quote(java_exec)
                << " -Djava.library.path=" << shell_quote(root + "/libs")
                << " -classpath " << shell_quote(classpath)
                << " main -o " << shell_quote(absolute_path(domain))
                << " -f " << shell_quote(absolute_path(problem))
                << " -op " << shell_quote(absolute_path(raw_plan));
        if (!args.empty()) command << ' ' << args;
        command << " ) > " << shell_quote(absolute_path(stdout_path))
                << " 2> " << shell_quote(absolute_path(stderr_path));
        write_file_atomic(iter_dir + "/planner.command", command.str() + "\n");
        std::cout << prefix << " mode=NATIVE cwd=" << root << std::endl;
        std::cout << prefix << " command=" << command.str() << std::endl;

        int exit_code = -1, term_signal = 0;
        StatusCode st = run_shell_command(
            command.str(), timeout_seconds, prefix,
            &exit_code, &term_signal);
        std::string stdout_text;
        read_file(stdout_path, &stdout_text);
        if (st != STATUS_OK) {
            if (lower_ascii(stdout_text).find("unsolvable") != std::string::npos)
                return STATUS_PLANNER_NO_PLAN;
            if (term_signal > 0)
                std::cout << prefix << " process signal="
                          << term_signal << std::endl;
            else if (exit_code >= 0)
                std::cout << prefix << " process exit_code="
                          << exit_code << std::endl;
            print_common_diagnostics(
                prefix, stdout_path, stderr_path, std::string());
            return st;
        }

        std::vector<std::string> actions;
        std::string parse_error;
        bool artifact_used = false;
        std::string raw_text;
        if (read_file(raw_plan, &raw_text)) {
            if (!raw_text.empty()) {
                st = extract_plain_plan_actions(
                    raw_text, &actions, &parse_error);
                artifact_used = st == STATUS_OK;
            } else {
                st = extract_gcpces_console_plan_actions(
                    stdout_text, &actions, &parse_error);
            }
        } else {
            st = extract_gcpces_console_plan_actions(
                stdout_text, &actions, &parse_error);
        }
        if (st != STATUS_OK) {
            std::cout << prefix << " plan extraction failed: "
                      << parse_error << std::endl;
            print_common_diagnostics(
                prefix, stdout_path, stderr_path, std::string());
            return st;
        }
        if (!write_plain_plan_artifact(actions, stable))
            return STATUS_IO_ERROR;
        std::ostringstream source;
        source << "{\"primary_planner\":\"gCPCES\""
               << ",\"primary_status\":\"EXPLICIT_PLAN\""
               << ",\"materializer\":\"gCPCES\""
               << ",\"runtime\":\"native_project_directory\""
               << ",\"artifact\":\""
               << (artifact_used ? "-op plan file" : "planner.stdout")
               << "\",\"actions\":" << actions.size() << "}\n";
        write_file_atomic(iter_dir + "/candidate-source.json", source.str());
        if (result_path) *result_path = stable;
        return STATUS_OK;
    }

    StatusCode run_cpah_native(const std::string &domain,
                               const std::string &problem,
                               const std::string &iter_dir,
                               int timeout_seconds,
                               std::string *result_path) const {
        const std::string prefix = "[CPAH-RUNNER]";
        const std::string stdout_path = iter_dir + "/planner.stdout";
        const std::string stderr_path = iter_dir + "/planner.stderr";
        const std::string stable = iter_dir + "/plan-result";
        const std::string mock = getenv_string("IGC_CPAH_MOCK_OUTPUT", "");
        if (!mock.empty()) {
            if (!copy_file(mock, stdout_path)) return STATUS_IO_ERROR;
            std::string text;
            if (!read_file(stdout_path, &text)) return STATUS_IO_ERROR;
            std::vector<std::string> actions;
            std::string parse_error;
            const StatusCode parsed = extract_cpah_plan_actions(
                text, &actions, &parse_error);
            if (parsed != STATUS_OK) return parsed;
            if (!write_plain_plan_artifact(actions, stable))
                return STATUS_IO_ERROR;
            if (result_path) *result_path = stable;
            return STATUS_OK;
        }

        const std::string root = cpa_runtime_root();
        if (!executable_file(root + "/cpa.pddl2pl") ||
            !readable_regular_file(root + "/mult5zsic.pl") ||
            !executable_file(root + "/CPAH")) {
            std::cout << prefix << " native runtime is incomplete under "
                      << root << std::endl;
            return STATUS_PLANNER_FAILED;
        }
        const std::string sicstus = getenv_string(
            "IGC_SICSTUS_EXEC", "sicstus");
        const std::string native_result = root + "/plan-result";
        ::unlink(stdout_path.c_str());
        ::unlink(stderr_path.c_str());
        ::unlink(stable.c_str());
        ::unlink(native_result.c_str());

        std::ostringstream pipeline;
        pipeline << "( cd " << shell_quote(root) << " && "
                 << "rm -f case-input.pddl pddl2pl.pl new.pl theory_*.al "
                 << "theory_names temp trash plan-result result-time && "
                 << "cat " << shell_quote(absolute_path(domain)) << ' '
                 << shell_quote(absolute_path(problem))
                 << " > case-input.pddl && "
                 << "./cpa.pddl2pl case-input.pddl && "
                 << "test -s pddl2pl.pl && "
                 << "cat mult5zsic.pl pddl2pl.pl > new.pl && "
                 << shell_quote(sicstus)
                 << " -l new.pl --goal 'main,halt.' > trash && "
                 << "test -s theory_names && "
                 << "./CPAH theory_names > temp && "
                 << "sed -e 's/cpa_//g' temp > plan-result && "
                 << "cat plan-result )"
                 << " > " << shell_quote(absolute_path(stdout_path))
                 << " 2> " << shell_quote(absolute_path(stderr_path));
        write_file_atomic(iter_dir + "/planner.command", pipeline.str() + "\n");
        std::cout << prefix << " mode=NATIVE cwd=" << root << std::endl;
        std::cout << prefix << " command=" << pipeline.str() << std::endl;

        int exit_code = -1, term_signal = 0;
        StatusCode st = run_shell_command(
            pipeline.str(), timeout_seconds, prefix,
            &exit_code, &term_signal);
        if (st != STATUS_OK) {
            if (term_signal)
                std::cout << prefix << " process terminated by signal="
                          << term_signal << std::endl;
            else if (exit_code >= 0)
                std::cout << prefix << " process exit_code="
                          << exit_code << std::endl;
            print_common_diagnostics(
                prefix, stdout_path, stderr_path, root + "/trash");
            return st;
        }

        std::string result_text;
        if (!read_file(native_result, &result_text) || result_text.empty()) {
            std::cout << prefix << " plan-result is missing or empty" << std::endl;
            print_common_diagnostics(
                prefix, stdout_path, stderr_path, root + "/trash");
            return STATUS_PLANNER_PARSE_ERROR;
        }
        std::vector<std::string> actions;
        std::string parse_error;
        st = extract_cpah_plan_actions(
            result_text, &actions, &parse_error);
        if (st != STATUS_OK) {
            if (st == STATUS_PLANNER_NO_PLAN)
                std::cout << prefix
                          << " planner reported no candidate plan" << std::endl;
            else
                std::cout << prefix << " output parse failure: "
                          << parse_error << std::endl;
            print_common_diagnostics(
                prefix, stdout_path, stderr_path, root + "/trash");
            return st;
        }
        if (!copy_file(native_result, stable)) return STATUS_IO_ERROR;
        std::ostringstream source;
        source << "{\"primary_planner\":\"CPAH\""
               << ",\"primary_status\":\"EXPLICIT_PLAN\""
               << ",\"materializer\":\"CPAH\""
               << ",\"runtime\":\"native_project_directory\""
               << ",\"recovered_actions\":0}\n";
        write_file_atomic(iter_dir + "/candidate-source.json", source.str());
        if (result_path) *result_path = stable;
        return STATUS_OK;
    }

    StatusCode run_cpa_family_native(const std::string &domain,
                                     const std::string &problem,
                                     const std::string &iter_dir,
                                     int timeout_seconds,
                                     std::string *result_path) const {
        const std::string prefix = std::string("[") +
            candidate_planner_display_name(kind_) + "-RUNNER]";
        const std::string mock_env = std::string("IGC_") +
            candidate_planner_display_name(kind_) + "_MOCK_OUTPUT";
        const std::string mock = getenv_string(mock_env.c_str(), "");
        const std::string stdout_path = iter_dir + "/planner.stdout";
        const std::string stderr_path = iter_dir + "/planner.stderr";
        const std::string stable = iter_dir + "/plan-result";
        if (!mock.empty()) {
            if (!copy_file(mock, stdout_path)) return STATUS_IO_ERROR;
            if (!copy_file(mock, stable)) return STATUS_IO_ERROR;
            if (result_path) *result_path = stable;
            return STATUS_OK;
        }

        const std::string root = cpa_runtime_root();
        const std::string binary = cpa_binary_name();
        if (!executable_file(root + "/cpa.pddl2pl") ||
            !readable_regular_file(root + "/mult5zsic.pl") ||
            !readable_regular_file(root + "/input") ||
            !executable_file(root + "/" + binary)) {
            std::cout << prefix << " native runtime is incomplete under "
                      << root << std::endl;
            return STATUS_PLANNER_FAILED;
        }
        const std::string sicstus = getenv_string(
            "IGC_SICSTUS_EXEC", "sicstus");
        const std::string native_result = root + "/plan-result";
        const std::string theory_path = root + "/theory_0.al";
        ::unlink(stdout_path.c_str());
        ::unlink(stderr_path.c_str());
        ::unlink(stable.c_str());
        ::unlink(native_result.c_str());

        std::ostringstream pipeline;
        pipeline << "( cd " << shell_quote(root) << " && "
                 << "rm -f dp.pddl pddl2pl.pl new.pl theory_*.al theory_names "
                 << "temp trash plan-result result-time && "
                 << "cat " << shell_quote(absolute_path(domain)) << ' '
                 << shell_quote(absolute_path(problem)) << " > dp.pddl && "
                 << "./cpa.pddl2pl dp.pddl && "
                 << "test -s pddl2pl.pl && "
                 << "cat mult5zsic.pl pddl2pl.pl > new.pl && "
                 << shell_quote(sicstus)
                 << " -l new.pl --goal 'main,halt.' < input > trash && "
                 << "test -s theory_0.al && "
                 << "./" << binary << " theory_0.al > temp && "
                 << "sed -e 's/cpa_//g' temp > plan-result && "
                 << "cat plan-result )"
                 << " > " << shell_quote(absolute_path(stdout_path))
                 << " 2> " << shell_quote(absolute_path(stderr_path));
        write_file_atomic(iter_dir + "/planner.command", pipeline.str() + "\n");
        std::cout << prefix << " mode=NATIVE cwd=" << root << std::endl;
        std::cout << prefix << " command=" << pipeline.str() << std::endl;

        int exit_code = -1, term_signal = 0;
        StatusCode st = run_shell_command(
            pipeline.str(), timeout_seconds, prefix,
            &exit_code, &term_signal);
        if (st != STATUS_OK) {
            if (term_signal)
                std::cout << prefix << " process terminated by signal="
                          << term_signal << std::endl;
            else if (exit_code >= 0)
                std::cout << prefix << " process exit_code="
                          << exit_code << std::endl;
            print_common_diagnostics(
                prefix, stdout_path, stderr_path, root + "/trash");
            return st;
        }

        std::string result_text;
        if (!read_file(native_result, &result_text) || result_text.empty()) {
            std::cout << prefix << " plan-result is missing or empty" << std::endl;
            print_common_diagnostics(
                prefix, stdout_path, stderr_path, root + "/trash");
            return STATUS_PLANNER_PARSE_ERROR;
        }
        if (contains_no_plan_marker(result_text))
            return STATUS_PLANNER_NO_PLAN;
        if (!contains_cpa_success_marker(result_text)) {
            std::cout << prefix << " output has no success marker" << std::endl;
            print_common_diagnostics(
                prefix, stdout_path, stderr_path, root + "/trash");
            return STATUS_PLANNER_PARSE_ERROR;
        }

        std::vector<std::string> primary_actions;
        std::string primary_parse_error;
        const StatusCode primary_parse = extract_cpa_plan_actions(
            result_text, &primary_actions, &primary_parse_error);
        if (primary_parse != STATUS_OK &&
            kind_ != CANDIDATE_PLANNER_CNF &&
            env_true("IGC_CPA_PLAN_RECOVERY", true) &&
            primary_parse_error.find("omitted the action sequence") !=
                std::string::npos) {
            const std::string primary_result =
                iter_dir + "/primary-plan-result";
            if (!copy_file(native_result, primary_result))
                return STATUS_IO_ERROR;

            const std::string recovery_exec_env = getenv_string(
                "IGC_CPA_PLAN_RECOVERY_EXEC", "");
            const std::string recovery_exec = recovery_exec_env.empty()
                ? absolute_path(
                    getenv_string("IGC_CNF_DIR", "./cnf_planner") + "/cnf")
                : absolute_path(recovery_exec_env);
            if (!executable_file(recovery_exec)) {
                std::cout << prefix
                          << " recovery executable is missing or not executable: "
                          << recovery_exec << std::endl;
                return STATUS_PLANNER_PARSE_ERROR;
            }
            const std::string recovery_root = path_dirname(recovery_exec);
            const std::string recovery_temp =
                iter_dir + "/recovery.temp";
            const std::string recovery_result =
                iter_dir + "/recovery-plan-result";
            const std::string recovery_stdout =
                iter_dir + "/planner.recovery.stdout";
            const std::string recovery_stderr =
                iter_dir + "/planner.recovery.stderr";
            ::unlink(recovery_temp.c_str());
            ::unlink(recovery_result.c_str());
            ::unlink(recovery_stdout.c_str());
            ::unlink(recovery_stderr.c_str());

            std::ostringstream recovery;
            recovery << "( cd " << shell_quote(recovery_root) << " && "
                     << shell_quote(recovery_exec) << ' '
                     << shell_quote(theory_path)
                     << " > " << shell_quote(absolute_path(recovery_temp))
                     << " && sed -e 's/cpa_//g' "
                     << shell_quote(absolute_path(recovery_temp))
                     << " > " << shell_quote(absolute_path(recovery_result))
                     << " && cat "
                     << shell_quote(absolute_path(recovery_result)) << " )"
                     << " > " << shell_quote(absolute_path(recovery_stdout))
                     << " 2> " << shell_quote(absolute_path(recovery_stderr));
            write_file_atomic(
                iter_dir + "/planner.recovery.command",
                recovery.str() + "\n");
            std::cout << prefix << " recovery_mode=NATIVE cwd="
                      << recovery_root << std::endl;
            std::cout << prefix << " recovery_command="
                      << recovery.str() << std::endl;

            int recovery_exit = -1, recovery_signal = 0;
            const StatusCode recovery_status = run_shell_command(
                recovery.str(), timeout_seconds, prefix + "[RECOVERY]",
                &recovery_exit, &recovery_signal);
            if (recovery_status != STATUS_OK) {
                if (recovery_signal)
                    std::cout << prefix
                              << " recovery terminated by signal="
                              << recovery_signal << std::endl;
                else if (recovery_exit >= 0)
                    std::cout << prefix << " recovery exit_code="
                              << recovery_exit << std::endl;
                print_common_diagnostics(
                    prefix + "[RECOVERY]", recovery_stdout,
                    recovery_stderr, recovery_temp);
                return recovery_status;
            }

            std::string recovery_text;
            if (!read_file(recovery_result, &recovery_text) ||
                recovery_text.empty()) {
                std::cout << prefix
                          << " recovery output is missing or empty" << std::endl;
                return STATUS_PLANNER_PARSE_ERROR;
            }
            std::vector<std::string> recovered_actions;
            std::string recovered_error;
            const StatusCode recovered_parse = extract_cpa_plan_actions(
                recovery_text, &recovered_actions, &recovered_error);
            if (recovered_parse != STATUS_OK || recovered_actions.empty()) {
                std::cout << prefix
                          << " recovery output is not a concrete plan";
                if (!recovered_error.empty())
                    std::cout << ": " << recovered_error;
                std::cout << std::endl;
                return STATUS_PLANNER_PARSE_ERROR;
            }
            if (!copy_file(recovery_result, stable))
                return STATUS_IO_ERROR;
            std::ostringstream source;
            source << "{\"primary_planner\":\""
                   << candidate_planner_display_name(kind_)
                   << "\",\"primary_status\":\"PLAN_WITHOUT_SEQUENCE\""
                   << ",\"materializer\":\"CNF\""
                   << ",\"runtime\":\"native_project_directory\""
                   << ",\"recovered_actions\":"
                   << recovered_actions.size() << "}\n";
            write_file_atomic(
                iter_dir + "/candidate-source.json", source.str());
            if (result_path) *result_path = stable;
            return STATUS_OK;
        }

        if (primary_parse != STATUS_OK) {
            std::cout << prefix << " primary plan output is incomplete: "
                      << primary_parse_error << std::endl;
            return primary_parse;
        }
        if (!copy_file(native_result, stable)) return STATUS_IO_ERROR;
        std::ostringstream source;
        source << "{\"primary_planner\":\""
               << candidate_planner_display_name(kind_)
               << "\",\"primary_status\":\"EXPLICIT_PLAN\""
               << ",\"materializer\":\""
               << candidate_planner_display_name(kind_)
               << "\",\"runtime\":\"native_project_directory\""
               << ",\"recovered_actions\":0}\n";
        write_file_atomic(iter_dir + "/candidate-source.json", source.str());
        if (result_path) *result_path = stable;
        return STATUS_OK;
    }
