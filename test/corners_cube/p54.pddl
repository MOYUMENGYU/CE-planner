(define (problem cube-cube-d54-g27-corners)
 (:domain cube)
 (:init


      (oneof (x p1) (x p54) 
      ) 
      (oneof (y p1) (y p54) 
      ) 
      (oneof (z p1) (z p54) 
      ) 
       ) 
 (:goal
       (and (x p28)(y p28)(z p28))
       ))

