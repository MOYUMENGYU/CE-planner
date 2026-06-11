package cpces;

import com.hstairs.ppmajal.conditions.*;
import com.hstairs.ppmajal.domain.ActionSchema;
import com.hstairs.ppmajal.domain.PddlDomain;
import com.hstairs.ppmajal.domain.PredicateSet;
import com.hstairs.ppmajal.plan.SimplePlan;
import com.hstairs.ppmajal.problem.EPddlProblem;
import com.hstairs.ppmajal.problem.GroundAction;
import com.hstairs.ppmajal.wrapped_planners.planningTool;

import java.io.IOException;
import java.util.Collection;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;

public abstract class MacroPlanGenerator extends PlanGenerator {

    final PddlDomain domain;
    PddlDomain tempDomain;
    SimplePlan planOnCPInstance;
    HashMap<String, GroundAction> groundToSchema;

    final boolean unbreakable;

    public MacroPlanGenerator (PddlDomain domain, EPddlProblem problem, planningTool p, boolean unbreakable) {
        super(domain, problem, p);
        this.unbreakable = unbreakable;
        this.domain = new PddlDomain(confDomainFile);
        this.domain.validate(pp);
        this.domain.types.add(type);
        this.tempDomain = this.domain.clone();
        groundToSchema = new HashMap<>();
    }


    @Override
    protected void addExtraInfo (CPCES_State current) {
        if (planOnCPInstance != null) {//This is to enable the macro action
            ((CPCES_State) current).add(this.createNumberedDummy(0));
        }
    }


    @Override
    public SimplePlan computePlan ( ) {
        SimplePlan res;
        if (planOnCPInstance == null) {
            res = planning();
        } else {
            addMacrosToDomain();
            res = planning();
        }
        return res;
    }

