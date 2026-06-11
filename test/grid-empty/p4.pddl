;; Enrico Scala <enricos83@gmail.com> and Alban Grastien <Alban.Grastien@data61.csiro.au>
(define (problem instance_4__12345)
(:domain grid)

(:init
       (oneof (x zero)(x one)(x two)(x three))
				(oneof (y zero)(y one)(y two)(y three))
				(or (not (x three)) (not (y one))))




(:goal (or (x two) (y zero)) ))

