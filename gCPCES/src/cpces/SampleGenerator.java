package cpces;

import com.hstairs.ppmajal.conditions.Condition;
import com.hstairs.ppmajal.conditions.Predicate;
import com.hstairs.ppmajal.extraUtils.Pair;
import com.hstairs.ppmajal.plan.SimplePlan;
import com.hstairs.ppmajal.problem.GroundAction;
import com.microsoft.z3.Context;
import com.microsoft.z3.FuncDecl;
import com.microsoft.z3.Solver;
import com.microsoft.z3.Status;
import org.apache.commons.lang3.tuple.ImmutablePair;

import java.util.*;

/**
 * A sample generator is an object that is responsible for computing the sample.
 * It is defined by an initial belief and a goal.
 */
public abstract class SampleGenerator {

    final protected Condition belief;
    final protected Condition goals;
    protected Set<CPCES_State> sample;
    protected Set<CPCES_State> CPCES_sample;
    private final HashMap<ImmutablePair<GroundAction, Predicate>, Condition> actPredicate2Supporter;
    
    //debug variables
    public String lastSMTFormula;
    
    //stats var
    public long ceSTime;//counter-example search time
    private Context ctx;

    /**
     * Creates a sample generator 
     * @param belief
     * @param goals
     */
    protected SampleGenerator(Condition belief, Condition goals) {
        this.belief = belief;
        this.goals = goals;
        HashMap<Predicate, String> pred2str = new HashMap();
        belief.getInvolvedPredicates().forEach((pred) -> {
            pred2str.put(pred, pred.toSmtVariableString(0));
        });
        actPredicate2Supporter = new HashMap();
        ceSTime = 0;
    }


    
    /**
     *
     * @param candidatePlan
     * @return
     */
    public abstract boolean refineCPCESSample(SimplePlan candidatePlan);
    
    /**
     * Returns the sample.  
     * 
     * @return the sample computed by this generator.
     */
    public Set<CPCES_State> getSample() {
        return sample;
    }
    
    /**
     * Returns the sample as a set of CPCES states.  
     * 
     * @return the sample as a set of CPCES states.  
     */
    public abstract Set<CPCES_State> getCPCESSample();

    // 
    // ALBAN: I PROPOSE: 
    // 1. TAKE BELIEF AS INPUT 
    // 2. CALL IT WITH INITIAL_BELIEF IF WE ARE LOOKING FOR A SINGLE COUNTER EXAMPLE
    // 3. CALL IT WITH A SINGLE STATE IF WE ARE TESTING VALIDITY OF A PLAN
    // 
    
    protected CPCES_State computeSingleCounterExample(SimplePlan plan) {
        final HashMap<String, Predicate> string_to_predicate = new HashMap<>();
        final Solver s = callSMTSolver(string_to_predicate, plan);

//        System.out.println("Starting smt resolution....");

        // Analyses the SMT solution
        long start = System.nanoTime();
        final Status sat = s.check();
        this.ceSTime += System.nanoTime()-start;
        if (null != sat) {
            switch (sat) {
                case SATISFIABLE:
                    return extractState(s, string_to_predicate);
                case UNSATISFIABLE:
                    //System.out.println("Problem solved:" + s.getStatistics());
                    return null;//That's great!!!
                default:
                    System.out.println("Unknown sat testing");
                    break;//now we are screwed
            }
        }

        return null;
    }
    
    protected CPCES_State computeSingleCPCESCounterExample(SimplePlan plan) {
        final HashMap<String, Predicate> string_to_predicate = new HashMap<>();
        
        ctx = new Context();
        final Solver s = callSMTSolver(string_to_predicate, plan);

//        System.out.println("Starting smt resolution....");

        // Analyses the SMT solution
        long start = System.nanoTime();
        final Status sat = s.check();
        this.ceSTime += System.nanoTime()-start;
        CPCES_State ce = null;
        if (null != sat) {
            switch (sat) {
                case SATISFIABLE:
                    ce = extractCPCESState(s, string_to_predicate);
                    break;
                case UNSATISFIABLE:
                    //System.out.println("Problem solved:" + s.getStatistics());
                    break;
                default:
                    System.out.println("Unknown sat testing");
                    throw new RuntimeException("There is some problem with the SAT calling, BAILING OUT");
            }
        }
        ctx.close();
        return ce;
    }
    
