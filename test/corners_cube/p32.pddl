
(define (problem cube-cube-d32-g16-corners)
 (:domain cube)
 (:init


      (oneof (x p1) (x p32) 
      ) 
      (oneof (y p1) (y p32) 
      ) 
      (oneof (z p1) (z p32) 
      ) 
       ) 
 (:goal
       (and (x p17)(y p17)(z p17))
       ))

