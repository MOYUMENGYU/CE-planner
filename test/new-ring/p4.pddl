
(define (problem ring-new-4)
  (:domain d-ring-new-4)
  (:init  
      

	   	 
	 (oneof (locker_damaged w1) (not (locker_damaged w1)))  	   	 
	 (oneof (locker_damaged w2) (not (locker_damaged w2)))  	   	 
	 (oneof (locker_damaged w3) (not (locker_damaged w3)))  	   	 
	 (oneof (locker_damaged w4) (not (locker_damaged w4)))  	   	 
	 (oneof (closed w1) (not (closed w1)))  	   	 
	 (oneof (closed w2) (not (closed w2)))  	   	 
	 (oneof (closed w3) (not (closed w3)))  	   	 
	 (oneof (closed w4) (not (closed w4)))  
        (oneof  (pos w1)  (pos w2)  (pos w3)  (pos w4) )

     )


  

  (:goal (and  
           (or (locked w1) (locker_damaged w1)) 
           (or (locked w2) (locker_damaged w2)) 
           (or (locked w3) (locker_damaged w3)) 
           (or (locked w4) (locker_damaged w4)) 
           (closed w1) 
           (closed w2) 
           (closed w3) 
           (closed w4) 
         )
  )
)


