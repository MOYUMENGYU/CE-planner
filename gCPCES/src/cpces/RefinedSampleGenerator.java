/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cpces;

import com.hstairs.ppmajal.conditions.ComplexCondition;
import com.hstairs.ppmajal.conditions.Condition;
import com.hstairs.ppmajal.plan.SimplePlan;
import com.hstairs.ppmajal.problem.State;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Set;

/**
 *
 * @author Enrico Scala
 */
public class RefinedSampleGenerator extends SampleGenerator {

    final IncrementalHittingSet<State, SimplePlan> _hittingSet;
    final IncrementalHittingSet<CPCES_State, SimplePlan> _hittingSetCPCES;

    public RefinedSampleGenerator(Condition belief, Condition goals) {
        super(belief, goals);
        _hittingSet = new IncrementalHittingSet<>();
        _hittingSetCPCES = new IncrementalHittingSet<>();
    }
    public RefinedSampleGenerator(Condition belief, Condition goals,boolean invasiveCollection) {
        super(belief, goals);
        _hittingSet = new IncrementalHittingSet<>();
        _hittingSetCPCES = new IncrementalHittingSet<>(invasiveCollection);
    }



    public boolean refineCPCESSampleFirstPhase(SimplePlan candidatePlan) {
        final CPCES_State counterexample = computeSingleCPCESCounterExample(candidatePlan);
        if (counterexample == null) {
            return false;
        }

        // Compute the plans that are invalid for the counter example.
        final List<SimplePlan> invalidPlans = new ArrayList<>();
        final ComplexCondition goal = (ComplexCondition) goals;
        for (final SimplePlan plan : _hittingSetCPCES.getElements()) {
            if (!counterexample.isValid(plan, goal)) {
                invalidPlans.add(plan);
            }
        }

        _hittingSetCPCES.add(candidatePlan, counterexample, invalidPlans);
        return true;
    }

    @Override
    public boolean refineCPCESSample(SimplePlan candidatePlan) {
        if (this.refineCPCESSampleFirstPhase(candidatePlan)) {
            for (;;) {
                final CPCES_State redundantState = _hittingSetCPCES.dropOne();
                if (redundantState == null) {
                    break;
                }
            }
            return true;
        }else{
            return false;
        } 

    }

    @Override
    public Set<CPCES_State> getCPCESSample() {
        return Collections.unmodifiableSet(_hittingSetCPCES.getCollections());
    }

}
