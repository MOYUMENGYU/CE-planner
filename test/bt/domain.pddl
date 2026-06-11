(define (domain bt)
  (:types package bomb )
  (:predicates
   (in ?p - package ?b - bomb)
   (defused ?b - bomb)
   (notdefused ?b - bomb))

  (:action dunk
   :parameters (?p - package ?b - bomb)     
   :effect 
     (and (when (and (notdefused ?b) (in ?p ?b))
       (defused ?b)
     )
     )
  )
 
 )
  
