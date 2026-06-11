/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cpces;

import com.hstairs.ppmajal.conditions.PDDLObject;
import com.hstairs.ppmajal.conditions.Predicate;
import com.hstairs.ppmajal.domain.PddlDomain;
import com.hstairs.ppmajal.domain.Type;
import com.hstairs.ppmajal.plan.SimplePlan;
import com.hstairs.ppmajal.problem.EPddlProblem;
import com.hstairs.ppmajal.problem.GroundAction;
import com.hstairs.ppmajal.wrapped_planners.planningTool;

import java.io.IOException;
import java.util.Collection;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Enrico Scala
 */
public abstract class PlanGenerator {
    
    protected PddlDomain pd;
    protected final EPddlProblem pp;
    public final planningTool p;
    protected final String confDomainFile;
    protected final String problemSampleFile;
    protected SimplePlan oldplan;
    protected HashMap<String,GroundAction> actions;
    protected int nbIntepretations;
    protected final Type type;
    

    public PlanGenerator(PddlDomain pd, EPddlProblem pp, planningTool p) {
        this.pp = pp;
        this.pd = pd;
        this.pd.validate(this.pp);
        this.pd.setName(this.pd.getName());
        type = new Type("interpretation");
        nbIntepretations = 0;
        this.pd.types.add(type);
        confDomainFile = this.pp.getPddlFileReference() + "domain_conformant";
        problemSampleFile = this.pp.getPddlFileReference() + "_sample";
        this.pp.setDomainName(this.pd.getName());
        this.p = p;
        this.p.storedSolutionPath = problemSampleFile + "_plan";
        p.setDomainFile(confDomainFile);
        try {
            this.pd.saveDomainWithInterpretationObjects(confDomainFile);
        } catch (IOException ex) {
            Logger.getLogger(SampleGenerator.class.getName()).log(Level.SEVERE, null, ex);
        }
        oldplan = new SimplePlan(this.pd,this.pp);
        actions = new HashMap();
    }
    
    public SimplePlan computePlan() {

        try {
            if (p.plan(this.confDomainFile, this.problemSampleFile) == null) {//I am relying on a handcrafted domain here. This could be automatized but will take some time
                return null;
            }
            SimplePlan newPlan = new SimplePlan(pd, pp);
            newPlan.parseSolution(p.storedSolutionPath);
            if (newPlan.equals(oldplan)) {
                return null;
            }
            for (int i=0;i<newPlan.size();i++){
                GroundAction a = newPlan.get(i);
                GroundAction intA =actions.get(a.toFileCompliant());
                if (intA == null){
                    actions.put(a.toFileCompliant(),a);
                }else{
//                    System.out.println("DEBUG: Already seen");
                    newPlan.set(i,intA);
                }
            }
//            System.out.println("Act   ion seen:"+actions.size());
                    
            oldplan = newPlan;
            return oldplan;
        } catch (IOException ex) {
            Logger.getLogger(IncrementalPlanGenerator.class.getName()).log(Level.SEVERE, null, ex);
        } catch (Exception ex) {
            Logger.getLogger(IncrementalPlanGenerator.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
    
    public SimplePlan repairPlan(SimplePlan prefix) {

        //TO-DO
        //Produce a state using the prefix plan which is given by its execution.
        //This state is then used as
        //init for the new planning problem and the resulting plan is appended to the prefix plan
        //Since this is sound but not complete, this strategy needs to be backuped with
        //a replanning from scratch.
        try {
            if (p.plan(this.confDomainFile, this.problemSampleFile) == null) {//I am relying on a handcrafted domain here. This could be automatized but will take some time
                return null;
            }
            SimplePlan newplan = new SimplePlan(pd, pp);
            newplan.parseSolution(p.storedSolutionPath);
            if (newplan.equals(oldplan)) {
                return null;
            }     
            oldplan = newplan;
            return oldplan;
        } catch (IOException ex) {
            Logger.getLogger(IncrementalPlanGenerator.class.getName()).log(Level.SEVERE, null, ex);
        } catch (Exception ex) {
            Logger.getLogger(IncrementalPlanGenerator.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
    
    public int computeHeuristic() {
//       int ret = p.computeHeuristic(this.confDomainFile, this.problemSampleFile);
//       System.out.println ("ret:"+ret);
//       System.exit(-1);
       return p.computeHeuristic(this.confDomainFile, this.problemSampleFile);//I am relying on a handcrafted domain here. This could be automatized but will take some time
    }

    /**
     *
     * @param sample
     */
    public abstract void refineCPInitialCPCESStates(Collection<CPCES_State> sample);

    protected void addExtraInfo (CPCES_State state ) {
    }

    protected void addCounterExampleToState(CPCES_State state, CPCES_State cpcesState, PDDLObject obj) {
        for (final Predicate pred: cpcesState.getPredicates()) {
            final Predicate interpretedPred = new Predicate(pred.getPredicateName());
            interpretedPred.setGrounded(true);
            interpretedPred.getTerms().addAll(pred.getTerms());
            interpretedPred.addObject(obj);
//            System.out.println("Incremental Plan Generator: predicate generated " + interpretedPred);
            state.add(interpretedPred);
        }
    }
    
}
