
(define (domain emptyroom)
  (:requirements :typing :equality)
  (:types pos)
  (:constants

   p1    p2    p3    p4 
- pos)
  (:predicates
     (x ?p - pos)
     (y ?p - pos)
  )
  (:action right
     :effect
       (and

     (when (x p1) (and (not (x p1)) (x p2)))
     (when (x p2) (and (not (x p2)) (x p3)))
     (when (x p3) (and (not (x p3)) (x p4)))

       )
  )
  (:action left
     :effect
       (and

     (when (x p2) (and (not (x p2)) (x p1)))
     (when (x p3) (and (not (x p3)) (x p2)))
     (when (x p4) (and (not (x p4)) (x p3)))

)
  )
  (:action down
     :effect
       (and

     (when (y p1) (and (not (y p1)) (y p2)))
     (when (y p2) (and (not (y p2)) (y p3)))
     (when (y p3) (and (not (y p3)) (y p4)))

       )
  )
  (:action up
     :effect
       (and

     (when (y p2) (and (not (y p2)) (y p1)))
     (when (y p3) (and (not (y p3)) (y p2)))
     (when (y p4) (and (not (y p4)) (y p3)))

       )
  )
)

