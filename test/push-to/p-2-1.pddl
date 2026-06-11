(define (problem push-to-2-1)
(:domain push-to)

 (:objects  o1 - obj
    p1-1
    p1-2
    p2-1
    p2-2

 - pos 
    )
   (:init

     (at p1-1)
     (pick-loc p1-1)     (pick-loc p2-2)     (adj p1-1 p2-1)
     (adj p2-1 p1-1)

     (adj p1-2 p2-2)
     (adj p2-2 p1-2)


     (adj p1-1 p1-2)
     (adj p1-2 p1-1)

     (adj p2-1 p2-2)
     (adj p2-2 p2-1)


     (oneof
        (obj-at o1 p1-1)
        (obj-at o1 p1-2)
        (obj-at o1 p2-1)
        (obj-at o1 p2-2)
     )


    )
    (:goal (holding o1)))
