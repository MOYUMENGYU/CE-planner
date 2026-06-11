
(define (problem cube-cube-d12-g6-corners)
 (:domain cube)
 (:init


      (oneof (x p1) (x p12) 
      ) 
      (oneof (y p1) (y p12) 
      ) 
      (oneof (z p1) (z p12) 
      ) 
       )
 (:goal
       (and (x p7)(y p7)(z p7))
       ))

