
(define (problem cube-10)
 (:domain cube)
 (:init


      (oneof  (x p1)  (x p2)  (x p3)  (x p4)  (x p5)  (x p6)  (x p7)  (x p8)  (x p9)  )
      (oneof  (y p1)  (y p2)  (y p3)  (y p4)  (y p5)  (y p6)  (y p7)  (y p8)  (y p9)  )
      (oneof  (z p1)  (z p2)  (z p3)  (z p4)  (z p5)  (z p6)  (z p7)  (z p8)  (z p9)  ))
 
 (:goal
       (and (x p6) (y p6) (z p6))))

