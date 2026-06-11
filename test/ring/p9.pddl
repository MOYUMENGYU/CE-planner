
(define (problem ring-9)
  (:domain d-ring-9)
  (:init  
        (oneof (open w1) (closed w1) (locked w1))  
        (oneof (open w2) (closed w2) (locked w2))  
        (oneof (open w3) (closed w3) (locked w3))  
        (oneof (open w4) (closed w4) (locked w4))  
        (oneof (open w5) (closed w5) (locked w5))  
        (oneof (open w6) (closed w6) (locked w6))  
        (oneof (open w7) (closed w7) (locked w7))  
        (oneof (open w8) (closed w8) (locked w8))  
        (oneof (open w9) (closed w9) (locked w9))  
        (oneof  (pos w1)  (pos w2)  (pos w3)  (pos w4)  (pos w5)  (pos w6)  (pos w7)  (pos w8)  (pos w9) )

  )

  (:goal (and  
              (locked w1) 
              (locked w2) 
              (locked w3) 
              (locked w4) 
              (locked w5) 
              (locked w6) 
              (locked w7) 
              (locked w8) 
              (locked w9) 
         )
  )
)


