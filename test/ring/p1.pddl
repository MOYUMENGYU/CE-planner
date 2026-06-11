
(define (problem ring-1)
  (:domain d-ring-1)
  (:init  
        (oneof (open w1) (closed w1) (locked w1))  
        (oneof  (pos w1) )

  )

  (:goal (and  
              (locked w1) 
         )
  )
)


