
(define (domain d-ring-1)
  (:requirements :typing :equality)
  (:types window)
  (:constants  w1  - window)
  (:predicates
     (pos ?w - window)
     (closed ?w - window)
     (open ?w - window)
     (locked ?w - window)
  )
  (:action fwd
     :effect
       (and 
            (when (pos w1) (and (pos w1) (not (pos w1))))  
       )
  )
  (:action bwd
     :effect
       (and 
            (when (pos w1) (and (pos w1) (not (pos w1))))  
       )
  )
  (:action close
     :effect
       (and  
            (when (and (open w1) (pos w1)) (closed w1))  
       )
  )
  (:action lock
     :effect
       (and 
            (when (and (pos w1) (closed w1)) (locked w1))  
       )
  )
)


