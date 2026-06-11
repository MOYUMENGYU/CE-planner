/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cpces;

import com.hstairs.ppmajal.conditions.PDDLObject;
import com.hstairs.ppmajal.domain.PddlDomain;
import com.hstairs.ppmajal.problem.EPddlProblem;
import com.hstairs.ppmajal.problem.State;
import com.hstairs.ppmajal.wrapped_planners.planningTool;

import java.io.IOException;
import java.util.Collection;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Enrico Scala
 */
public class MacroIncrementalPlanGenerator extends MacroPlanGenerator {


    protected PDDLObject obj;

    public MacroIncrementalPlanGenerator (PddlDomain pd, EPddlProblem pp, planningTool p) {
        super(pd, pp, p,false);

    }



    @Override
    public void refineCPInitialCPCESStates(Collection<CPCES_State> sample) {
        try {
            State current = pp.getInit();// I am not retracting previous states
            if (current == null) {
                current = new CPCES_State();
            }
            
            for (final CPCES_State counterexample : sample) {
//                System.out.println("IncrementalPlanGenerator: counterexample is " + counterexample);
                obj = new PDDLObject("int" + (++nbIntepretations), type);

                addCounterExampleToState((CPCES_State)current, counterexample, obj);
                pp.getObjects().add(obj);
            }
            addExtraInfo((CPCES_State) current);
            pp.setInit(current);
//            System.out.println(current);
            Utils.saveproblem(this.problemSampleFile,pp);
//            this.createForAllGoal();
        } catch (IOException ex) {
            Logger.getLogger(MacroIncrementalPlanGenerator.class.getName()).log(Level.SEVERE, null, ex);
        }
    }



}
