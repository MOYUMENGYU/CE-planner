;; Enrico Scala <enricos83@gmail.com> and Alban Grastien <Alban.Grastien@data61.csiro.au>
(define (problem instance_3__12345)
(:domain grid)

(:init
       (oneof (x zero)(x one)(x two))
       (oneof (y zero)(y one)(y two))
       (or (not (x two)) (not (y one))))



(:goal (or (x one) (y zero)) ))

