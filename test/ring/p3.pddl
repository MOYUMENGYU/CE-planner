
(define (problem ring-3)
  (:domain d-ring-3)
  (:init  
        (oneof (open w1) (closed w1) (locked w1))  
        (oneof (open w2) (closed w2) (locked w2))  
        (oneof (open w3) (closed w3) (locked w3))  
        (oneof  (pos w1)  (pos w2)  (pos w3) )

  )

  (:goal (and  
              (locked w1) 
              (locked w2) 
              (locked w3) 
         )
  )
)


