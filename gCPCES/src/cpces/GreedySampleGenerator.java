package cpces;

import com.hstairs.ppmajal.conditions.Condition;
import com.hstairs.ppmajal.plan.SimplePlan;

import java.util.HashSet;
import java.util.Set;

/**
 * The greedy Sample Generator.
 * <p>
 * This generator keeps track of the counter-examples that were computed at the
 * previous iterations so that it computes counter-examples only for the new
 * plans.
 * </p>
 */
public class GreedySampleGenerator extends SampleGenerator {

    private CPCES_State lastState = null;

    public GreedySampleGenerator(Condition belief, Condition goals) {
        super(belief,goals);
    }

    @Override
    public boolean refineCPCESSample(SimplePlan candidatePlan) {
        lastState = computeSingleCPCESCounterExample(candidatePlan);
        if (lastState == null) {
            return false;
        }
        return true;
    }

    @Override
    public Set<CPCES_State> getCPCESSample() {
        final Set<CPCES_State> result = new HashSet<>();
        result.add(lastState);
        return result;
    }
}
