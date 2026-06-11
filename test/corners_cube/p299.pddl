
(define (problem cube-cube-d299-g149-corners)
 (:domain cube)
 (:init


      (oneof (x p1) (x p299) 
      ) 
      (oneof (y p1) (y p299) 
      ) 
      (oneof (z p1) (z p299) 
      ) 
       ) 
 (:goal
       (and (x p150)(y p150)(z p150))
       ))

