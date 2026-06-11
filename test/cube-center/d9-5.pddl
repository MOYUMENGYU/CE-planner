
(define (domain cube)
  (:requirements :typing :equality)
  (:types pos)
  (:constants

   p1    p2    p3    p4    p5    p6    p7    p8    p9 
- pos)
  (:predicates
     (x ?p - pos)
     (y ?p - pos)
     (z ?p - pos)
  )
  (:action right
     :effect
       (and

     (when (x p1) (and (not (x p1)) (x p2)))
     (when (x p2) (and (not (x p2)) (x p3)))
     (when (x p3) (and (not (x p3)) (x p4)))
     (when (x p4) (and (not (x p4)) (x p5)))
     (when (x p5) (and (not (x p5)) (x p6)))
     (when (x p6) (and (not (x p6)) (x p7)))
     (when (x p7) (and (not (x p7)) (x p8)))
     (when (x p8) (and (not (x p8)) (x p9)))

       )
  )
  (:action left
     :effect
       (and

     (when (x p2) (and (not (x p2)) (x p1)))
     (when (x p3) (and (not (x p3)) (x p2)))
     (when (x p4) (and (not (x p4)) (x p3)))
     (when (x p5) (and (not (x p5)) (x p4)))
     (when (x p6) (and (not (x p6)) (x p5)))
     (when (x p7) (and (not (x p7)) (x p6)))
     (when (x p8) (and (not (x p8)) (x p7)))
     (when (x p9) (and (not (x p9)) (x p8)))

)
  )
  (:action down
     :effect
       (and

     (when (y p1) (and (not (y p1)) (y p2)))
     (when (y p2) (and (not (y p2)) (y p3)))
     (when (y p3) (and (not (y p3)) (y p4)))
     (when (y p4) (and (not (y p4)) (y p5)))
     (when (y p5) (and (not (y p5)) (y p6)))
     (when (y p6) (and (not (y p6)) (y p7)))
     (when (y p7) (and (not (y p7)) (y p8)))
     (when (y p8) (and (not (y p8)) (y p9)))

       )
  )
  (:action up
     :effect
       (and

     (when (y p2) (and (not (y p2)) (y p1)))
     (when (y p3) (and (not (y p3)) (y p2)))
     (when (y p4) (and (not (y p4)) (y p3)))
     (when (y p5) (and (not (y p5)) (y p4)))
     (when (y p6) (and (not (y p6)) (y p5)))
     (when (y p7) (and (not (y p7)) (y p6)))
     (when (y p8) (and (not (y p8)) (y p7)))
     (when (y p9) (and (not (y p9)) (y p8)))

       )
  )
  (:action in
     :effect
       (and

     (when (z p1) (and (not (z p1)) (z p2)))
     (when (z p2) (and (not (z p2)) (z p3)))
     (when (z p3) (and (not (z p3)) (z p4)))
     (when (z p4) (and (not (z p4)) (z p5)))
     (when (z p5) (and (not (z p5)) (z p6)))
     (when (z p6) (and (not (z p6)) (z p7)))
     (when (z p7) (and (not (z p7)) (z p8)))
     (when (z p8) (and (not (z p8)) (z p9)))

       )
  )
  (:action out
     :effect
       (and

     (when (z p2) (and (not (z p2)) (z p1)))
     (when (z p3) (and (not (z p3)) (z p2)))
     (when (z p4) (and (not (z p4)) (z p3)))
     (when (z p5) (and (not (z p5)) (z p4)))
     (when (z p6) (and (not (z p6)) (z p5)))
     (when (z p7) (and (not (z p7)) (z p6)))
     (when (z p8) (and (not (z p8)) (z p7)))
     (when (z p9) (and (not (z p9)) (z p8)))

       )
  )
)

