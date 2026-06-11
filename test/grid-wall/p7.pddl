;; Enrico Scala <enricos83@gmail.com> and Alban Grastien <Alban.Grastien@data61.csiro.au>
(define (problem instance_7__12345)
(:domain grid)

(:init
       (oneof (x zero)(x one)(x two)(x three)(x four)(x five)(x six))
				(oneof (y zero)(y one)(y two)(y three)(y four)(y five)(y six))
				(or (not (x five)) (not (y two))))




(:goal (or (x three) (y zero)) ))

