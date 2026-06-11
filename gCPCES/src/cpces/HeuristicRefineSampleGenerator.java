package cpces;

import com.hstairs.ppmajal.conditions.ComplexCondition;
import com.hstairs.ppmajal.conditions.Condition;
import com.hstairs.ppmajal.plan.SimplePlan;

import java.util.*;

/**
 *
 * @author Enrico Scala
 * @author Alban Grastien
 */
public class HeuristicRefineSampleGenerator extends SampleGenerator{
    
    private final FlexibleHittingSet<CPCES_State, SimplePlan> _hittingSetCPCES;
    private final PlanGenerator hFF;
    
    public HeuristicRefineSampleGenerator(Condition belief, Condition goals, PlanGenerator hff) {
        super(belief, goals);
        _hittingSetCPCES = new FlexibleHittingSet<>();
        this.hFF = hff;
    }
    

    
    private boolean searchNewCounterExample(SimplePlan candidatePlan) {
        final CPCES_State counterexample = computeSingleCPCESCounterExample(candidatePlan);
        if (counterexample == null) {
            return false;
        }

        // Compute the plans that are covered by the new counter example.
        final List<SimplePlan> coveredPlans = new ArrayList<>();
        final ComplexCondition goal = (ComplexCondition) goals;
        for (final SimplePlan plan : _hittingSetCPCES.getElements()) {
            if (!counterexample.isValid(plan, goal)) {
                coveredPlans.add(plan);
            }
        }

        _hittingSetCPCES.add(candidatePlan, counterexample, coveredPlans);
        return true;
    }
    
    @Override
    public boolean refineCPCESSample(SimplePlan candidatePlan) {
        if (!searchNewCounterExample(candidatePlan)) {
            return false; // no counter-example found
        }
        
        final List<CPCES_State> allCounterExamples = new ArrayList<>(_hittingSetCPCES.getCollections());
        final int bestHeuristic = computeInformation(allCounterExamples); // we want to match that
        final Set<CPCES_State> remainingCounterExamples = new HashSet<>(_hittingSetCPCES.getCollections());
        
        for (final CPCES_State counterExample: allCounterExamples) {
            if (!_hittingSetCPCES.isRedundant(counterExample)) {
                continue; // cannot remove st as it is the only one that covers some plan
            }
            
            remainingCounterExamples.remove(counterExample);
            final int newHeuristic = computeInformation(remainingCounterExamples);
            
            if (newHeuristic < bestHeuristic) { // cannot remove counterExample
                remainingCounterExamples.add(counterExample);
            }else{            
                _hittingSetCPCES.remove(counterExample);
            }
        }
        
        return true;

    }

    private int computeInformation (Collection<CPCES_State> currentSample) {
        hFF.refineCPInitialCPCESStates(currentSample);
        int ret = hFF.computeHeuristic();
        return ret;
    }

    @Override
    public Set<CPCES_State> getCPCESSample() {
         
        return this._hittingSetCPCES.getCollections();
    
    }
    
}
