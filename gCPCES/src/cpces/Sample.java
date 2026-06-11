package cpces;

import com.hstairs.ppmajal.problem.State;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;

/**
 * A sample is a list of initial states.
 *
 * @author Alban Grastien
 */
public class Sample implements Iterable<State> {
    
    private final List<State> _states;
    
    /**
     * Creates an empty sample.  
     */
    public Sample() {
        _states = new ArrayList<>();
    }
    
    /**
     * Creates a sample defined by the specified set of states.  
     * 
     * @param states the states of the sample.
     */
    public Sample(Collection<State> states) {
        this();
        for (final State st: states) {
            add(st);
        }
    }
    
    /**
     * Adds the specified state to this sample.
     * 
     * @param st the state.  
     */
    public void add(State st) {
        _states.add(st);
    }
    
    /**
     * Returns the number of states in this sample.  
     * 
     * @return the number of states in this sample.  
     */
    public int size() {
        return _states.size();
    }
    
    /**
     * Returns the state at the specified location (between 0 and size()-1).  
     * 
     * @param i the position in this sample.  
     * @return the state at position <code>i</code>.  
     */
    public State get(int i) {
        return _states.get(i);
    }
    
    /**
     * Removes the state at the specified location.
     * All states further in the sample are moved forward 
     * (so there is a new state at location <code>i</code>).  
     * 
     * @param i the position of the state to remove.  
     */
    public void remove(int i) {
        _states.remove(i);
    }
    
    @Override
    public Iterator<State> iterator() {
        return _states.iterator();
    }
}
