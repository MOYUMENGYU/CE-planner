package cpces;

import com.hstairs.ppmajal.conditions.PDDLObject;
import com.hstairs.ppmajal.domain.PddlDomain;
import com.hstairs.ppmajal.problem.EPddlProblem;
import com.hstairs.ppmajal.wrapped_planners.planningTool;

import java.io.IOException;
import java.util.Collection;
import java.util.LinkedHashSet;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Enrico Scala
 */
public class ScratchPlanGenerator extends PlanGenerator {


    public ScratchPlanGenerator(PddlDomain pd, EPddlProblem pp, planningTool p) {
        super(pd, pp, p);
    }

    @Override
    public void refineCPInitialCPCESStates(Collection<CPCES_State> sample) {
        try {
            CPCES_State classicalState = new CPCES_State();// Building a new state
            final Set<PDDLObject> interpretedObjects = new LinkedHashSet();
            nbIntepretations = 0;
            for (final CPCES_State counterexample : sample) {
                final PDDLObject obj = new PDDLObject("int" + (++nbIntepretations), type);
                interpretedObjects.add(obj);
                addCounterExampleToState(classicalState, counterexample, obj);
            }
            pp.getObjects().addAll(interpretedObjects);
            addExtraInfo(classicalState);
            pp.setInit(classicalState);
            Utils.saveproblem(this.problemSampleFile,pp);
//            this.createForAllGoal();
            
            //reset pp
            pp.setInit(null);
            pp.getObjects().removeAll(interpretedObjects);
        } catch (IOException ex) {
            Logger.getLogger(ScratchPlanGenerator.class.getName()).log(Level.SEVERE, null, ex);
        }
    }



}
