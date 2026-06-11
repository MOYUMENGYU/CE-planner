
(define (domain d-ring-new-9)
  (:requirements :typing :equality)
  (:types window)
  (:constants  w1  w2  w3  w4  w5  w6  w7  w8  w9  - window)
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
            (when (pos w4) (and (pos w5) (not (pos w4))))  
            (when (pos w5) (and (pos w6) (not (pos w5))))  
            (when (pos w6) (and (pos w7) (not (pos w6))))  
            (when (pos w7) (and (pos w8) (not (pos w7))))  
            (when (pos w8) (and (pos w9) (not (pos w8))))  
            (when (pos w9) (and (pos w1) (not (pos w9))))  
       )
  )
  (:action bwd
     :effect
       (and 
            (when (pos w1) (and (pos w9) (not (pos w1))))  
            (when (pos w2) (and (pos w1) (not (pos w2))))  
            (when (pos w3) (and (pos w2) (not (pos w3))))  
            (when (pos w4) (and (pos w3) (not (pos w4))))  
            (when (pos w5) (and (pos w4) (not (pos w5))))  
            (when (pos w6) (and (pos w5) (not (pos w6))))  
            (when (pos w7) (and (pos w6) (not (pos w7))))  
            (when (pos w8) (and (pos w7) (not (pos w8))))  
            (when (pos w9) (and (pos w8) (not (pos w9))))  
       )
  )
  (:action close
     :effect
       (and  
            (when (pos w1) (closed w1))  
            (when (pos w2) (closed w2))  
            (when (pos w3) (closed w3))  
            (when (pos w4) (closed w4))  
            (when (pos w5) (closed w5))  
            (when (pos w6) (closed w6))  
            (when (pos w7) (closed w7))  
            (when (pos w8) (closed w8))  
            (when (pos w9) (closed w9))  
       )
  )
  (:action lock
     :effect
       (and 
            (when (and (pos w1) (closed w1) (not (locker_damaged w1))) (locked w1))  
            (when (and (pos w2) (closed w2) (not (locker_damaged w2))) (locked w2))  
            (when (and (pos w3) (closed w3) (not (locker_damaged w3))) (locked w3))  
            (when (and (pos w4) (closed w4) (not (locker_damaged w4))) (locked w4))  
            (when (and (pos w5) (closed w5) (not (locker_damaged w5))) (locked w5))  
            (when (and (pos w6) (closed w6) (not (locker_damaged w6))) (locked w6))  
            (when (and (pos w7) (closed w7) (not (locker_damaged w7))) (locked w7))  
            (when (and (pos w8) (closed w8) (not (locker_damaged w8))) (locked w8))  
            (when (and (pos w9) (closed w9) (not (locker_damaged w9))) (locked w9))  
       )
  )
)