    private Solver callSMTSolver(Map<String, Predicate> string_to_predicate, SimplePlan plan) { // Calls the SMT Solver
        Solver s;
        HashMap<String, Predicate> str2pred = new HashMap<>();
        Pair<StringBuilder, HashSet<String>> plan_reg = polyRegress_alban(plan, goals, str2pred);
        Collection<Predicate> variables = new HashSet<>();
        
        
//        System.out.println(belief);
        variables.addAll(belief.getInvolvedPredicates());
        
//        variables = new ArrayList(variables);
//        Collections.shuffle((List<?>) variables);
//            System.out.println(variables);
//            long start = System.currentTimeMillis();

        final StringBuilder bui = new StringBuilder();

        { // Declare all variables
            final Set<String> smtVariables = new HashSet<>();

            // Declare the variables from regression
            for (String var : plan_reg.getSecond()) {
                bui.append("(declare-const ").append(var).append(" Bool)\n");
                smtVariables.add(var);
                //I guess here one can support the conformant closed world assumption in the init. If
                // this variable just found isn't mentioned at all in the belief, it needs to be set false,
                // which means changing the belief and adding this not condition. Doing this way, we don't need to
                // anticipate the predicates that are needed, but we can do it in a lazy fashion.
            }
            // Declare the variables in the belief state
            for (Predicate p : variables) {
                if (!p.isValid() && !p.isUnsatisfiable()) {
                    String smt_repr = p.toSmtVariableString(0);
                    if (smtVariables.add(smt_repr)) {
                        bui.append("(declare-const ").append(smt_repr).append(" Bool)\n");
                        string_to_predicate.put(smt_repr, p);
                    }
                }
            }

        }

        string_to_predicate.putAll(str2pred);
        bui.append(plan_reg.getFirst());
//            System.out.println("bui.toString");
//            if (!belief.sons.isEmpty()) {
        bui.append("(assert ").append(belief.toSmtVariableString(0)).append(")\n");
        this.lastSMTFormula = bui.toString();
//            }

        
        s = ctx.mkSolver();
//            System.out.println(bui.toString());
        s.add(ctx.parseSMTLIB2String(bui.toString(), null, null, null, null));
        return s;
    }
    
    private CPCES_State extractState (Solver s, Map<String, Predicate> string_to_predicate) {
        CPCES_State ret = new CPCES_State();
        for (FuncDecl o : s.getModel().getConstDecls()) {
            if (s.getModel().getConstInterp(o).isTrue()) {
                if (o.getName().toString().endsWith("-0")) {
                    Predicate p = string_to_predicate.get(o.getName().toString());
                    ret.add(p);
                }
            }
        }
        return ret;
    }
    
    private CPCES_State extractCPCESState (Solver s, Map<String, Predicate> string_to_predicate) {
        final CPCES_State ret = new CPCES_State();
        for (FuncDecl o : s.getModel().getConstDecls()) {
            if (s.getModel().getConstInterp(o).isTrue()) {
                if (o.getName().toString().endsWith("-0")) {
                    Predicate p = string_to_predicate.get(o.getName().toString());
                    ret.add(p);
                }
            }
        }
        
        return ret;
    }
    
