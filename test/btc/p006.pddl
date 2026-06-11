(define (problem btc3)
(:domain btc)

(:objects b0 - bomb
          p0 p1 p2 p3 p4 p5 - package
          t0  - toilet)
 (:init 

(oneof (in p0 b0)
(in p1 b0)
(in p2 b0)
(in p3 b0)
(in p4 b0)
(in p5 b0)
)
)
 
 (:goal (defused b0)))
