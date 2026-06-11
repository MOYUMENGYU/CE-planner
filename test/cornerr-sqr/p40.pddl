(define (problem emptyroom-emptyroom-d40-g20-corners)
 (:domain emptyroom)
 (:init


      (oneof (x p1) (x p40) 
      ) 
      (oneof (y p1) (y p40) 
      ) 
       ) 
 (:goal
       (and (x p21)(y p21))
       ))

