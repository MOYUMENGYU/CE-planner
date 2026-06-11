package cpces;

import com.hstairs.ppmajal.conditions.*;
import com.hstairs.ppmajal.plan.SimplePlan;
import com.hstairs.ppmajal.problem.GroundAction;
import com.hstairs.ppmajal.problem.State;

import java.util.*;

/**
 * A CPCES state is defined as the collection of facts (predicates) 
 * that are true in this state.
 * This is a re-implementation of State 
 * that we hope will bypass all issues currently encountered with State.
 * All facts that are not in the collection 
 * are assumed to be false in the state.
 *
 * @author Alban Grastien
 */
public class CPCES_State extends State {
    
    private final Set<Predicate> _statePredicates;
    
    /**
     * Creates an empty state with no predicate.
     */
    public CPCES_State() {
        _statePredicates = new LinkedHashSet<>();
    }

    @Override
    public void apply (GroundAction gr) {
        throw new RuntimeException("Temporary hack to be compatible with State in PDDLProblem. Fix this, but at the moment" +
                "use applyCopy instead");
    }

    /**
     * Creates a copy of the specified state.
     * 
     * @param st the state whose copy is required.
     */
    public CPCES_State(CPCES_State st) {
        _statePredicates = new LinkedHashSet<>(st._statePredicates);
    }
    
    @Override
    public int hashCode() {
        return _statePredicates.hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final CPCES_State other = (CPCES_State) obj;
        if (!Objects.equals(this._statePredicates, other._statePredicates)) {
            return false;
        }
        return true;
    }
    
    @Override
    public String toString() {
        return _statePredicates.toString();
    }
    
    /**
     * Returns the predicates satisfied in this state.  
     * 
     * @return the predicates satisfied in this state.  
     */
    public Set<Predicate> getPredicates() {
        return Collections.unmodifiableSet(_statePredicates);
    }
    
    /**
     * Adds the specified predicate to this state.  
     * 
     * @param pred the predicate added to this state.  
     * @return <tt>true</tt> if this state has been changed, 
     * <tt>false</tt> otherwise.  
     */
    public boolean add(Predicate pred) {
        return _statePredicates.add(pred);
    }
    
    /**
     * Removes the specified predicate from this state.  
     * 
     * @param pred the predicate removed from this state.  
     * @return <tt>true</tt> if this state has been changed, 
     * <tt>false</tt> otherwise.  
     */
    public boolean remove(Predicate pred) {
        return _statePredicates.remove(pred);
    }
    
    /**
     * Indicates whether the specified predicate is true in this state.  
     * 
     * @param pred the predicate tested.  
     * @return <tt>true</tt> if <tt>pred</tt> is true in this state, 
     * <tt>false</tt> otherwise.  
     */
    public boolean isSatisfied(Predicate pred) {
        return _statePredicates.contains(pred);
    }
    
    /**
     * Indicates whether the specified condition holds in this state.  
     * 
     * @param cond the condition.
     * @return <tt>true</tt> if <tt>cond</tt> holds in this state, 
     * <tt>false</tt> otherwise.
     */
    public boolean holds(Condition cond) {
        if (cond instanceof Predicate) {
            final Predicate pred = (Predicate)cond;
            return isSatisfied(pred);
        }
        
        if (cond instanceof AndCond) {
            final AndCond and = (AndCond)cond;
            for (final Object son: and.sons) {
                final Condition sonCondition = (Condition)son;
                if (!holds(sonCondition)) {
                    return false;
                }
            }
            return true;
        }
        
        if (cond instanceof OrCond) {
            final OrCond or = (OrCond)cond;
            for (final Object son: or.sons) {
                final Condition sonCondition = (Condition)son;
                if (holds(sonCondition)) {
                    return true;
                }
            }
            return false;
        }
        
        if (cond instanceof OneOf) {
            final OneOf oneOf = (OneOf)cond;
            int nb = 0;
            for (final Object son: oneOf.sons) {
                final Condition sonCondition = (Condition)son;
                if (holds(sonCondition)) {
                    nb++;
                    if (nb > 1) {
                        return false;
                    }
                }
            }
            return (nb == 1);
        }
        
        if (cond instanceof NotCond) {
            final NotCond notCond = (NotCond)cond;
            final Condition son = notCond.getSon();
            return ! holds(son);
        }
        
        // CONDITIONS NOT HANDLED HERE:
        
        // Comparison
        // ConditionalEffect
        // DoubleImplication
        // Existential
        // ForAll
        // NumFluentValue
        // PDDLObject
        // PDDLObjectsEquality
        // Terminal
        
        throw new UnsupportedOperationException("Unsupported for class: " + cond.getClass());
    }
    
