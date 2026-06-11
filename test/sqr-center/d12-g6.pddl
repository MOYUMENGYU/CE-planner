
(define (domain emptyroom)
  (:requirements :typing :equality)
  (:types pos)
  (:constants

   p1    p2    p3    p4    p5    p6    p7    p8    p9    p10    p11    p12 
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
     (when (x p4) (and (not (x p4)) (x p5)))
     (when (x p5) (and (not (x p5)) (x p6)))
     (when (x p6) (and (not (x p6)) (x p7)))
     (when (x p7) (and (not (x p7)) (x p8)))
     (when (x p8) (and (not (x p8)) (x p9)))
     (when (x p9) (and (not (x p9)) (x p10)))
     (when (x p10) (and (not (x p10)) (x p11)))
     (when (x p11) (and (not (x p11)) (x p12)))

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
     (when (x p10) (and (not (x p10)) (x p9)))
     (when (x p11) (and (not (x p11)) (x p10)))
     (when (x p12) (and (not (x p12)) (x p11)))

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
     (when (y p9) (and (not (y p9)) (y p10)))
     (when (y p10) (and (not (y p10)) (y p11)))
     (when (y p11) (and (not (y p11)) (y p12)))

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
     (when (y p10) (and (not (y p10)) (y p9)))
     (when (y p11) (and (not (y p11)) (y p10)))
     (when (y p12) (and (not (y p12)) (y p11)))

       )
  )
)