    private void addMacrosToDomain ( ) {
        int i = 0;
        tempDomain = domain.clone();
        groundToSchema = new HashMap<>();
        Predicate paid = new Predicate("paid");
        NotCond notPaid = new NotCond(paid);
        for (ActionSchema action : tempDomain.getActionsSchema()) {
            ComplexCondition preconditions = action.getPreconditions();
            boolean found = false;
            if (preconditions instanceof AndCond) {
                AndCond and = (AndCond) preconditions;
                for (Condition c : (Collection<Condition>) and.sons) {
                    if (c instanceof ForAll) {
                        found = true;
                        final ForAll forall = (ForAll) c;
                        forall.addConditions(paid);
                        break;
                    }
                }
            }
            AndCond newAnd = null;
            if (!found) {
                newAnd = new AndCond();
                newAnd.addConditions(action.getPreconditions());
                newAnd.addConditions(paid);
                action.setPreconditions(newAnd);
            }
            newAnd = new AndCond();
            newAnd.addConditions(action.getDelList());
            newAnd.addConditions(notPaid);
            action.setDelList(newAnd);
        }
        for (int k = 0; k < planOnCPInstance.size(); k++) {
            GroundAction gr = planOnCPInstance.get(k);
            ActionSchema temp = new ActionSchema();
            String name = gr.getName() + "-ground" + i;
            temp.setName(name);
            groundToSchema.put(name, gr);
            temp.setPreconditions(gr.getPreconditions());
            temp.setAddList(gr.getAddList());
            temp.setDelList(gr.getDelList());
            temp.forall = gr.forall;
            temp.cond_effects = gr.cond_effects;
//            temp.setPreconditions((ComplexCondition) conjoinWithNewInterpretation(gr.getPreconditions(),obj));
//            temp.cond_effects = (AndCond) conjoinWithNewInterpretation(gr.cond_effects,obj);
//            temp.setAddList((AndCond) conjoinWithNewInterpretation(gr.getAddList(),obj));
//            temp.setDelList((AndCond) conjoinWithNewInterpretation(gr.getDelList(),obj));
            Predicate enabler = addPredicate(i, tempDomain);
            Predicate enabled = addPredicate(i + 1, tempDomain);
            ComplexCondition preconditions = temp.getPreconditions();
            AndCond newAndCondition = new AndCond();
            newAndCondition.addConditions(preconditions);
            newAndCondition.addConditions(enabler);
            temp.setPreconditions(newAndCondition);

            newAndCondition = new AndCond();
            newAndCondition.addConditions(temp.getAddList());
            newAndCondition.addConditions(enabled);
            temp.setAddList(newAndCondition);

            newAndCondition = new AndCond();
            newAndCondition.addConditions(temp.getDelList());
            newAndCondition.addConditions(new NotCond(enabler));
            if (unbreakable) {
                newAndCondition.addConditions(notPaid);
            }
            temp.setDelList(newAndCondition);
            i++;
            addAction(tempDomain, temp);
        }

        ActionSchema action = new ActionSchema();
        action.setName("pay-domain-action");
        AndCond andCond = new AndCond();
        andCond.addConditions(notPaid);
        OrCond or = new OrCond();
        or.addConditions(addPredicate(0, tempDomain));
        or.addConditions(addPredicate(planOnCPInstance.size(), tempDomain));
        andCond.addConditions(or);
        action.setPreconditions(andCond);
        andCond = new AndCond();
        andCond.addConditions(paid);
        action.setAddList(andCond);

        addNewPredicate(paid, tempDomain);

        addAction(tempDomain, action);

        try {
            tempDomain.requirements = null;
            tempDomain.saveDomain(this.confDomainFile + "_macro");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void addNewPredicate (Predicate predicate, PddlDomain domain) {
        PredicateSet predicates = domain.getPredicates();
        predicates.add(predicate);
    }

    private Predicate addPredicate (int i, PddlDomain domain) {
        Predicate numberedDummy = createNumberedDummy(i);
        PredicateSet predicates = domain.getPredicates();
        predicates.add(numberedDummy);
        return numberedDummy;

    }

    private Predicate createNumberedDummy (int i) {
        return new Predicate("dummy" + i);
    }

    private void addAction (PddlDomain domain, ActionSchema gr) {

        Collection<ActionSchema> actionsSchema = domain.getActionsSchema();
        actionsSchema.add(gr);
        domain.setActionSchema(actionsSchema);

    }

    public SimplePlan planning ( ) {

        try {
            String domainName = this.confDomainFile;
            if (planOnCPInstance != null) {
                domainName += "_macro";
            }
            if (p.plan(domainName, this.problemSampleFile) == null) {//I am relying on a handcrafted domain here. This could be automatized but will take some time
                return null;
            }
            SimplePlan planOverACD = new SimplePlan(tempDomain, pp);
            planOverACD.parseSolution(p.storedSolutionPath);
            planOverACD = removeDummies(planOverACD);
            SimplePlan planOverCD = new SimplePlan(domain, pp);
            planOverCD.parseSolutionFromOtherPlan(planOverACD);

            SimplePlan planOnUD = new SimplePlan(pd, pp);
            planOnUD.parseSolutionFromOtherPlan(planOverCD);
            planOnCPInstance = planOverCD;


            if (planOnUD.equals(oldplan)) {
                System.out.println("Fix Point in plan computation. Something is wrong");
                return null;
            }
            for (int i = 0; i < planOnUD.size(); i++) {
                GroundAction a = planOnUD.get(i);
                GroundAction intA = actions.get(a.toFileCompliant());
                if (intA == null) {
                    actions.put(a.toFileCompliant(), a);
                } else {
//                    System.out.println("DEBUG: Already seen");
                    planOnUD.set(i, intA);
                }
            }
//            System.out.println("Act   ion seen:"+actions.size());

            oldplan = planOnUD;
            return oldplan;
        } catch (IOException ex) {
            Logger.getLogger(IncrementalPlanGenerator.class.getName()).log(Level.SEVERE, null, ex);
        } catch (Exception ex) {
            Logger.getLogger(IncrementalPlanGenerator.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    private SimplePlan removeDummies (SimplePlan newPlan) {

        SimplePlan plan = new SimplePlan(tempDomain, pp);

        float j = 0;
        float tot = 0;
        for (int i = 0; i < newPlan.size(); i++) {
            GroundAction gr = newPlan.get(i);
            if (!("pay-domain-action".equals(gr.getName()))) {
                GroundAction gr2 = this.groundToSchema.get(gr.getName());
                if (gr2 != null) {
                    plan.add(gr2);
                    j++;
                } else {
                    plan.add(gr);
                }
                tot++;
            }
        }

        System.out.println("Reusing " + (j / tot) * 100f);
        return plan;

    }
}
;


//
//    private Condition copyWithNewInterpretation (Condition cond, PDDLObject obj) {
//        if (cond instanceof AndCond){
//            AndCond temp = (AndCond)cond;
//            ArrayList<Condition> t = new ArrayList();
//            for (Condition c: (Collection<Condition>)temp.sons){
//                t.add(this.copyWithNewInterpretation(c,obj));
//            }
//            temp.sons = new ReferenceLinkedOpenHashSet(t);
//        }
//        if (cond instanceof ConditionalEffect){
//            ((ConditionalEffect) cond).activation_condition = copyWithNewInterpretation(((ConditionalEffect) cond).activation_condition,obj);
//            ((ConditionalEffect) cond).effect = (PostCondition) copyWithNewInterpretation((Condition) ((ConditionalEffect) cond).effect,obj);
//            return cond;
//        }
//        if (cond instanceof Predicate){
//            if (((Predicate) cond).getTerms().size()>0) {
//                return extendPredicate((Predicate) cond, obj);
//            }else{
//                return cond;
//            }
//        }
//        if (cond instanceof NotCond){
//            return new NotCond(copyWithNewInterpretation(((NotCond) cond).getSon(),obj));
//        }
//        return cond;
//    }
//
//    private Condition conjoinWithNewInterpretation (Condition cond, PDDLObject obj) {
//        if (cond instanceof AndCond){
//            AndCond temp = (AndCond)cond;
//            ArrayList<Condition> t = new ArrayList();
//            for (Condition c: (Collection<Condition>)temp.sons){
//                t.add(copyWithNewInterpretation(c.clone(),obj));
//            }
//            t.addAll(temp.sons);
//            temp.sons = new ReferenceLinkedOpenHashSet(t);
//            return temp;
//        }else {
//            throw new RuntimeException("This is supposed to be an AndCond");
//        }
//    }
//
//    private Predicate extendPredicate(Predicate pred, PDDLObject obj){
//        Predicate newPredicate = new Predicate();
//        newPredicate.setPredicateName(((Predicate) pred).getPredicateName());
//        newPredicate.setTerms(new ArrayList(((Predicate) pred).getTerms()));
//        newPredicate.getTerms().set(newPredicate.getTerms().size()-1,obj);
//        return newPredicate;
//    }