    /**
     * Computes the state reached by applying the specified action in this state.  
     * 
     * @param act the action applied to this state.  
     * @return the state reached from applying <tt>act</tt> in this state if applicable, 
     * <tt>null</tt> otherwise (i.e., if the action is not applicable).
     */
    public CPCES_State applyCopy(GroundAction act) {
//        System.out.println("Applying action " + act.toEcoString());
        {
            final ComplexCondition precondition = act.getPreconditions();
//            System.out.println("Precondition: " + precondition);
//            System.out.println("Current state " + toString());
            if (!holds(precondition)) {
                return null;
            }
        }
        
        final Set<Predicate> adds = new HashSet<>();
        final Set<Predicate> dels = new HashSet<>();
        evaluateEffects(act.cond_effects, adds, dels);
        insertEffects(act.getAddList(), adds);
        insertEffects(act.getDelList(), dels);
//        System.out.println(act.cond_effects);
//        System.out.println(act.getAddList());
//        System.out.println(act.getDelList());
//        System.out.println("adds: " + adds);
//        System.out.println("dels: " + dels);
        
        // Testing if the effects are inconsistent
        for (final Predicate del: dels) {
            if (adds.contains(del)) {
                return null;
            }
        }
        
        final CPCES_State result = new CPCES_State(this);
        for (final Predicate add: adds) {
            result.add(add);
        }
        for (final Predicate del: dels) {
            result.remove(del);
        }
        
        return result;
    }

    @Override
    public boolean satisfy (Condition input) {
        return false;
    }

    @Override
    public State clone ( ) {
        return null;
    }

    /**
     * Computes the state reached by applying the specified plan in this state.  
     * 
     * @param plan the plan applied to this state.  
     * @return the state reached from applying <tt>plan</tt> in this state if applicable, 
     * <tt>null</tt> otherwise (i.e., if the plan is not applicable).
     */
    public CPCES_State apply(SimplePlan plan) {
        CPCES_State currentState = this;
        for (final GroundAction act: plan) {
            currentState = currentState.applyCopy(act);
            if (currentState == null) {
                return null;
            }
        }
        
        return currentState;
    }
    
    /**
     * Tests whether the specified plan is valid in this state, given the specified goal.  
     * 
     * @param plan the plan that is tested.  
     * @param goal the goal condition.  
     * @return <tt>true</tt> if the plan is valid, <tt>false</tt> otherwise.  
     */
    public boolean isValid(SimplePlan plan, ComplexCondition goal) {
        
        final CPCES_State reachedState = apply(plan);
        if (reachedState == null) {
            //System.out.println("Plan inapplicable");
            return false;
        }
        //System.out.println("State reached by performing plan: " + reachedState);
        return reachedState.holds(goal);
    }
    
    private void evaluateEffects(PostCondition pc, Collection<Predicate> addEffects, Collection<Predicate> delEffects) {
        if (pc instanceof Predicate) {
            final Predicate pred = (Predicate)pc;
            addEffects.add(pred);
            return;
        }
        
        if (pc instanceof NotCond) {
            final Condition notCond = ((NotCond)pc).getSon();
            if (notCond instanceof Predicate) {
                final Predicate pred = (Predicate)notCond;
                delEffects.add(pred);
                return;
            }
        }
        
        if (pc instanceof AndCond) {
            final AndCond andCond = (AndCond)pc;
            for (final PostCondition son: (Collection<PostCondition>)andCond.sons) {
                evaluateEffects(son, addEffects, delEffects);
            }
            return;
        }
        
        if (pc instanceof ConditionalEffect) {
            final ConditionalEffect condEff = (ConditionalEffect)pc;
            if (holds(condEff.activation_condition)) {
                evaluateEffects(condEff.effect, addEffects, delEffects);
            }
            return;
        }
        
        // Not handled: ForAll, NotCond (to some extend), NumEffect
        throw new IllegalStateException("PostCondition not handled: " + pc);
    }
    
    private void insertEffects(Condition cond, Collection<Predicate> preds) {
        if (cond instanceof AndCond) {
            final AndCond andCond = (AndCond)cond;
            for (final Condition son: (Collection<Condition>)andCond.sons) {
                insertEffects(son, preds);
            }
            return;
        }
        
        if (cond instanceof Predicate) {
            final Predicate pred = (Predicate)cond;
            preds.add(pred);
            return;
        }
        
        if (cond instanceof NotCond) {
            final Condition son = ((NotCond)cond).getSon();
            insertEffects(son, preds);
            return;
        }
        
        throw new IllegalStateException("Condition not handled: " + cond);
    }
    
}
