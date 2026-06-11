
(define (domain to-trash) 

   (:requirements :strips)
   (:constants  o1) 
   (:predicates (adj ?i ?j) (at ?i) (holding ?o) (obj-at ?o ?i) (handempty))
   (:action move
      :parameters (?i ?j)
      :precondition (and (adj ?i ?j) (at ?i))
      :effect (and (not (at ?i)) (at ?j)))
   (:action pickup
      :parameters (?p )
      :precondition (at ?p) 
      :effect (and 
                 (when (and (handempty) (obj-at o1 ?p))
                       (and (not (handempty)) (holding o1) (not (obj-at o1 ?p))))
                 (when (holding o1)
                       (and (handempty) (not (holding o1)) ))
                       ))
   (:action putdown
      :parameters (?p)
      :precondition (at ?p)
      :effect (and 
                 (when (holding o1)
                       (and (handempty) (not (holding o1)) (obj-at o1 ?p)))
                       ))
      )

