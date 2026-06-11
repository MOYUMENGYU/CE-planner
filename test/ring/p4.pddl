
(define (problem ring-4)
  (:domain d-ring-4)
  (:init  
        (oneof (open w1) (closed w1) (locked w1))  
        (oneof (open w2) (closed w2) (locked w2))  
        (oneof (open w3) (closed w3) (locked w3))  
        (oneof (open w4) (closed w4) (locked w4))  
        (oneof  (pos w1)  (pos w2)  (pos w3)  (pos w4) )

  )

  (:goal (and  
              (locked w1) 
              (locked w2) 
              (locked w3) 
              (locked w4) 
         )
  )
)


