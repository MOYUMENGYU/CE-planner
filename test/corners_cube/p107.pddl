
(define (problem cube-cube-d107-g53-corners)
 (:domain cube)
 (:init


      (oneof (x p1) (x p107) 
      ) 
      (oneof (y p1) (y p107) 
      ) 
      (oneof (z p1) (z p107) 
      ) 
       )
 (:goal
       (and (x p54)(y p54)(z p54))
       ))

