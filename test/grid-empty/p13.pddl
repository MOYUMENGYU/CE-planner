;; Enrico Scala <enricos83@gmail.com> and Alban Grastien <Alban.Grastien@data61.csiro.au>
(define (problem instance_13__12345)
(:domain grid)

(:init
       (oneof (x zero)(x one)(x two)(x three)(x four)(x five)(x six)(x seven)(x eight)(x nine)(x ten)(x eleven)(x twelve))
				(oneof (y zero)(y one)(y two)(y three)(y four)(y five)(y six)(y seven)(y eight)(y nine)(y ten)(y eleven)(y twelve))
				(or (not (x ten)) (not (y four))))




(:goal (or (x five) (y zero)) ))

