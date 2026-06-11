
(define (domain reward) 

   (:requirements :strips )
   (:predicates (adj ?pi ?pj) (goal ?o)
                (at ?pi) (obj-at ?o ?pi))
   (:action move
      :parameters (?pi ?pj)
      :precondition (and (adj ?pi ?pj) (at ?pi))
      :effect (and (not (at ?pi)) (at ?pj)))
   (:action shout
      :parameters (?o ?pi)
      :precondition (at ?pi)
      :effect (when (obj-at ?o ?pi) (goal ?o))))

