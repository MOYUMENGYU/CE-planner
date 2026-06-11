


(define (problem bomb-10-1)
(:domain bomb)
(:objects bomb1 bomb2 bomb3 bomb4 bomb5 bomb6 bomb7 bomb8 bomb9 bomb10 toilet1 )
(:init

(bomb bomb1)
(bomb bomb2)
(bomb bomb3)
(bomb bomb4)
(bomb bomb5)
(bomb bomb6)
(bomb bomb7)
(bomb bomb8)
(bomb bomb9)
(bomb bomb10)
(toilet toilet1)

(oneof (armed bomb1) (not (armed bomb1)))
(oneof (armed bomb2) (not (armed bomb2)))
(oneof (armed bomb3) (not (armed bomb3)))
(oneof (armed bomb4) (not (armed bomb4)))
(oneof (armed bomb5) (not (armed bomb5)))
(oneof (armed bomb6) (not (armed bomb6)))
(oneof (armed bomb7) (not (armed bomb7)))
(oneof (armed bomb8) (not (armed bomb8)))
(oneof (armed bomb9) (not (armed bomb9)))
(oneof (armed bomb10) (not (armed bomb10)))

)
(:goal
(and
(not (armed bomb1))
(not (armed bomb2))
(not (armed bomb3))
(not (armed bomb4))
(not (armed bomb5))
(not (armed bomb6))
(not (armed bomb7))
(not (armed bomb8))
(not (armed bomb9))
(not (armed bomb10))
)
)
)


