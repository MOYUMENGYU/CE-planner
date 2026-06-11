
(define (domain d-ring-new-2)
  (:requirements :typing :equality)
  (:types window)
  (:constants  w1  w2  - window)
  (:predicates
     (pos ?w - window)
     (closed ?w - window)
     (open ?w - window)
     (locked ?w - window)
     (locker_damaged ?w - window)	
  )
  (:action fwd
     :effect
       (and 
            (when (pos w1) (and (pos w2) (not (pos w1))))  
            (when (pos w2) (and (pos w1) (not (pos w2))))  
       )
  )
  (:action bwd
     :effect
       (and 
            (when (pos w1) (and (pos w2) (not (pos w1))))  
            (when (pos w2) (and (pos w1) (not (pos w2))))  
       )
  )
  (:action close
     :effect
       (and  
            (when (pos w1) (closed w1))  
            (when (pos w2) (closed w2))  
       )
  )
  (:action lock
     :effect
       (and 
            (when (and (pos w1) (closed w1) (not (locker_damaged w1))) (locked w1))  
            (when (and (pos w2) (closed w2) (not (locker_damaged w2))) (locked w2))  
       )
  )
)


