
(define (problem cube-cube-d8-g4-corners)
 (:domain cube)
 (:init


      (oneof (x p1) (x p8) 
      ) 
      (oneof (y p1) (y p8) 
      ) 
      (oneof (z p1) (z p8) 
      ) 
       )
 (:goal
       (and (x p5)(y p5)(z p5))
       ))

