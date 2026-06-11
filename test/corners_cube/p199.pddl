
(define (problem cube-cube-d199-g99-corners)
 (:domain cube)
 (:init


      (oneof (x p1) (x p199) 
      ) 
      (oneof (y p1) (y p199) 
      ) 
      (oneof (z p1) (z p199) 
      ) 
       ) 
 (:goal
       (and (x p100)(y p100)(z p100))
       ))

