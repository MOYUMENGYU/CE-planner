
(define (domain push-to) 

   (:requirements :strips :typing)
   (:types pos obj)
   (:predicates (adj ?i ?j - pos) (at ?i - pos) (holding ?o - obj) (obj-at ?o - obj ?i - pos)
                (pick-loc ?i - pos))
   (:action move
      :parameters (?i - pos ?j - pos )
      :precondition (and (adj ?i ?j) (at ?i))
      :effect (and (not (at ?i)) (at ?j)))
   (:action pickup
      :parameters (?o - obj ?i - pos )
      :precondition (and (at ?i) (pick-loc ?i))
      :effect (when (obj-at ?o ?i) (and (holding ?o) (not (obj-at ?o ?i)))))
   (:action push
      :parameters (?o - obj ?i - pos  ?j - pos )
      :precondition (and (adj ?i ?j) (at ?i))
      :effect (when (obj-at ?o ?i) (and (obj-at ?o ?j) (not (obj-at ?o ?i)))
      ))
)

