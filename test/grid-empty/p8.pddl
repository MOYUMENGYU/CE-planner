;; Enrico Scala <enricos83@gmail.com> and Alban Grastien <Alban.Grastien@data61.csiro.au>
(define (problem instance_8__12345)
(:domain grid)

(:init
       (oneof (x zero)(x one)(x two)(x three)(x four)(x five)(x six)(x seven))
				(oneof (y zero)(y one)(y two)(y three)(y four)(y five)(y six)(y seven))
				(or (not (x six)) (not (y three))))



(:goal (or (x three) (y zero)) ))

