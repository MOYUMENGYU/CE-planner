(define (problem btc03)
(:domain btc)

(:objects b0 - bomb
          p0 p1 p2 - package
          t0  - toilet)
(:init 

(oneof
(in p0 b0)
(in p1 b0)
(in p2 b0)

))

 
 (:goal (defused b0)))
