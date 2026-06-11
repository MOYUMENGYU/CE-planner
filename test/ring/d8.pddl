(define (domain ring)

  (:predicates (position ?x) (closed ?x) (locked ?x) (open ?x))

  (:action move-up
   :parameters ()
   :effect (and 
             (when (position pos1) 
		(and (not (position pos1)) (position pos2)))
             (when (position pos2) 
		(and (not (position pos2)) (position pos3)))
             (when (position pos3) 
		(and (not (position pos3)) (position pos4)))
             (when (position pos4) 
		(and (not (position pos4)) (position pos5)))
             (when (position pos5) 
		(and (not (position pos5)) (position pos6)))
	      (when (position pos6) 
		(and (not (position pos6)) (position pos7)))
	      (when (position pos7) 
		(and (not (position pos7)) (position pos8)))
	      (when (position pos8) 
		(and (not (position pos8)) (position pos1)))
	))

  (:action move-down
   :parameters ()
   :effect (and 
             (when (position pos1) 
		(and (not (position pos1)) (position pos8)))
             (when (position pos2) 
		(and (not (position pos2)) (position pos1)))
             (when (position pos3) 
		(and (not (position pos3)) (position pos2)))
             (when (position pos4) 
		(and (not (position pos4)) (position pos3)))
             (when (position pos5) 
		(and (not (position pos5)) (position pos4)))
	      (when (position pos6) 
		(and (not (position pos6)) (position pos5)))
	      (when (position pos7) 
		(and (not (position pos7)) (position pos6)))
	      (when (position pos8) 
		(and (not (position pos8)) (position pos7)))

 	))

   (:action lock
    :parameters ()
    :effect (and (when (and (position pos1)(closed win1))(locked win1))
	         (when (and (position pos2)(closed win2))(locked win2))
                 (when (and (position pos3)(closed win3))(locked win3))                 
                 (when (and (position pos4)(closed win4))(locked win4))
		(when (and (position pos5)(closed win5))(locked win5))	
		(when (and (position pos6)(closed win6))(locked win6))   
   		(when (and (position pos7)(closed win7))(locked win7))   
   		(when (and (position pos8)(closed win8))(locked win8))   

    ))

   (:action close
    :parameters ()
    :effect (and (when (and (open win1) (position pos1) )(closed win1))
	         (when (and (open win2) (position pos2) )(closed win2))
                 (when (and (open win3) (position pos3) )(closed win3))
                 (when (and (open win4) (position pos4) )(closed win4))
                 (when (and (open win5) (position pos5) )(closed win5))
                 (when (and (open win6) (position pos6) )(closed win6))    			
                 (when (and (open win7) (position pos7) )(closed win7))    			
                 (when (and (open win8) (position pos8) )(closed win8))    			
    ))

)
