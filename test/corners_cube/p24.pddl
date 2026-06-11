
(define (problem cube-cube-d24-g12-corners)
 (:domain cube)
 (:init


      (oneof (x p1) (x p24) 
      ) 
      (oneof (y p1) (y p24) 
      ) 
      (oneof (z p1) (z p24) 
      ) 
       ) 
 (:goal
       (and (x p13)(y p13)(z p13))
       ))

