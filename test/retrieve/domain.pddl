
(define (domain retrieve) 

   (:requirements :strips)
   (:predicates (adj ?i ?j) (at ?i) (holding ?i) (obj-at ?o ?i))
   (:action move
      :parameters (?i ?j)
      :precondition (and (adj ?i ?j) (at ?i))
      :effect (and (not (at ?i)) (at ?j)))
   (:action pickup
      :parameters (?o ?i)
      :precondition (at ?i)
      :effect (when (obj-at ?o ?i) (and (holding ?o) (not (obj-at ?o ?i))))))

