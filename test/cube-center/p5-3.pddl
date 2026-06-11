
(define (problem cube-5)
 (:domain cube)
 (:init


      (oneof  (x p1)  (x p2)  (x p3)  (x p4)  (x p5)  )
      (oneof  (y p1)  (y p2)  (y p3)  (y p4)  (y p5)  )
      (oneof  (z p1)  (z p2)  (z p3)  (z p4)  (z p5)  ))
 
 (:goal
       (and (x p3) (y p3) (z p3))))

