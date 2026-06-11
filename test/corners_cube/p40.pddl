
(define (problem cube-cube-d40-g20-corners)
 (:domain cube)
 (:init


      (oneof (x p1) (x p40) 
      ) 
      (oneof (y p1) (y p40) 
      ) 
      (oneof (z p1) (z p40) 
      ) 
       ) 
 (:goal
       (and (x p21)(y p21)(z p21))
       ))

