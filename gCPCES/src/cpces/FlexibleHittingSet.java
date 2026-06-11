package cpces;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * <p>Flexible Hitting Set is a class that implements a procedure 
 * that allows to compute hitting sets that are defined incrementally, 
 * and where you can try to minimise the hitting sets.  
 * A hitting is defined as follows: 
 * <ul>
 * <li>a set of ``elements'' <i>E</i>, 
 * </li>
 * <li>a set of ``collections'' <i>C</i>,
 * </li>
 * <li>a relation <i>R</i> between elements and collections 
 * denoted <i>e R c</i>.
 * </ul>
 * A <i>hitting set</i> is a subset <i>C'</i> of <i>C</i> 
 * such that forall element <i>e</i> from <i>E</i>, 
 * there exists a collection <i>c</i> from <i>C'</i> 
 * such that <i>e R c</i>.
 * </p>
 * 
 * <p>
 * The hitting set problem is defined incrementally.  
 * Given an existing hitting set problem <i>(E,C,R)</i>, 
 * we are given a new element <i>e'</i>, a new collection <i>c'</i>, 
 * and a subset of elements <i>S</i> of <i>E</i>, 
 * that defines the hitting set problem <i>(E',C',R')</i> 
 * where: 
 * <ul>
 * <li><i>E' = E union {e'}</i>
 * </li>
 * <li><i>C' = C union {c'}</i>
 * </li>
 * <li>forall <i>e</i> in <i>E'</i>, <i>c</i> in <i>C</i>, 
 * <i>e R' c</i> holds iff <i>e R c</i> holds 
 * or <i>e</i> in <i>S union {e'}</i> and <i>r = r'</i>.
 * </li>
 * </ul>
 * </p>
 * 
 * @author Alban Grastien
 * @param <C> the type of the collections.
 * @param <E> the type of the elements.
 */
public class FlexibleHittingSet<C,E> {
    
    /**
     * The list of elements.
     */
    private final List<E> _elements;

    /**
     * The list of collections.
     */
    private final Set<C> _collections;

    /**
     * A mapping that indicates the list of elements that each collection
     * covers.
     */
    private final Map<C, List<E>> _elementsCovered;

    /**
     * A mapping that indicates the list of collections that cover each element.
     */
    private final Map<E, Set<C>> _collectionsCovering;
    
    public FlexibleHittingSet() {
        _elements = new ArrayList<>();
        _collections = new HashSet<>();
        _elementsCovered = new HashMap<>();
        _collectionsCovering = new HashMap<>();
        
    }
    public FlexibleHittingSet(boolean invasiveCollection) {
        _elements = new ArrayList<>();
        _collections = new HashSet<>();
        _elementsCovered = new HashMap<>();
        _collectionsCovering = new HashMap<>();
        
    }
    
    /**
     * Incremental step.
     *
     * @param eprime the new element.
     * @param cprime the new collection.
     * @param s the list of elements <i>e</i> for which <i>e R cprime</i> holds.
     */
    public void add(E eprime, C cprime, Collection<E> s) {
        if (_elements.contains(eprime)) {
            System.out.println("Element already present.");
            System.exit(0);
        }
        
        _elements.add(eprime);
        _collections.add(cprime);
        
        final List<E> elementsCoveredByCPrime = new ArrayList<>();
        elementsCoveredByCPrime.add(eprime);
        elementsCoveredByCPrime.addAll(s);
        _elementsCovered.put(cprime, elementsCoveredByCPrime);
        
        _collectionsCovering.put(eprime, new HashSet<>());
        for (final E e: elementsCoveredByCPrime) {
            final Set<C> collectionsCoveringE = _collectionsCovering.get(e);
            collectionsCoveringE.add(cprime);
        }
    }

    /**
     * Indicates whether the specified collection can be removed 
     * without affecting the coverage of the hitting set.  
     * 
     * @param c the collection that we want to remove.  
     * @return <tt>true</tt> if the {@link #remove(java.lang.Object) } method 
     * can be used with <tt>c</tt>.  
     */
    public boolean isRedundant(C c) {
        for (final E e : _elementsCovered.get(c)) {
            final Set<C> collectionsCoveringE = _collectionsCovering.get(e);
            if (collectionsCoveringE.size() == 1) {
                // c is the only collection that covers e.
                return false;
            }
        }
        
        return true;
    }
    
    /**
     * Removes the specified collection.  
     * 
     * @param c the collection that is being removed.
     */
    public void remove(C c) {
        _collections.remove(c);
        final Collection<E> elementsCoveredByResult = _elementsCovered.remove(c);
        for (final E e: elementsCoveredByResult) {
            final Set<C> collectionsCoveringE = _collectionsCovering.get(e);
            collectionsCoveringE.remove(c);
        }
    }
    
    /**
     * Returns the list of elements.  
     * 
     * @return the elements of this hitting set.  
     */
    public List<E> getElements() {
        return Collections.unmodifiableList(_elements);
    }
    
    /**
     * Returns the list of collections.  
     * 
     * @return the collections that form a hitting set of the list of elements; 
     * remember that some collections may have been removed 
     * through {@link #dropOne() }.  
     */
    public Set<C> getCollections() {
        return Collections.unmodifiableSet(_collections);
    }
    
    public static void main(String[] args) {
        FlexibleHittingSet<Integer,String> hittingset = new FlexibleHittingSet<>();
        
        hittingset.add("a", 1, new ArrayList<>());
        System.out.println(hittingset._collectionsCovering);
        hittingset.add("b", 2, new ArrayList<>());
        System.out.println(hittingset._collectionsCovering);
        {
            final List<String> s = new ArrayList<>();
            s.add("a");
            hittingset.add("c", 3, s);
        }
        System.out.println(hittingset._collectionsCovering);
        System.out.println(hittingset._collectionsCovering);
        
        System.out.println(hittingset.getCollections());
        
    }
}
