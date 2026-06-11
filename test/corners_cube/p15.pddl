(define (problem cube-cube-d15-g7-corners)
 (:domain cube)
 (:init


      (oneof (x p1) (x p15) 
      ) 
      (oneof (y p1) (y p15) 
      ) 
      (oneof (z p1) (z p15) 
      ) 
       ) 
 (:goal
       (and (x p8)(y p8)(z p8))
       ))

