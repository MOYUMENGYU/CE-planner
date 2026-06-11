(define (problem bt2)
(:domain bt)
(:objects b0 - bomb p0 p1 - package  )
 (:init 
	(notdefused b0)
	(oneof (in p0 b0) (in p1 b0))
 )

 (:goal (and (defused b0)))
)
