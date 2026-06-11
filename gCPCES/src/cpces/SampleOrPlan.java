package cpces;

import com.hstairs.ppmajal.plan.SimplePlan;
import com.hstairs.ppmajal.problem.State;

import java.util.ArrayList;
import java.util.Collection;

/**
 * 
 */
public class SampleOrPlan {

    public final Collection<State> _sample;
    public final SimplePlan _plan;

    public SampleOrPlan(Collection<State> sample) {
	_sample = new ArrayList<>(sample);
	_plan = null;
    }

    public SampleOrPlan(SimplePlan plan) {
	_sample = null;
	_plan = plan;
    }
}