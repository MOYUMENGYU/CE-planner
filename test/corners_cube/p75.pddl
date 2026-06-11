
(define (problem cube-cube-d75-g37-corners)
 (:domain cube)
 (:init


      (oneof (x p1) (x p75) 
      ) 
      (oneof (y p1) (y p75) 
      ) 
      (oneof (z p1) (z p75) 
      ) 
       ) 
 (:goal
       (and (x p38)(y p38)(z p38))
       ))

