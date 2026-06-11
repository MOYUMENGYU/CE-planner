
(define (problem cube-cube-d64-g32-corners)
 (:domain cube)
 (:init


      (oneof (x p1) (x p64) 
      ) 
      (oneof (y p1) (y p64) 
      ) 
      (oneof (z p1) (z p64) 
      ) 
       ) 
 (:goal
       (and (x p33)(y p33)(z p33))
       ))

