


(define (problem bomb-5-5)
(:domain bomb)
(:objects bomb1 bomb2 bomb3 bomb4 bomb5 toilet1 toilet2 toilet3 toilet4 toilet5 )
(:init

(bomb bomb1)
(bomb bomb2)
(bomb bomb3)
(bomb bomb4)
(bomb bomb5)
(toilet toilet1)
(toilet toilet2)
(toilet toilet3)
(toilet toilet4)
(toilet toilet5)
(oneof (armed bomb1) (not(armed bomb1)) )
(oneof (armed bomb2) (not (armed bomb2)))
(oneof (armed bomb3) (not (armed bomb3)))
(oneof (armed bomb4) (not (armed bomb4)))
(oneof (armed bomb5) (not (armed bomb5)))

)
(:goal
(and
(not (armed bomb1))
(not (armed bomb2))
(not (armed bomb3))
(not (armed bomb4))
(not (armed bomb5))
)
)
)


