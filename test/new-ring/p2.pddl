
(define (problem ring-new-2)
  (:domain d-ring-new-2)
  (:init  
      

	   	 
	 (oneof (locker_damaged w1) (not (locker_damaged w1)))  	   	 
	 (oneof (locker_damaged w2) (not (locker_damaged w2)))  	   	 
	 (oneof (closed w1) (not (closed w1)))  	   	 
	 (oneof (closed w2) (not (closed w2)))  
        (oneof  (pos w1)  (pos w2) )

     )


  

  (:goal (and  
           (or (locked w1) (locker_damaged w1)) 
           (or (locked w2) (locker_damaged w2)) 
           (closed w1) 
           (closed w2) 
         )
  )
)


