
(define (problem cube-7)
 (:domain cube)
 (:init


      (oneof  (x p1)  (x p2)  (x p3)  (x p4)  (x p5)  (x p6)  (x p7)  )
      (oneof  (y p1)  (y p2)  (y p3)  (y p4)  (y p5)  (y p6)  (y p7)  )
      (oneof  (z p1)  (z p2)  (z p3)  (z p4)  (z p5)  (z p6)  (z p7)  ))
 
 (:goal
       (and (x p4) (y p4) (z p4))))

