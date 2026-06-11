
(define (problem ring-new-6)
  (:domain d-ring-new-6)
  (:init  
      

	   	 
	 (oneof (locker_damaged w1) (not (locker_damaged w1)))  	   	 
	 (oneof (locker_damaged w2) (not (locker_damaged w2)))  	   	 
	 (oneof (locker_damaged w3) (not (locker_damaged w3)))  	   	 
	 (oneof (locker_damaged w4) (not (locker_damaged w4)))  	   	 
	 (oneof (locker_damaged w5) (not (locker_damaged w5)))  	   	 
	 (oneof (locker_damaged w6) (not (locker_damaged w6)))  	   	 
	 (oneof (closed w1) (not (closed w1)))  	   	 
	 (oneof (closed w2) (not (closed w2)))  	   	 
	 (oneof (closed w3) (not (closed w3)))  	   	 
	 (oneof (closed w4) (not (closed w4)))  	   	 
	 (oneof (closed w5) (not (closed w5)))  	   	 
	 (oneof (closed w6) (not (closed w6)))  
        (oneof  (pos w1)  (pos w2)  (pos w3)  (pos w4)  (pos w5)  (pos w6) )

     )


  

  (:goal (and  
           (or (locked w1) (locker_damaged w1)) 
           (or (locked w2) (locker_damaged w2)) 
           (or (locked w3) (locker_damaged w3)) 
           (or (locked w4) (locker_damaged w4)) 
           (or (locked w5) (locker_damaged w5)) 
           (or (locked w6) (locker_damaged w6)) 
           (closed w1) 
           (closed w2) 
           (closed w3) 
           (closed w4) 
           (closed w5) 
           (closed w6) 
         )
  )
)


