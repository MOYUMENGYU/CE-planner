
(define (domain d-ring-new-4)
  (:requirements :typing :equality)
  (:types window)
  (:constants  w1  w2  w3  w4  - window)
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
            (when (pos w2) (and (pos w3) (not (pos w2))))  
            (when (pos w3) (and (pos w4) (not (pos w3))))  
            (when (pos w4) (and (pos w1) (not (pos w4))))  
       )
  )
  (:action bwd
     :effect
       (and 
            (when (pos w1) (and (pos w4) (not (pos w1))))  
            (when (pos w2) (and (pos w1) (not (pos w2))))  
            (when (pos w3) (and (pos w2) (not (pos w3))))  
            (when (pos w4) (and (pos w3) (not (pos w4))))  
       )
  )
  (:action close
     :effect
       (and  
            (when (pos w1) (closed w1))  
            (when (pos w2) (closed w2))  
            (when (pos w3) (closed w3))  
            (when (pos w4) (closed w4))  
       )
  )
  (:action lock
     :effect
       (and 
            (when (and (pos w1) (closed w1) (not (locker_damaged w1))) (locked w1))  
            (when (and (pos w2) (closed w2) (not (locker_damaged w2))) (locked w2))  
            (when (and (pos w3) (closed w3) (not (locker_damaged w3))) (locked w3))  
            (when (and (pos w4) (closed w4) (not (locker_damaged w4))) (locked w4))  
       )
  )
)


