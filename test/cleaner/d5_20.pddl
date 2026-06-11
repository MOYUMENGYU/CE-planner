;Cleaner Domain: rooms = 5

(define (domain cleaner)
  (:predicates
	(ROOM ?r)
	(OBJECT ?o)
	(position ?x)
	(cleaned ?r ?o)
	)
	(:action clean
	:parameters (?r ?o)
	:precondition (and (OBJECT ?o) (ROOM ?r))
	:effect (when (position ?r) (cleaned ?r ?o)))
	(:action fwd
	:parameters ()
	:effect (and
		(when (position r0) (and (position r1) (not (position r0))))
		(when (position r1) (and (position r2) (not (position r1))))
		(when (position r2) (and (position r3) (not (position r2))))
		(when (position r3) (and (position r4) (not (position r3))))
))
	(:action back
	:parameters ()
	:effect (and
		(when (position r1) (and (position r0) (not (position r1))))
		(when (position r2) (and (position r1) (not (position r2))))
		(when (position r3) (and (position r2) (not (position r3))))
		(when (position r4) (and (position r3) (not (position r4))))
)))
