(define (problem cube-cube-d16-g8-corners)
 (:domain cube)
 (:init


      (oneof (x p1) (x p16) 
      ) 
      (oneof (y p1) (y p16) 
      ) 
      (oneof (z p1) (z p16) 
      ) 
       ) 
 (:goal
       (and (x p9)(y p9)(z p9))
       ))