    private Pair<StringBuilder, HashSet<String>> polyRegress(SimplePlan sp, Condition cond, HashMap<String, Predicate> str_to_pred) {
        Pair<StringBuilder, HashSet<String>> ret = new Pair();
        final StringBuilder simulation = new StringBuilder("(assert (and true ");
        final StringBuilder preference = new StringBuilder("(not (and ");

        final HashSet<String> variables = new HashSet();
        //first add the goal statement
        Collection<Predicate> current_goal_predicates = cond.getInvolvedPredicates();
        for (Predicate p : current_goal_predicates) {
            if (!p.isValid() && !p.isUnsatisfiable()) {

                variables.add(p.toSmtVariableString(sp.size()));
                str_to_pred.put(p.toSmtVariableString(sp.size()), p);
            }
        }
        preference.append(cond.toSmtVariableString(sp.size())).append(" ");

        for (int i = (sp.size() - 1); i >= 0; i--) {

            Collection<Predicate> temp = new HashSet();
            //for each atom in the previous goal (updated incrementally) compute the justification for it via the action

            for (Predicate p : current_goal_predicates) {
                //here we regress

                add_action_effect(sp.get(i), p, temp, preference, simulation, str_to_pred, variables, i);
//                SupporterConditions s_c = new SupporterConditions(sp.get(i), p,i,action_predicate_to_supporter);
//                temp.addAll(s_c.temp);
//                preference.addAll(s_c.preference);
//                simulation.addAll(s_c.simulation);
//                str_to_pred.putAll(s_c.str_to_pred);
//                variables.addAll(s_c.variables);
            }

            current_goal_predicates = new HashSet(temp);

        }

        preference.append("))");
        simulation.append(preference).append("))\n");
        ret.setFirst(simulation);
        ret.setSecond(variables);

        return ret;
    }
    
    void add_action_effect(GroundAction gr, Predicate p, Collection<Predicate> temp, StringBuilder preference, StringBuilder simulation, HashMap<String, Predicate> str_to_pred, HashSet<String> variables, int i) {
        Condition c = actPredicate2Supporter.get(new ImmutablePair(gr, p));
        if (c == null) {
            c = p.regress(gr);
            actPredicate2Supporter.put(new ImmutablePair(gr, p), c);
        } else {
//                System.out.println("Already cached");
        }

        for (Predicate p3 : gr.getPreconditions().getInvolvedPredicates()) {
            if (!p3.isValid() && !p3.isUnsatisfiable()) {
                variables.add(p3.toSmtVariableString(i));
                str_to_pred.put(p3.toSmtVariableString(i), p3);
                temp.add(p3);
            }
        }
        if (gr.getPreconditions() != null && !gr.getPreconditions().sons.isEmpty()) {
            preference.append(gr.getPreconditions().toSmtVariableString(i)).append(" ");
        }
        for (Predicate p1 : c.getInvolvedPredicates()) {
            if (!p1.isValid() && !p1.isUnsatisfiable()) {

                //for any new variable created we instantiate it and put in the next goal. There is going to be also the variable itself without modification...is in it?
                temp.add(p1);
                variables.add(p1.toSmtVariableString(i));
                str_to_pred.put(p1.toSmtVariableString(i), p1);
            }

        }
        if (c.isValid()) {
            //                    regression.add("( => "+p.toSmtVariableString(i+1)+" )");
            simulation.append("( = ").append(p.toSmtVariableString(i + 1)).append(" true) ");
        } else if (c.isUnsatisfiable()) {
            simulation.append("( = ").append(p.toSmtVariableString(i + 1)).append(" false) ");
        } else {
            simulation.append("( = ").append(p.toSmtVariableString(i + 1)).append("  ").append(c.toSmtVariableString(i)).append(")").append(" ");
            //regression.add("( => "+c.toSmtVariableString(i)+"  "+p.toSmtVariableString(i+1)+")");
        }

    }

