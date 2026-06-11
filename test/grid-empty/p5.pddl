;; Enrico Scala <enricos83@gmail.com> and Alban Grastien <Alban.Grastien@data61.csiro.au>
(define (problem instance_5__12345)
(:domain grid)

(:init
       (oneof (x zero)(x one)(x two)(x three)(x four))
				(oneof (y zero)(y one)(y two)(y three)(y four))
				(or (not (x four)) (not (y two))))



(:goal (or (x two) (y zero)) ))

