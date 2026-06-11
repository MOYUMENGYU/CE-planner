(define (problem bt3)
(:domain bt)
(:objects b0 - bomb p0 p1 p2 p3  - package	   )
 (:init 

(notdefused b0)
(oneof (in p0 b0)
(in p1 b0)
(in p2 b0)
(in p3 b0)

))

 
 (:goal (and (defused b0))))