    private Pair<StringBuilder, HashSet<String>> polyRegress_alban(SimplePlan sp, Condition cond, Map<String, Predicate> str_to_pred) {
        final StringBuilder simulation = new StringBuilder("(assert (and true ");
        final StringBuilder preference = new StringBuilder("(not (and ");

        final HashSet<String> variables = new HashSet<>();
        //first add the goal statement
        Collection<Predicate> current_goal_predicates = cond.getInvolvedPredicates();
        {
            final int timestep = sp.size();
            for (Predicate p : current_goal_predicates) {
                if (!p.isValid() && !p.isUnsatisfiable()) {
//                System.out.println(p);
                    final String smtVariable = p.toSmtVariableString(timestep);
                    variables.add(smtVariable);
                    str_to_pred.put(smtVariable, p);
                }
            }
            preference.append(cond.toSmtVariableString(timestep)).append(" ");
        }

//        System.out.println(sp);
        for (int timestep = (sp.size() - 1); timestep >= 0; timestep--) {
            Collection<Predicate> temp = new HashSet<>();
            //for each atom in the previous goal (updated incrementally) compute the justification for it via the action
            for (Predicate p : current_goal_predicates) {
                //here we regress
//                System.out.println(sp.get(timestep));
                add_action_effect_alban(sp.get(timestep), p, temp, preference, simulation, str_to_pred, variables, timestep);
            }
            current_goal_predicates = temp;
        }

        preference.append("))");
        simulation.append(preference).append("))\n");
        
        final Pair<StringBuilder, HashSet<String>> result = new Pair<>(simulation,variables);
        return result;
    }

    // QUESTION FROM ALBAN: 
    // THIS METHOD IS CALLED FOR EACH CONDTIONAL EFFECT FOR THE ACTION Ai FROM THE PLAN.
    // BUT THIS METHOD ALSO PRINTS THE PRECONDITION OF THE ACTION.  
    // DOES IT MEAN THAT THE PRECONDITION IS COPIED FOR EVERY CONDITIONAL EFFECT OF THE ACTION?
    // SHOULD WE INSTEAD HAVE AN add_action_precondition METHOD?
    private void add_action_effect_alban(GroundAction gr, Predicate p, Collection<Predicate> temp, StringBuilder preference, StringBuilder simulation, Map<String, Predicate> str_to_pred, HashSet<String> variables, int timestep) {
        Condition c;
        {
            final ImmutablePair<GroundAction,Predicate> key = new ImmutablePair<>(gr, p);
            c = actPredicate2Supporter.get(key);
//            System.out.println("Predicate:"+p);
//            System.out.printCln("CAction:"+gr);
            if (c == null) {
                c = p.regress(gr);
                actPredicate2Supporter.put(key, c);
            } else {
//                System.out.println("Already cached");
            }
//            System.out.println("Regression:"+c);
        }

//        System.out.println(c.getInvolvedPredicates());
        // Preconditions variables
        for (Predicate otherPredicate: gr.getPreconditions().getInvolvedPredicates()) {
            if (!otherPredicate.isValid() && !otherPredicate.isUnsatisfiable()) {
                final String smtVariable = otherPredicate.toSmtVariableString(timestep);
                variables.add(smtVariable);
                str_to_pred.put(smtVariable, otherPredicate);
                temp.add(otherPredicate);
            }
        }
        // Condition variables of conditional effects
        for (Predicate otherPredicate : c.getInvolvedPredicates()) {
            if (!otherPredicate.isValid() && !otherPredicate.isUnsatisfiable()) {
                final String smtVariable = otherPredicate.toSmtVariableString(timestep);
                variables.add(smtVariable);
                str_to_pred.put(smtVariable, otherPredicate);
                temp.add(otherPredicate);
            }
        }
        
        // Saving the precondition of the action
        if (gr.getPreconditions() != null && !gr.getPreconditions().sons.isEmpty()) {
            final String smtPreconditions = gr.getPreconditions().toSmtVariableString(timestep);
            preference.append(smtPreconditions).append(" ");
        }
        
        simulation.append("( = ").append(p.toSmtVariableString(timestep + 1)).append(" ");
        if (c.isValid()) {
            simulation.append("true");
        } else if (c.isUnsatisfiable()) {
            simulation.append("false");
        } else {
            simulation.append(c.toSmtVariableString(timestep));
        }
        simulation.append(") ");

    }



}
