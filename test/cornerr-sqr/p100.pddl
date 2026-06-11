
(define (problem emptyroom-emptyroom-d100-g50-corners)
 (:domain emptyroom)
 (:init

      (oneof (x p1) (x p100) 
      ) 
      (oneof (y p1) (y p100) 
      ) 
       ) 
 (:goal
       (and (x p51)(y p51))
       ))

