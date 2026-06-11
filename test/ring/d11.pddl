
(define (domain d-ring-11)
  (:requirements :typing :equality)
  (:types window)
  (:constants  w1  w2  w3  w4  w5  w6  w7  w8  w9  w10  w11  - window)
  (:predicates
     (pos ?w - window)
     (closed ?w - window)
     (open ?w - window)
     (locked ?w - window)
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
            (when (pos w9) (and (pos w10) (not (pos w9))))  
            (when (pos w10) (and (pos w11) (not (pos w10))))  
            (when (pos w11) (and (pos w1) (not (pos w11))))  
       )
  )
  (:action bwd
     :effect
       (and 
            (when (pos w1) (and (pos w11) (not (pos w1))))  
            (when (pos w2) (and (pos w1) (not (pos w2))))  
            (when (pos w3) (and (pos w2) (not (pos w3))))  
            (when (pos w4) (and (pos w3) (not (pos w4))))  
            (when (pos w5) (and (pos w4) (not (pos w5))))  
            (when (pos w6) (and (pos w5) (not (pos w6))))  
            (when (pos w7) (and (pos w6) (not (pos w7))))  
            (when (pos w8) (and (pos w7) (not (pos w8))))  
            (when (pos w9) (and (pos w8) (not (pos w9))))  
            (when (pos w10) (and (pos w9) (not (pos w10))))  
            (when (pos w11) (and (pos w10) (not (pos w11))))  
       )
  )
  (:action close
     :effect
       (and  
            (when (and (open w1) (pos w1)) (closed w1))  
            (when (and (open w2) (pos w2)) (closed w2))  
            (when (and (open w3) (pos w3)) (closed w3))  
            (when (and (open w4) (pos w4)) (closed w4))  
            (when (and (open w5) (pos w5)) (closed w5))  
            (when (and (open w6) (pos w6)) (closed w6))  
            (when (and (open w7) (pos w7)) (closed w7))  
            (when (and (open w8) (pos w8)) (closed w8))  
            (when (and (open w9) (pos w9)) (closed w9))  
            (when (and (open w10) (pos w10)) (closed w10))  
            (when (and (open w11) (pos w11)) (closed w11))  
       )
  )
  (:action lock
     :effect
       (and 
            (when (and (pos w1) (closed w1)) (locked w1))  
            (when (and (pos w2) (closed w2)) (locked w2))  
            (when (and (pos w3) (closed w3)) (locked w3))  
            (when (and (pos w4) (closed w4)) (locked w4))  
            (when (and (pos w5) (closed w5)) (locked w5))  
            (when (and (pos w6) (closed w6)) (locked w6))  
            (when (and (pos w7) (closed w7)) (locked w7))  
            (when (and (pos w8) (closed w8)) (locked w8))  
            (when (and (pos w9) (closed w9)) (locked w9))  
            (when (and (pos w10) (closed w10)) (locked w10))  
            (when (and (pos w11) (closed w11)) (locked w11))  
       )
  )
)


