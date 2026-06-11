(define (problem or-push-new-7-2)
(:domain or-push-new)

 (:objects 
    p1-1
    p1-2
    p1-3
    p1-4
    p1-5
    p1-6
    p1-7
    p2-1
    p2-2
    p2-3
    p2-4
    p2-5
    p2-6
    p2-7
    p3-1
    p3-2
    p3-3
    p3-4
    p3-5
    p3-6
    p3-7
    p4-1
    p4-2
    p4-3
    p4-4
    p4-5
    p4-6
    p4-7
    p5-1
    p5-2
    p5-3
    p5-4
    p5-5
    p5-6
    p5-7
    p6-1
    p6-2
    p6-3
    p6-4
    p6-5
    p6-6
    p6-7
    p7-1
    p7-2
    p7-3
    p7-4
    p7-5
    p7-6
    p7-7

 - pos 
    )
   (:init
    
     (at p4-4)
     (pick-loc p1-1)     (pick-loc p7-7)     (adj p1-1 p2-1)
     (adj p2-1 p1-1)

     (adj p1-2 p2-2)
     (adj p2-2 p1-2)

     (adj p1-3 p2-3)
     (adj p2-3 p1-3)

     (adj p1-4 p2-4)
     (adj p2-4 p1-4)

     (adj p1-5 p2-5)
     (adj p2-5 p1-5)

     (adj p1-6 p2-6)
     (adj p2-6 p1-6)

     (adj p1-7 p2-7)
     (adj p2-7 p1-7)

     (adj p2-1 p3-1)
     (adj p3-1 p2-1)

     (adj p2-2 p3-2)
     (adj p3-2 p2-2)

     (adj p2-3 p3-3)
     (adj p3-3 p2-3)

     (adj p2-4 p3-4)
     (adj p3-4 p2-4)

     (adj p2-5 p3-5)
     (adj p3-5 p2-5)

     (adj p2-6 p3-6)
     (adj p3-6 p2-6)

     (adj p2-7 p3-7)
     (adj p3-7 p2-7)

     (adj p3-1 p4-1)
     (adj p4-1 p3-1)

     (adj p3-2 p4-2)
     (adj p4-2 p3-2)

     (adj p3-3 p4-3)
     (adj p4-3 p3-3)

     (adj p3-4 p4-4)
     (adj p4-4 p3-4)

     (adj p3-5 p4-5)
     (adj p4-5 p3-5)

     (adj p3-6 p4-6)
     (adj p4-6 p3-6)

     (adj p3-7 p4-7)
     (adj p4-7 p3-7)

     (adj p4-1 p5-1)
     (adj p5-1 p4-1)

     (adj p4-2 p5-2)
     (adj p5-2 p4-2)

     (adj p4-3 p5-3)
     (adj p5-3 p4-3)

     (adj p4-4 p5-4)
     (adj p5-4 p4-4)

     (adj p4-5 p5-5)
     (adj p5-5 p4-5)

     (adj p4-6 p5-6)
     (adj p5-6 p4-6)

     (adj p4-7 p5-7)
     (adj p5-7 p4-7)

     (adj p5-1 p6-1)
     (adj p6-1 p5-1)

     (adj p5-2 p6-2)
     (adj p6-2 p5-2)

     (adj p5-3 p6-3)
     (adj p6-3 p5-3)

     (adj p5-4 p6-4)
     (adj p6-4 p5-4)

     (adj p5-5 p6-5)
     (adj p6-5 p5-5)

     (adj p5-6 p6-6)
     (adj p6-6 p5-6)

     (adj p5-7 p6-7)
     (adj p6-7 p5-7)

     (adj p6-1 p7-1)
     (adj p7-1 p6-1)

     (adj p6-2 p7-2)
     (adj p7-2 p6-2)

     (adj p6-3 p7-3)
     (adj p7-3 p6-3)

     (adj p6-4 p7-4)
     (adj p7-4 p6-4)

     (adj p6-5 p7-5)
     (adj p7-5 p6-5)

     (adj p6-6 p7-6)
     (adj p7-6 p6-6)

     (adj p6-7 p7-7)
     (adj p7-7 p6-7)


     (adj p1-1 p1-2)
     (adj p1-2 p1-1)

     (adj p2-1 p2-2)
     (adj p2-2 p2-1)

     (adj p3-1 p3-2)
     (adj p3-2 p3-1)

     (adj p4-1 p4-2)
     (adj p4-2 p4-1)

     (adj p5-1 p5-2)
     (adj p5-2 p5-1)

     (adj p6-1 p6-2)
     (adj p6-2 p6-1)

     (adj p7-1 p7-2)
     (adj p7-2 p7-1)

     (adj p1-2 p1-3)
     (adj p1-3 p1-2)

     (adj p2-2 p2-3)
     (adj p2-3 p2-2)

     (adj p3-2 p3-3)
     (adj p3-3 p3-2)

     (adj p4-2 p4-3)
     (adj p4-3 p4-2)

     (adj p5-2 p5-3)
     (adj p5-3 p5-2)

     (adj p6-2 p6-3)
     (adj p6-3 p6-2)

     (adj p7-2 p7-3)
     (adj p7-3 p7-2)

     (adj p1-3 p1-4)
     (adj p1-4 p1-3)

     (adj p2-3 p2-4)
     (adj p2-4 p2-3)

     (adj p3-3 p3-4)
     (adj p3-4 p3-3)

     (adj p4-3 p4-4)
     (adj p4-4 p4-3)

     (adj p5-3 p5-4)
     (adj p5-4 p5-3)

     (adj p6-3 p6-4)
     (adj p6-4 p6-3)

     (adj p7-3 p7-4)
     (adj p7-4 p7-3)

     (adj p1-4 p1-5)
     (adj p1-5 p1-4)

     (adj p2-4 p2-5)
     (adj p2-5 p2-4)

     (adj p3-4 p3-5)
     (adj p3-5 p3-4)

     (adj p4-4 p4-5)
     (adj p4-5 p4-4)

     (adj p5-4 p5-5)
     (adj p5-5 p5-4)

     (adj p6-4 p6-5)
     (adj p6-5 p6-4)

     (adj p7-4 p7-5)
     (adj p7-5 p7-4)

     (adj p1-5 p1-6)
     (adj p1-6 p1-5)

     (adj p2-5 p2-6)
     (adj p2-6 p2-5)

     (adj p3-5 p3-6)
     (adj p3-6 p3-5)

     (adj p4-5 p4-6)
     (adj p4-6 p4-5)

     (adj p5-5 p5-6)
     (adj p5-6 p5-5)

     (adj p6-5 p6-6)
     (adj p6-6 p6-5)

     (adj p7-5 p7-6)
     (adj p7-6 p7-5)

     (adj p1-6 p1-7)
     (adj p1-7 p1-6)

     (adj p2-6 p2-7)
     (adj p2-7 p2-6)

     (adj p3-6 p3-7)
     (adj p3-7 p3-6)

     (adj p4-6 p4-7)
     (adj p4-7 p4-6)

     (adj p5-6 p5-7)
     (adj p5-7 p5-6)

     (adj p6-6 p6-7)
     (adj p6-7 p6-6)

     (adj p7-6 p7-7)
     (adj p7-7 p7-6)


        (ncleared p1-1)
        (ncleared p1-2)
        (ncleared p1-3)
        (ncleared p1-4)
        (ncleared p1-5)
        (ncleared p1-6)
        (ncleared p1-7)
        (ncleared p2-1)
        (ncleared p2-2)
        (ncleared p2-3)
        (ncleared p2-4)
        (ncleared p2-5)
        (ncleared p2-6)
        (ncleared p2-7)
        (ncleared p3-1)
        (ncleared p3-2)
        (ncleared p3-3)
        (ncleared p3-4)
        (ncleared p3-5)
        (ncleared p3-6)
        (ncleared p3-7)
        (ncleared p4-1)
        (ncleared p4-2)
        (ncleared p4-3)
        (ncleared p4-4)
        (ncleared p4-5)
        (ncleared p4-6)
        (ncleared p4-7)
        (ncleared p5-1)
        (ncleared p5-2)
        (ncleared p5-3)
        (ncleared p5-4)
        (ncleared p5-5)
        (ncleared p5-6)
        (ncleared p5-7)
        (ncleared p6-1)
        (ncleared p6-2)
        (ncleared p6-3)
        (ncleared p6-4)
        (ncleared p6-5)
        (ncleared p6-6)
        (ncleared p6-7)
        (ncleared p7-1)
        (ncleared p7-2)
        (ncleared p7-3)
        (ncleared p7-4)
        (ncleared p7-5)
        (ncleared p7-6)
        (ncleared p7-7)

     (or
        (obj-at o1 p1-1)
        (obj-at o1 p1-2)
        (obj-at o1 p1-3)
        (obj-at o1 p1-4)
        (obj-at o1 p1-5)
        (obj-at o1 p1-6)
        (obj-at o1 p1-7)
        (obj-at o1 p2-1)
        (obj-at o1 p2-2)
        (obj-at o1 p2-3)
        (obj-at o1 p2-4)
        (obj-at o1 p2-5)
        (obj-at o1 p2-6)
        (obj-at o1 p2-7)
        (obj-at o1 p3-1)
        (obj-at o1 p3-2)
        (obj-at o1 p3-3)
        (obj-at o1 p3-4)
        (obj-at o1 p3-5)
        (obj-at o1 p3-6)
        (obj-at o1 p3-7)
        (obj-at o1 p4-1)
        (obj-at o1 p4-2)
        (obj-at o1 p4-3)
        (obj-at o1 p4-4)
        (obj-at o1 p4-5)
        (obj-at o1 p4-6)
        (obj-at o1 p4-7)
        (obj-at o1 p5-1)
        (obj-at o1 p5-2)
        (obj-at o1 p5-3)
        (obj-at o1 p5-4)
        (obj-at o1 p5-5)
        (obj-at o1 p5-6)
        (obj-at o1 p5-7)
        (obj-at o1 p6-1)
        (obj-at o1 p6-2)
        (obj-at o1 p6-3)
        (obj-at o1 p6-4)
        (obj-at o1 p6-5)
        (obj-at o1 p6-6)
        (obj-at o1 p6-7)
        (obj-at o1 p7-1)
        (obj-at o1 p7-2)
        (obj-at o1 p7-3)
        (obj-at o1 p7-4)
        (obj-at o1 p7-5)
        (obj-at o1 p7-6)
        (obj-at o1 p7-7)
     )
     (or
        (obj-at o2 p1-1)
        (obj-at o2 p1-2)
        (obj-at o2 p1-3)
        (obj-at o2 p1-4)
        (obj-at o2 p1-5)
        (obj-at o2 p1-6)
        (obj-at o2 p1-7)
        (obj-at o2 p2-1)
        (obj-at o2 p2-2)
        (obj-at o2 p2-3)
        (obj-at o2 p2-4)
        (obj-at o2 p2-5)
        (obj-at o2 p2-6)
        (obj-at o2 p2-7)
        (obj-at o2 p3-1)
        (obj-at o2 p3-2)
        (obj-at o2 p3-3)
        (obj-at o2 p3-4)
        (obj-at o2 p3-5)
        (obj-at o2 p3-6)
        (obj-at o2 p3-7)
        (obj-at o2 p4-1)
        (obj-at o2 p4-2)
        (obj-at o2 p4-3)
        (obj-at o2 p4-4)
        (obj-at o2 p4-5)
        (obj-at o2 p4-6)
        (obj-at o2 p4-7)
        (obj-at o2 p5-1)
        (obj-at o2 p5-2)
        (obj-at o2 p5-3)
        (obj-at o2 p5-4)
        (obj-at o2 p5-5)
        (obj-at o2 p5-6)
        (obj-at o2 p5-7)
        (obj-at o2 p6-1)
        (obj-at o2 p6-2)
        (obj-at o2 p6-3)
        (obj-at o2 p6-4)
        (obj-at o2 p6-5)
        (obj-at o2 p6-6)
        (obj-at o2 p6-7)
        (obj-at o2 p7-1)
        (obj-at o2 p7-2)
        (obj-at o2 p7-3)
        (obj-at o2 p7-4)
        (obj-at o2 p7-5)
        (obj-at o2 p7-6)
        (obj-at o2 p7-7)
     )

    )
    
    (:goal (and     (holding o1)
    (holding o2)
)))
