(define (problem emptyroom-emptyroom-d16-g8-corners)
 (:domain emptyroom)
 (:init


      (oneof (x p1) (x p16) 
      ) 
      (oneof (y p1) (y p16) 
      ) 
       ) 
 (:goal
       (and (x p9)(y p9))
       ))

