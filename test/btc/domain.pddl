(define (domain btc)

  (:types package bomb toilet)
  (:predicates
   (in ?p - package ?b - bomb)
   (defused ?b - bomb)
   (clog ?toilet - toilet)
  )

  (:action dunk	
   :parameters (?p - package 
                ?b - bomb 
                ?t - toilet)
   :precondition (and (not (clog ?t)))
   :effect(and (when (and (in ?p ?b) (not (defused ?b))) (defused ?b)) (clog ?t) )
            
  )

 (:action flush	
  :parameters (?t - toilet)      
  :effect (and (when (clog ?t) (not (clog ?t))))
 )
)
