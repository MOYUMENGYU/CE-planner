
(define (problem cube-cube-d52-g26-corners)
 (:domain cube)
 (:init


      (oneof (x p1) (x p52) 
      ) 
      (oneof (y p1) (y p52) 
      ) 
      (oneof (z p1) (z p52) 
      ) 
       ) 
 (:goal
       (and (x p27)(y p27)(z p27))
       ))

