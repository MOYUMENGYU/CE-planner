
(define (problem ring-2)
  (:domain d-ring-2)
  (:init  
        (oneof (open w1) (closed w1) (locked w1))  
        (oneof (open w2) (closed w2) (locked w2))  
        (oneof  (pos w1)  (pos w2) )

  )

  (:goal (and  
              (locked w1) 
              (locked w2) 
         )
  )
)


