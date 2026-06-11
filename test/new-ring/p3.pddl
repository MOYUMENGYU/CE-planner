
(define (problem ring-new-3)
  (:domain d-ring-new-3)
  (:init  
      

	   	 
	 (oneof (locker_damaged w1) (not (locker_damaged w1)))  	   	 
	 (oneof (locker_damaged w2) (not (locker_damaged w2)))  	   	 
	 (oneof (locker_damaged w3) (not (locker_damaged w3)))  	   	 
	 (oneof (closed w1) (not (closed w1)))  	   	 
	 (oneof (closed w2) (not (closed w2)))  	   	 
	 (oneof (closed w3) (not (closed w3)))  
        (oneof  (pos w1)  (pos w2)  (pos w3) )

     )


  

  (:goal (and  
           (or (locked w1) (locker_damaged w1)) 
           (or (locked w2) (locker_damaged w2)) 
           (or (locked w3) (locker_damaged w3)) 
           (closed w1) 
           (closed w2) 
           (closed w3) 
         )
  )
)


