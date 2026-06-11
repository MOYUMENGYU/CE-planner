
(define (problem cube-cube-d28-g14-corners)
 (:domain cube)
 (:init


      (oneof (x p1) (x p28) 
      ) 
      (oneof (y p1) (y p28) 
      ) 
      (oneof (z p1) (z p28) 
      ) 
       ) 
 (:goal
       (and (x p15)(y p15)(z p15))
       ))

