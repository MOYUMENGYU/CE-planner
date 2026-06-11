
(define (domain look-and-grab) 

   (:requirements :strips :typing)
   (:types pos obj)
   (:constants  o1 o2 - obj     p1-1
    p1-2
    p1-3
    p1-4
    p1-5
    p1-6
    p2-1
    p2-2
    p2-3
    p2-4
    p2-5
    p2-6
    p3-1
    p3-2
    p3-3
    p3-4
    p3-5
    p3-6
    p4-1
    p4-2
    p4-3
    p4-4
    p4-5
    p4-6
    p5-1
    p5-2
    p5-3
    p5-4
    p5-5
    p5-6
    p6-1
    p6-2
    p6-3
    p6-4
    p6-5
    p6-6
 - pos) 
   (:predicates (adj ?i - pos ?j - pos) (at ?i - pos) (holding ?o - obj) (obj-at ?o - obj ?i - pos) (handempty))
   (:action move
      :parameters (?i - pos ?j - pos )
      :precondition (and (adj ?i ?j) (at ?i))
      :effect (and (not (at ?i)) (at ?j)))

   (:action pickup-1-1-look-3
      :precondition (at p1-1) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p1-1)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p1-1)))
            
            ; X = 1
                ; Y = 1
          (when (and (handempty) (obj-at o1 p1-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-1))))
                                       
          (when (and (handempty) (obj-at o2 p1-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p1-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-2))))
                                       
          (when (and (handempty) (obj-at o2 p1-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p1-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-3))))
                                       
          (when (and (handempty) (obj-at o2 p1-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p1-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-4))))
                                       
          (when (and (handempty) (obj-at o2 p1-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-4))))
                                       
            ; X = 2
                ; Y = 1
          (when (and (handempty) (obj-at o1 p2-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-1))))
                                       
          (when (and (handempty) (obj-at o2 p2-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p2-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-2))))
                                       
          (when (and (handempty) (obj-at o2 p2-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p2-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-3))))
                                       
          (when (and (handempty) (obj-at o2 p2-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p2-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-4))))
                                       
          (when (and (handempty) (obj-at o2 p2-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-4))))
                                       
            ; X = 3
                ; Y = 1
          (when (and (handempty) (obj-at o1 p3-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-1))))
                                       
          (when (and (handempty) (obj-at o2 p3-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p3-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-2))))
                                       
          (when (and (handempty) (obj-at o2 p3-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
            ; X = 4
                ; Y = 1
          (when (and (handempty) (obj-at o1 p4-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-1))))
                                       
          (when (and (handempty) (obj-at o2 p4-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p4-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-2))))
                                       
          (when (and (handempty) (obj-at o2 p4-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       ))

   (:action pickup-1-2-look-3
      :precondition (at p1-2) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p1-2)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p1-2)))
            
            ; X = 1
                ; Y = 1
          (when (and (handempty) (obj-at o1 p1-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-1))))
                                       
          (when (and (handempty) (obj-at o2 p1-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p1-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-2))))
                                       
          (when (and (handempty) (obj-at o2 p1-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p1-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-3))))
                                       
          (when (and (handempty) (obj-at o2 p1-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p1-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-4))))
                                       
          (when (and (handempty) (obj-at o2 p1-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p1-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-5))))
                                       
          (when (and (handempty) (obj-at o2 p1-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-5))))
                                       
            ; X = 2
                ; Y = 1
          (when (and (handempty) (obj-at o1 p2-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-1))))
                                       
          (when (and (handempty) (obj-at o2 p2-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p2-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-2))))
                                       
          (when (and (handempty) (obj-at o2 p2-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p2-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-3))))
                                       
          (when (and (handempty) (obj-at o2 p2-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p2-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-4))))
                                       
          (when (and (handempty) (obj-at o2 p2-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p2-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-5))))
                                       
          (when (and (handempty) (obj-at o2 p2-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-5))))
                                       
            ; X = 3
                ; Y = 1
          (when (and (handempty) (obj-at o1 p3-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-1))))
                                       
          (when (and (handempty) (obj-at o2 p3-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p3-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-2))))
                                       
          (when (and (handempty) (obj-at o2 p3-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p3-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-5))))
                                       
          (when (and (handempty) (obj-at o2 p3-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-5))))
                                       
            ; X = 4
                ; Y = 1
          (when (and (handempty) (obj-at o1 p4-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-1))))
                                       
          (when (and (handempty) (obj-at o2 p4-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p4-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-2))))
                                       
          (when (and (handempty) (obj-at o2 p4-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p4-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-5))))
                                       
          (when (and (handempty) (obj-at o2 p4-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-5))))
                                       ))

   (:action pickup-1-3-look-3
      :precondition (at p1-3) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p1-3)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p1-3)))
            
            ; X = 1
                ; Y = 1
          (when (and (handempty) (obj-at o1 p1-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-1))))
                                       
          (when (and (handempty) (obj-at o2 p1-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p1-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-2))))
                                       
          (when (and (handempty) (obj-at o2 p1-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p1-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-3))))
                                       
          (when (and (handempty) (obj-at o2 p1-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p1-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-4))))
                                       
          (when (and (handempty) (obj-at o2 p1-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p1-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-5))))
                                       
          (when (and (handempty) (obj-at o2 p1-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p1-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-6))))
                                       
          (when (and (handempty) (obj-at o2 p1-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-6))))
                                       
            ; X = 2
                ; Y = 1
          (when (and (handempty) (obj-at o1 p2-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-1))))
                                       
          (when (and (handempty) (obj-at o2 p2-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p2-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-2))))
                                       
          (when (and (handempty) (obj-at o2 p2-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p2-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-3))))
                                       
          (when (and (handempty) (obj-at o2 p2-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p2-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-4))))
                                       
          (when (and (handempty) (obj-at o2 p2-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p2-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-5))))
                                       
          (when (and (handempty) (obj-at o2 p2-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p2-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-6))))
                                       
          (when (and (handempty) (obj-at o2 p2-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-6))))
                                       
            ; X = 3
                ; Y = 1
          (when (and (handempty) (obj-at o1 p3-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-1))))
                                       
          (when (and (handempty) (obj-at o2 p3-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p3-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-2))))
                                       
          (when (and (handempty) (obj-at o2 p3-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p3-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-5))))
                                       
          (when (and (handempty) (obj-at o2 p3-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p3-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-6))))
                                       
          (when (and (handempty) (obj-at o2 p3-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-6))))
                                       
            ; X = 4
                ; Y = 1
          (when (and (handempty) (obj-at o1 p4-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-1))))
                                       
          (when (and (handempty) (obj-at o2 p4-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p4-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-2))))
                                       
          (when (and (handempty) (obj-at o2 p4-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p4-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-5))))
                                       
          (when (and (handempty) (obj-at o2 p4-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p4-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-6))))
                                       
          (when (and (handempty) (obj-at o2 p4-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-6))))
                                       ))

   (:action pickup-1-4-look-3
      :precondition (at p1-4) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p1-4)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p1-4)))
            
            ; X = 1
                ; Y = 1
          (when (and (handempty) (obj-at o1 p1-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-1))))
                                       
          (when (and (handempty) (obj-at o2 p1-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p1-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-2))))
                                       
          (when (and (handempty) (obj-at o2 p1-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p1-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-3))))
                                       
          (when (and (handempty) (obj-at o2 p1-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p1-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-4))))
                                       
          (when (and (handempty) (obj-at o2 p1-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p1-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-5))))
                                       
          (when (and (handempty) (obj-at o2 p1-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p1-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-6))))
                                       
          (when (and (handempty) (obj-at o2 p1-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-6))))
                                       
            ; X = 2
                ; Y = 1
          (when (and (handempty) (obj-at o1 p2-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-1))))
                                       
          (when (and (handempty) (obj-at o2 p2-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p2-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-2))))
                                       
          (when (and (handempty) (obj-at o2 p2-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p2-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-3))))
                                       
          (when (and (handempty) (obj-at o2 p2-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p2-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-4))))
                                       
          (when (and (handempty) (obj-at o2 p2-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p2-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-5))))
                                       
          (when (and (handempty) (obj-at o2 p2-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p2-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-6))))
                                       
          (when (and (handempty) (obj-at o2 p2-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-6))))
                                       
            ; X = 3
                ; Y = 1
          (when (and (handempty) (obj-at o1 p3-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-1))))
                                       
          (when (and (handempty) (obj-at o2 p3-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p3-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-2))))
                                       
          (when (and (handempty) (obj-at o2 p3-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p3-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-5))))
                                       
          (when (and (handempty) (obj-at o2 p3-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p3-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-6))))
                                       
          (when (and (handempty) (obj-at o2 p3-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-6))))
                                       
            ; X = 4
                ; Y = 1
          (when (and (handempty) (obj-at o1 p4-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-1))))
                                       
          (when (and (handempty) (obj-at o2 p4-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p4-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-2))))
                                       
          (when (and (handempty) (obj-at o2 p4-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p4-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-5))))
                                       
          (when (and (handempty) (obj-at o2 p4-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p4-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-6))))
                                       
          (when (and (handempty) (obj-at o2 p4-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-6))))
                                       ))

   (:action pickup-1-5-look-3
      :precondition (at p1-5) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p1-5)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p1-5)))
            
            ; X = 1
                ; Y = 2
          (when (and (handempty) (obj-at o1 p1-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-2))))
                                       
          (when (and (handempty) (obj-at o2 p1-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p1-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-3))))
                                       
          (when (and (handempty) (obj-at o2 p1-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p1-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-4))))
                                       
          (when (and (handempty) (obj-at o2 p1-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p1-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-5))))
                                       
          (when (and (handempty) (obj-at o2 p1-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p1-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-6))))
                                       
          (when (and (handempty) (obj-at o2 p1-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-6))))
                                       
            ; X = 2
                ; Y = 2
          (when (and (handempty) (obj-at o1 p2-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-2))))
                                       
          (when (and (handempty) (obj-at o2 p2-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p2-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-3))))
                                       
          (when (and (handempty) (obj-at o2 p2-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p2-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-4))))
                                       
          (when (and (handempty) (obj-at o2 p2-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p2-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-5))))
                                       
          (when (and (handempty) (obj-at o2 p2-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p2-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-6))))
                                       
          (when (and (handempty) (obj-at o2 p2-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-6))))
                                       
            ; X = 3
                ; Y = 2
          (when (and (handempty) (obj-at o1 p3-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-2))))
                                       
          (when (and (handempty) (obj-at o2 p3-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p3-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-5))))
                                       
          (when (and (handempty) (obj-at o2 p3-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p3-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-6))))
                                       
          (when (and (handempty) (obj-at o2 p3-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-6))))
                                       
            ; X = 4
                ; Y = 2
          (when (and (handempty) (obj-at o1 p4-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-2))))
                                       
          (when (and (handempty) (obj-at o2 p4-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p4-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-5))))
                                       
          (when (and (handempty) (obj-at o2 p4-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p4-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-6))))
                                       
          (when (and (handempty) (obj-at o2 p4-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-6))))
                                       ))

   (:action pickup-1-6-look-3
      :precondition (at p1-6) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p1-6)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p1-6)))
            
            ; X = 1
                ; Y = 3
          (when (and (handempty) (obj-at o1 p1-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-3))))
                                       
          (when (and (handempty) (obj-at o2 p1-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p1-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-4))))
                                       
          (when (and (handempty) (obj-at o2 p1-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p1-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-5))))
                                       
          (when (and (handempty) (obj-at o2 p1-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p1-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-6))))
                                       
          (when (and (handempty) (obj-at o2 p1-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-6))))
                                       
            ; X = 2
                ; Y = 3
          (when (and (handempty) (obj-at o1 p2-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-3))))
                                       
          (when (and (handempty) (obj-at o2 p2-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p2-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-4))))
                                       
          (when (and (handempty) (obj-at o2 p2-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p2-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-5))))
                                       
          (when (and (handempty) (obj-at o2 p2-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p2-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-6))))
                                       
          (when (and (handempty) (obj-at o2 p2-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-6))))
                                       
            ; X = 3
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p3-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-5))))
                                       
          (when (and (handempty) (obj-at o2 p3-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p3-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-6))))
                                       
          (when (and (handempty) (obj-at o2 p3-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-6))))
                                       
            ; X = 4
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p4-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-5))))
                                       
          (when (and (handempty) (obj-at o2 p4-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p4-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-6))))
                                       
          (when (and (handempty) (obj-at o2 p4-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-6))))
                                       ))

   (:action pickup-2-1-look-3
      :precondition (at p2-1) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p2-1)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p2-1)))
            
            ; X = 1
                ; Y = 1
          (when (and (handempty) (obj-at o1 p1-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-1))))
                                       
          (when (and (handempty) (obj-at o2 p1-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p1-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-2))))
                                       
          (when (and (handempty) (obj-at o2 p1-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p1-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-3))))
                                       
          (when (and (handempty) (obj-at o2 p1-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p1-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-4))))
                                       
          (when (and (handempty) (obj-at o2 p1-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-4))))
                                       
            ; X = 2
                ; Y = 1
          (when (and (handempty) (obj-at o1 p2-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-1))))
                                       
          (when (and (handempty) (obj-at o2 p2-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p2-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-2))))
                                       
          (when (and (handempty) (obj-at o2 p2-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p2-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-3))))
                                       
          (when (and (handempty) (obj-at o2 p2-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p2-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-4))))
                                       
          (when (and (handempty) (obj-at o2 p2-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-4))))
                                       
            ; X = 3
                ; Y = 1
          (when (and (handempty) (obj-at o1 p3-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-1))))
                                       
          (when (and (handempty) (obj-at o2 p3-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p3-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-2))))
                                       
          (when (and (handempty) (obj-at o2 p3-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
            ; X = 4
                ; Y = 1
          (when (and (handempty) (obj-at o1 p4-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-1))))
                                       
          (when (and (handempty) (obj-at o2 p4-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p4-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-2))))
                                       
          (when (and (handempty) (obj-at o2 p4-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       
            ; X = 5
                ; Y = 1
          (when (and (handempty) (obj-at o1 p5-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-1))))
                                       
          (when (and (handempty) (obj-at o2 p5-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p5-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-2))))
                                       
          (when (and (handempty) (obj-at o2 p5-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p5-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-3))))
                                       
          (when (and (handempty) (obj-at o2 p5-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p5-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-4))))
                                       
          (when (and (handempty) (obj-at o2 p5-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-4))))
                                       ))

   (:action pickup-2-2-look-3
      :precondition (at p2-2) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p2-2)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p2-2)))
            
            ; X = 1
                ; Y = 1
          (when (and (handempty) (obj-at o1 p1-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-1))))
                                       
          (when (and (handempty) (obj-at o2 p1-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p1-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-2))))
                                       
          (when (and (handempty) (obj-at o2 p1-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p1-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-3))))
                                       
          (when (and (handempty) (obj-at o2 p1-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p1-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-4))))
                                       
          (when (and (handempty) (obj-at o2 p1-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p1-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-5))))
                                       
          (when (and (handempty) (obj-at o2 p1-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-5))))
                                       
            ; X = 2
                ; Y = 1
          (when (and (handempty) (obj-at o1 p2-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-1))))
                                       
          (when (and (handempty) (obj-at o2 p2-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p2-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-2))))
                                       
          (when (and (handempty) (obj-at o2 p2-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p2-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-3))))
                                       
          (when (and (handempty) (obj-at o2 p2-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p2-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-4))))
                                       
          (when (and (handempty) (obj-at o2 p2-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p2-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-5))))
                                       
          (when (and (handempty) (obj-at o2 p2-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-5))))
                                       
            ; X = 3
                ; Y = 1
          (when (and (handempty) (obj-at o1 p3-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-1))))
                                       
          (when (and (handempty) (obj-at o2 p3-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p3-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-2))))
                                       
          (when (and (handempty) (obj-at o2 p3-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p3-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-5))))
                                       
          (when (and (handempty) (obj-at o2 p3-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-5))))
                                       
            ; X = 4
                ; Y = 1
          (when (and (handempty) (obj-at o1 p4-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-1))))
                                       
          (when (and (handempty) (obj-at o2 p4-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p4-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-2))))
                                       
          (when (and (handempty) (obj-at o2 p4-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p4-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-5))))
                                       
          (when (and (handempty) (obj-at o2 p4-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-5))))
                                       
            ; X = 5
                ; Y = 1
          (when (and (handempty) (obj-at o1 p5-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-1))))
                                       
          (when (and (handempty) (obj-at o2 p5-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p5-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-2))))
                                       
          (when (and (handempty) (obj-at o2 p5-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p5-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-3))))
                                       
          (when (and (handempty) (obj-at o2 p5-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p5-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-4))))
                                       
          (when (and (handempty) (obj-at o2 p5-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p5-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-5))))
                                       
          (when (and (handempty) (obj-at o2 p5-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-5))))
                                       ))

   (:action pickup-2-3-look-3
      :precondition (at p2-3) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p2-3)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p2-3)))
            
            ; X = 1
                ; Y = 1
          (when (and (handempty) (obj-at o1 p1-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-1))))
                                       
          (when (and (handempty) (obj-at o2 p1-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p1-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-2))))
                                       
          (when (and (handempty) (obj-at o2 p1-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p1-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-3))))
                                       
          (when (and (handempty) (obj-at o2 p1-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p1-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-4))))
                                       
          (when (and (handempty) (obj-at o2 p1-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p1-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-5))))
                                       
          (when (and (handempty) (obj-at o2 p1-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p1-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-6))))
                                       
          (when (and (handempty) (obj-at o2 p1-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-6))))
                                       
            ; X = 2
                ; Y = 1
          (when (and (handempty) (obj-at o1 p2-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-1))))
                                       
          (when (and (handempty) (obj-at o2 p2-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p2-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-2))))
                                       
          (when (and (handempty) (obj-at o2 p2-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p2-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-3))))
                                       
          (when (and (handempty) (obj-at o2 p2-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p2-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-4))))
                                       
          (when (and (handempty) (obj-at o2 p2-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p2-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-5))))
                                       
          (when (and (handempty) (obj-at o2 p2-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p2-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-6))))
                                       
          (when (and (handempty) (obj-at o2 p2-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-6))))
                                       
            ; X = 3
                ; Y = 1
          (when (and (handempty) (obj-at o1 p3-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-1))))
                                       
          (when (and (handempty) (obj-at o2 p3-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p3-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-2))))
                                       
          (when (and (handempty) (obj-at o2 p3-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p3-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-5))))
                                       
          (when (and (handempty) (obj-at o2 p3-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p3-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-6))))
                                       
          (when (and (handempty) (obj-at o2 p3-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-6))))
                                       
            ; X = 4
                ; Y = 1
          (when (and (handempty) (obj-at o1 p4-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-1))))
                                       
          (when (and (handempty) (obj-at o2 p4-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p4-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-2))))
                                       
          (when (and (handempty) (obj-at o2 p4-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p4-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-5))))
                                       
          (when (and (handempty) (obj-at o2 p4-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p4-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-6))))
                                       
          (when (and (handempty) (obj-at o2 p4-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-6))))
                                       
            ; X = 5
                ; Y = 1
          (when (and (handempty) (obj-at o1 p5-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-1))))
                                       
          (when (and (handempty) (obj-at o2 p5-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p5-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-2))))
                                       
          (when (and (handempty) (obj-at o2 p5-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p5-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-3))))
                                       
          (when (and (handempty) (obj-at o2 p5-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p5-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-4))))
                                       
          (when (and (handempty) (obj-at o2 p5-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p5-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-5))))
                                       
          (when (and (handempty) (obj-at o2 p5-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p5-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-6))))
                                       
          (when (and (handempty) (obj-at o2 p5-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-6))))
                                       ))

   (:action pickup-2-4-look-3
      :precondition (at p2-4) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p2-4)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p2-4)))
            
            ; X = 1
                ; Y = 1
          (when (and (handempty) (obj-at o1 p1-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-1))))
                                       
          (when (and (handempty) (obj-at o2 p1-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p1-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-2))))
                                       
          (when (and (handempty) (obj-at o2 p1-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p1-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-3))))
                                       
          (when (and (handempty) (obj-at o2 p1-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p1-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-4))))
                                       
          (when (and (handempty) (obj-at o2 p1-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p1-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-5))))
                                       
          (when (and (handempty) (obj-at o2 p1-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p1-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-6))))
                                       
          (when (and (handempty) (obj-at o2 p1-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-6))))
                                       
            ; X = 2
                ; Y = 1
          (when (and (handempty) (obj-at o1 p2-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-1))))
                                       
          (when (and (handempty) (obj-at o2 p2-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p2-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-2))))
                                       
          (when (and (handempty) (obj-at o2 p2-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p2-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-3))))
                                       
          (when (and (handempty) (obj-at o2 p2-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p2-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-4))))
                                       
          (when (and (handempty) (obj-at o2 p2-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p2-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-5))))
                                       
          (when (and (handempty) (obj-at o2 p2-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p2-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-6))))
                                       
          (when (and (handempty) (obj-at o2 p2-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-6))))
                                       
            ; X = 3
                ; Y = 1
          (when (and (handempty) (obj-at o1 p3-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-1))))
                                       
          (when (and (handempty) (obj-at o2 p3-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p3-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-2))))
                                       
          (when (and (handempty) (obj-at o2 p3-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p3-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-5))))
                                       
          (when (and (handempty) (obj-at o2 p3-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p3-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-6))))
                                       
          (when (and (handempty) (obj-at o2 p3-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-6))))
                                       
            ; X = 4
                ; Y = 1
          (when (and (handempty) (obj-at o1 p4-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-1))))
                                       
          (when (and (handempty) (obj-at o2 p4-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p4-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-2))))
                                       
          (when (and (handempty) (obj-at o2 p4-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p4-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-5))))
                                       
          (when (and (handempty) (obj-at o2 p4-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p4-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-6))))
                                       
          (when (and (handempty) (obj-at o2 p4-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-6))))
                                       
            ; X = 5
                ; Y = 1
          (when (and (handempty) (obj-at o1 p5-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-1))))
                                       
          (when (and (handempty) (obj-at o2 p5-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p5-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-2))))
                                       
          (when (and (handempty) (obj-at o2 p5-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p5-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-3))))
                                       
          (when (and (handempty) (obj-at o2 p5-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p5-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-4))))
                                       
          (when (and (handempty) (obj-at o2 p5-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p5-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-5))))
                                       
          (when (and (handempty) (obj-at o2 p5-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p5-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-6))))
                                       
          (when (and (handempty) (obj-at o2 p5-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-6))))
                                       ))

   (:action pickup-2-5-look-3
      :precondition (at p2-5) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p2-5)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p2-5)))
            
            ; X = 1
                ; Y = 2
          (when (and (handempty) (obj-at o1 p1-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-2))))
                                       
          (when (and (handempty) (obj-at o2 p1-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p1-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-3))))
                                       
          (when (and (handempty) (obj-at o2 p1-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p1-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-4))))
                                       
          (when (and (handempty) (obj-at o2 p1-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p1-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-5))))
                                       
          (when (and (handempty) (obj-at o2 p1-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p1-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-6))))
                                       
          (when (and (handempty) (obj-at o2 p1-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-6))))
                                       
            ; X = 2
                ; Y = 2
          (when (and (handempty) (obj-at o1 p2-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-2))))
                                       
          (when (and (handempty) (obj-at o2 p2-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p2-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-3))))
                                       
          (when (and (handempty) (obj-at o2 p2-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p2-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-4))))
                                       
          (when (and (handempty) (obj-at o2 p2-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p2-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-5))))
                                       
          (when (and (handempty) (obj-at o2 p2-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p2-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-6))))
                                       
          (when (and (handempty) (obj-at o2 p2-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-6))))
                                       
            ; X = 3
                ; Y = 2
          (when (and (handempty) (obj-at o1 p3-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-2))))
                                       
          (when (and (handempty) (obj-at o2 p3-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p3-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-5))))
                                       
          (when (and (handempty) (obj-at o2 p3-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p3-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-6))))
                                       
          (when (and (handempty) (obj-at o2 p3-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-6))))
                                       
            ; X = 4
                ; Y = 2
          (when (and (handempty) (obj-at o1 p4-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-2))))
                                       
          (when (and (handempty) (obj-at o2 p4-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p4-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-5))))
                                       
          (when (and (handempty) (obj-at o2 p4-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p4-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-6))))
                                       
          (when (and (handempty) (obj-at o2 p4-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-6))))
                                       
            ; X = 5
                ; Y = 2
          (when (and (handempty) (obj-at o1 p5-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-2))))
                                       
          (when (and (handempty) (obj-at o2 p5-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p5-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-3))))
                                       
          (when (and (handempty) (obj-at o2 p5-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p5-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-4))))
                                       
          (when (and (handempty) (obj-at o2 p5-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p5-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-5))))
                                       
          (when (and (handempty) (obj-at o2 p5-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p5-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-6))))
                                       
          (when (and (handempty) (obj-at o2 p5-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-6))))
                                       ))

   (:action pickup-2-6-look-3
      :precondition (at p2-6) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p2-6)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p2-6)))
            
            ; X = 1
                ; Y = 3
          (when (and (handempty) (obj-at o1 p1-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-3))))
                                       
          (when (and (handempty) (obj-at o2 p1-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p1-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-4))))
                                       
          (when (and (handempty) (obj-at o2 p1-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p1-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-5))))
                                       
          (when (and (handempty) (obj-at o2 p1-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p1-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-6))))
                                       
          (when (and (handempty) (obj-at o2 p1-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-6))))
                                       
            ; X = 2
                ; Y = 3
          (when (and (handempty) (obj-at o1 p2-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-3))))
                                       
          (when (and (handempty) (obj-at o2 p2-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p2-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-4))))
                                       
          (when (and (handempty) (obj-at o2 p2-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p2-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-5))))
                                       
          (when (and (handempty) (obj-at o2 p2-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p2-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-6))))
                                       
          (when (and (handempty) (obj-at o2 p2-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-6))))
                                       
            ; X = 3
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p3-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-5))))
                                       
          (when (and (handempty) (obj-at o2 p3-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p3-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-6))))
                                       
          (when (and (handempty) (obj-at o2 p3-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-6))))
                                       
            ; X = 4
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p4-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-5))))
                                       
          (when (and (handempty) (obj-at o2 p4-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p4-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-6))))
                                       
          (when (and (handempty) (obj-at o2 p4-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-6))))
                                       
            ; X = 5
                ; Y = 3
          (when (and (handempty) (obj-at o1 p5-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-3))))
                                       
          (when (and (handempty) (obj-at o2 p5-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p5-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-4))))
                                       
          (when (and (handempty) (obj-at o2 p5-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p5-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-5))))
                                       
          (when (and (handempty) (obj-at o2 p5-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p5-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-6))))
                                       
          (when (and (handempty) (obj-at o2 p5-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-6))))
                                       ))

   (:action pickup-3-1-look-3
      :precondition (at p3-1) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p3-1)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p3-1)))
            
            ; X = 1
                ; Y = 1
          (when (and (handempty) (obj-at o1 p1-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-1))))
                                       
          (when (and (handempty) (obj-at o2 p1-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p1-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-2))))
                                       
          (when (and (handempty) (obj-at o2 p1-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p1-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-3))))
                                       
          (when (and (handempty) (obj-at o2 p1-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p1-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-4))))
                                       
          (when (and (handempty) (obj-at o2 p1-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-4))))
                                       
            ; X = 2
                ; Y = 1
          (when (and (handempty) (obj-at o1 p2-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-1))))
                                       
          (when (and (handempty) (obj-at o2 p2-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p2-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-2))))
                                       
          (when (and (handempty) (obj-at o2 p2-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p2-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-3))))
                                       
          (when (and (handempty) (obj-at o2 p2-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p2-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-4))))
                                       
          (when (and (handempty) (obj-at o2 p2-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-4))))
                                       
            ; X = 3
                ; Y = 1
          (when (and (handempty) (obj-at o1 p3-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-1))))
                                       
          (when (and (handempty) (obj-at o2 p3-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p3-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-2))))
                                       
          (when (and (handempty) (obj-at o2 p3-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
            ; X = 4
                ; Y = 1
          (when (and (handempty) (obj-at o1 p4-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-1))))
                                       
          (when (and (handempty) (obj-at o2 p4-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p4-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-2))))
                                       
          (when (and (handempty) (obj-at o2 p4-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       
            ; X = 5
                ; Y = 1
          (when (and (handempty) (obj-at o1 p5-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-1))))
                                       
          (when (and (handempty) (obj-at o2 p5-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p5-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-2))))
                                       
          (when (and (handempty) (obj-at o2 p5-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p5-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-3))))
                                       
          (when (and (handempty) (obj-at o2 p5-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p5-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-4))))
                                       
          (when (and (handempty) (obj-at o2 p5-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-4))))
                                       
            ; X = 6
                ; Y = 1
          (when (and (handempty) (obj-at o1 p6-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-1))))
                                       
          (when (and (handempty) (obj-at o2 p6-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p6-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-2))))
                                       
          (when (and (handempty) (obj-at o2 p6-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p6-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-3))))
                                       
          (when (and (handempty) (obj-at o2 p6-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p6-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-4))))
                                       
          (when (and (handempty) (obj-at o2 p6-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-4))))
                                       ))

   (:action pickup-3-2-look-3
      :precondition (at p3-2) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p3-2)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p3-2)))
            
            ; X = 1
                ; Y = 1
          (when (and (handempty) (obj-at o1 p1-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-1))))
                                       
          (when (and (handempty) (obj-at o2 p1-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p1-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-2))))
                                       
          (when (and (handempty) (obj-at o2 p1-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p1-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-3))))
                                       
          (when (and (handempty) (obj-at o2 p1-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p1-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-4))))
                                       
          (when (and (handempty) (obj-at o2 p1-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p1-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-5))))
                                       
          (when (and (handempty) (obj-at o2 p1-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-5))))
                                       
            ; X = 2
                ; Y = 1
          (when (and (handempty) (obj-at o1 p2-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-1))))
                                       
          (when (and (handempty) (obj-at o2 p2-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p2-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-2))))
                                       
          (when (and (handempty) (obj-at o2 p2-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p2-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-3))))
                                       
          (when (and (handempty) (obj-at o2 p2-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p2-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-4))))
                                       
          (when (and (handempty) (obj-at o2 p2-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p2-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-5))))
                                       
          (when (and (handempty) (obj-at o2 p2-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-5))))
                                       
            ; X = 3
                ; Y = 1
          (when (and (handempty) (obj-at o1 p3-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-1))))
                                       
          (when (and (handempty) (obj-at o2 p3-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p3-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-2))))
                                       
          (when (and (handempty) (obj-at o2 p3-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p3-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-5))))
                                       
          (when (and (handempty) (obj-at o2 p3-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-5))))
                                       
            ; X = 4
                ; Y = 1
          (when (and (handempty) (obj-at o1 p4-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-1))))
                                       
          (when (and (handempty) (obj-at o2 p4-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p4-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-2))))
                                       
          (when (and (handempty) (obj-at o2 p4-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p4-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-5))))
                                       
          (when (and (handempty) (obj-at o2 p4-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-5))))
                                       
            ; X = 5
                ; Y = 1
          (when (and (handempty) (obj-at o1 p5-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-1))))
                                       
          (when (and (handempty) (obj-at o2 p5-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p5-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-2))))
                                       
          (when (and (handempty) (obj-at o2 p5-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p5-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-3))))
                                       
          (when (and (handempty) (obj-at o2 p5-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p5-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-4))))
                                       
          (when (and (handempty) (obj-at o2 p5-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p5-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-5))))
                                       
          (when (and (handempty) (obj-at o2 p5-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-5))))
                                       
            ; X = 6
                ; Y = 1
          (when (and (handempty) (obj-at o1 p6-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-1))))
                                       
          (when (and (handempty) (obj-at o2 p6-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p6-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-2))))
                                       
          (when (and (handempty) (obj-at o2 p6-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p6-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-3))))
                                       
          (when (and (handempty) (obj-at o2 p6-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p6-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-4))))
                                       
          (when (and (handempty) (obj-at o2 p6-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p6-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-5))))
                                       
          (when (and (handempty) (obj-at o2 p6-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-5))))
                                       ))

   (:action pickup-3-3-look-3
      :precondition (at p3-3) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p3-3)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p3-3)))
            
            ; X = 1
                ; Y = 1
          (when (and (handempty) (obj-at o1 p1-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-1))))
                                       
          (when (and (handempty) (obj-at o2 p1-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p1-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-2))))
                                       
          (when (and (handempty) (obj-at o2 p1-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p1-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-3))))
                                       
          (when (and (handempty) (obj-at o2 p1-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p1-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-4))))
                                       
          (when (and (handempty) (obj-at o2 p1-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p1-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-5))))
                                       
          (when (and (handempty) (obj-at o2 p1-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p1-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-6))))
                                       
          (when (and (handempty) (obj-at o2 p1-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-6))))
                                       
            ; X = 2
                ; Y = 1
          (when (and (handempty) (obj-at o1 p2-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-1))))
                                       
          (when (and (handempty) (obj-at o2 p2-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p2-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-2))))
                                       
          (when (and (handempty) (obj-at o2 p2-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p2-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-3))))
                                       
          (when (and (handempty) (obj-at o2 p2-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p2-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-4))))
                                       
          (when (and (handempty) (obj-at o2 p2-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p2-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-5))))
                                       
          (when (and (handempty) (obj-at o2 p2-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p2-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-6))))
                                       
          (when (and (handempty) (obj-at o2 p2-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-6))))
                                       
            ; X = 3
                ; Y = 1
          (when (and (handempty) (obj-at o1 p3-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-1))))
                                       
          (when (and (handempty) (obj-at o2 p3-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p3-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-2))))
                                       
          (when (and (handempty) (obj-at o2 p3-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p3-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-5))))
                                       
          (when (and (handempty) (obj-at o2 p3-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p3-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-6))))
                                       
          (when (and (handempty) (obj-at o2 p3-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-6))))
                                       
            ; X = 4
                ; Y = 1
          (when (and (handempty) (obj-at o1 p4-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-1))))
                                       
          (when (and (handempty) (obj-at o2 p4-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p4-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-2))))
                                       
          (when (and (handempty) (obj-at o2 p4-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p4-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-5))))
                                       
          (when (and (handempty) (obj-at o2 p4-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p4-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-6))))
                                       
          (when (and (handempty) (obj-at o2 p4-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-6))))
                                       
            ; X = 5
                ; Y = 1
          (when (and (handempty) (obj-at o1 p5-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-1))))
                                       
          (when (and (handempty) (obj-at o2 p5-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p5-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-2))))
                                       
          (when (and (handempty) (obj-at o2 p5-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p5-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-3))))
                                       
          (when (and (handempty) (obj-at o2 p5-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p5-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-4))))
                                       
          (when (and (handempty) (obj-at o2 p5-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p5-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-5))))
                                       
          (when (and (handempty) (obj-at o2 p5-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p5-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-6))))
                                       
          (when (and (handempty) (obj-at o2 p5-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-6))))
                                       
            ; X = 6
                ; Y = 1
          (when (and (handempty) (obj-at o1 p6-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-1))))
                                       
          (when (and (handempty) (obj-at o2 p6-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p6-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-2))))
                                       
          (when (and (handempty) (obj-at o2 p6-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p6-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-3))))
                                       
          (when (and (handempty) (obj-at o2 p6-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p6-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-4))))
                                       
          (when (and (handempty) (obj-at o2 p6-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p6-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-5))))
                                       
          (when (and (handempty) (obj-at o2 p6-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p6-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-6))))
                                       
          (when (and (handempty) (obj-at o2 p6-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-6))))
                                       ))

   (:action pickup-3-4-look-3
      :precondition (at p3-4) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p3-4)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p3-4)))
            
            ; X = 1
                ; Y = 1
          (when (and (handempty) (obj-at o1 p1-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-1))))
                                       
          (when (and (handempty) (obj-at o2 p1-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p1-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-2))))
                                       
          (when (and (handempty) (obj-at o2 p1-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p1-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-3))))
                                       
          (when (and (handempty) (obj-at o2 p1-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p1-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-4))))
                                       
          (when (and (handempty) (obj-at o2 p1-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p1-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-5))))
                                       
          (when (and (handempty) (obj-at o2 p1-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p1-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-6))))
                                       
          (when (and (handempty) (obj-at o2 p1-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-6))))
                                       
            ; X = 2
                ; Y = 1
          (when (and (handempty) (obj-at o1 p2-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-1))))
                                       
          (when (and (handempty) (obj-at o2 p2-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p2-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-2))))
                                       
          (when (and (handempty) (obj-at o2 p2-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p2-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-3))))
                                       
          (when (and (handempty) (obj-at o2 p2-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p2-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-4))))
                                       
          (when (and (handempty) (obj-at o2 p2-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p2-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-5))))
                                       
          (when (and (handempty) (obj-at o2 p2-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p2-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-6))))
                                       
          (when (and (handempty) (obj-at o2 p2-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-6))))
                                       
            ; X = 3
                ; Y = 1
          (when (and (handempty) (obj-at o1 p3-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-1))))
                                       
          (when (and (handempty) (obj-at o2 p3-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p3-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-2))))
                                       
          (when (and (handempty) (obj-at o2 p3-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p3-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-5))))
                                       
          (when (and (handempty) (obj-at o2 p3-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p3-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-6))))
                                       
          (when (and (handempty) (obj-at o2 p3-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-6))))
                                       
            ; X = 4
                ; Y = 1
          (when (and (handempty) (obj-at o1 p4-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-1))))
                                       
          (when (and (handempty) (obj-at o2 p4-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p4-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-2))))
                                       
          (when (and (handempty) (obj-at o2 p4-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p4-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-5))))
                                       
          (when (and (handempty) (obj-at o2 p4-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p4-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-6))))
                                       
          (when (and (handempty) (obj-at o2 p4-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-6))))
                                       
            ; X = 5
                ; Y = 1
          (when (and (handempty) (obj-at o1 p5-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-1))))
                                       
          (when (and (handempty) (obj-at o2 p5-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p5-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-2))))
                                       
          (when (and (handempty) (obj-at o2 p5-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p5-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-3))))
                                       
          (when (and (handempty) (obj-at o2 p5-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p5-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-4))))
                                       
          (when (and (handempty) (obj-at o2 p5-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p5-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-5))))
                                       
          (when (and (handempty) (obj-at o2 p5-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p5-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-6))))
                                       
          (when (and (handempty) (obj-at o2 p5-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-6))))
                                       
            ; X = 6
                ; Y = 1
          (when (and (handempty) (obj-at o1 p6-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-1))))
                                       
          (when (and (handempty) (obj-at o2 p6-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p6-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-2))))
                                       
          (when (and (handempty) (obj-at o2 p6-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p6-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-3))))
                                       
          (when (and (handempty) (obj-at o2 p6-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p6-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-4))))
                                       
          (when (and (handempty) (obj-at o2 p6-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p6-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-5))))
                                       
          (when (and (handempty) (obj-at o2 p6-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p6-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-6))))
                                       
          (when (and (handempty) (obj-at o2 p6-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-6))))
                                       ))

   (:action pickup-3-5-look-3
      :precondition (at p3-5) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p3-5)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p3-5)))
            
            ; X = 1
                ; Y = 2
          (when (and (handempty) (obj-at o1 p1-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-2))))
                                       
          (when (and (handempty) (obj-at o2 p1-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p1-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-3))))
                                       
          (when (and (handempty) (obj-at o2 p1-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p1-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-4))))
                                       
          (when (and (handempty) (obj-at o2 p1-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p1-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-5))))
                                       
          (when (and (handempty) (obj-at o2 p1-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p1-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-6))))
                                       
          (when (and (handempty) (obj-at o2 p1-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-6))))
                                       
            ; X = 2
                ; Y = 2
          (when (and (handempty) (obj-at o1 p2-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-2))))
                                       
          (when (and (handempty) (obj-at o2 p2-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p2-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-3))))
                                       
          (when (and (handempty) (obj-at o2 p2-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p2-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-4))))
                                       
          (when (and (handempty) (obj-at o2 p2-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p2-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-5))))
                                       
          (when (and (handempty) (obj-at o2 p2-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p2-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-6))))
                                       
          (when (and (handempty) (obj-at o2 p2-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-6))))
                                       
            ; X = 3
                ; Y = 2
          (when (and (handempty) (obj-at o1 p3-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-2))))
                                       
          (when (and (handempty) (obj-at o2 p3-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p3-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-5))))
                                       
          (when (and (handempty) (obj-at o2 p3-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p3-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-6))))
                                       
          (when (and (handempty) (obj-at o2 p3-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-6))))
                                       
            ; X = 4
                ; Y = 2
          (when (and (handempty) (obj-at o1 p4-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-2))))
                                       
          (when (and (handempty) (obj-at o2 p4-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p4-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-5))))
                                       
          (when (and (handempty) (obj-at o2 p4-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p4-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-6))))
                                       
          (when (and (handempty) (obj-at o2 p4-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-6))))
                                       
            ; X = 5
                ; Y = 2
          (when (and (handempty) (obj-at o1 p5-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-2))))
                                       
          (when (and (handempty) (obj-at o2 p5-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p5-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-3))))
                                       
          (when (and (handempty) (obj-at o2 p5-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p5-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-4))))
                                       
          (when (and (handempty) (obj-at o2 p5-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p5-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-5))))
                                       
          (when (and (handempty) (obj-at o2 p5-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p5-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-6))))
                                       
          (when (and (handempty) (obj-at o2 p5-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-6))))
                                       
            ; X = 6
                ; Y = 2
          (when (and (handempty) (obj-at o1 p6-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-2))))
                                       
          (when (and (handempty) (obj-at o2 p6-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p6-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-3))))
                                       
          (when (and (handempty) (obj-at o2 p6-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p6-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-4))))
                                       
          (when (and (handempty) (obj-at o2 p6-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p6-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-5))))
                                       
          (when (and (handempty) (obj-at o2 p6-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p6-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-6))))
                                       
          (when (and (handempty) (obj-at o2 p6-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-6))))
                                       ))

   (:action pickup-3-6-look-3
      :precondition (at p3-6) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p3-6)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p3-6)))
            
            ; X = 1
                ; Y = 3
          (when (and (handempty) (obj-at o1 p1-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-3))))
                                       
          (when (and (handempty) (obj-at o2 p1-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p1-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-4))))
                                       
          (when (and (handempty) (obj-at o2 p1-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p1-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-5))))
                                       
          (when (and (handempty) (obj-at o2 p1-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p1-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-6))))
                                       
          (when (and (handempty) (obj-at o2 p1-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-6))))
                                       
            ; X = 2
                ; Y = 3
          (when (and (handempty) (obj-at o1 p2-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-3))))
                                       
          (when (and (handempty) (obj-at o2 p2-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p2-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-4))))
                                       
          (when (and (handempty) (obj-at o2 p2-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p2-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-5))))
                                       
          (when (and (handempty) (obj-at o2 p2-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p2-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-6))))
                                       
          (when (and (handempty) (obj-at o2 p2-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-6))))
                                       
            ; X = 3
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p3-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-5))))
                                       
          (when (and (handempty) (obj-at o2 p3-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p3-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-6))))
                                       
          (when (and (handempty) (obj-at o2 p3-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-6))))
                                       
            ; X = 4
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p4-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-5))))
                                       
          (when (and (handempty) (obj-at o2 p4-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p4-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-6))))
                                       
          (when (and (handempty) (obj-at o2 p4-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-6))))
                                       
            ; X = 5
                ; Y = 3
          (when (and (handempty) (obj-at o1 p5-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-3))))
                                       
          (when (and (handempty) (obj-at o2 p5-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p5-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-4))))
                                       
          (when (and (handempty) (obj-at o2 p5-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p5-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-5))))
                                       
          (when (and (handempty) (obj-at o2 p5-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p5-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-6))))
                                       
          (when (and (handempty) (obj-at o2 p5-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-6))))
                                       
            ; X = 6
                ; Y = 3
          (when (and (handempty) (obj-at o1 p6-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-3))))
                                       
          (when (and (handempty) (obj-at o2 p6-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p6-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-4))))
                                       
          (when (and (handempty) (obj-at o2 p6-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p6-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-5))))
                                       
          (when (and (handempty) (obj-at o2 p6-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p6-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-6))))
                                       
          (when (and (handempty) (obj-at o2 p6-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-6))))
                                       ))

   (:action pickup-4-1-look-3
      :precondition (at p4-1) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p4-1)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p4-1)))
            
            ; X = 1
                ; Y = 1
          (when (and (handempty) (obj-at o1 p1-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-1))))
                                       
          (when (and (handempty) (obj-at o2 p1-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p1-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-2))))
                                       
          (when (and (handempty) (obj-at o2 p1-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p1-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-3))))
                                       
          (when (and (handempty) (obj-at o2 p1-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p1-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-4))))
                                       
          (when (and (handempty) (obj-at o2 p1-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-4))))
                                       
            ; X = 2
                ; Y = 1
          (when (and (handempty) (obj-at o1 p2-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-1))))
                                       
          (when (and (handempty) (obj-at o2 p2-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p2-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-2))))
                                       
          (when (and (handempty) (obj-at o2 p2-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p2-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-3))))
                                       
          (when (and (handempty) (obj-at o2 p2-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p2-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-4))))
                                       
          (when (and (handempty) (obj-at o2 p2-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-4))))
                                       
            ; X = 3
                ; Y = 1
          (when (and (handempty) (obj-at o1 p3-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-1))))
                                       
          (when (and (handempty) (obj-at o2 p3-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p3-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-2))))
                                       
          (when (and (handempty) (obj-at o2 p3-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
            ; X = 4
                ; Y = 1
          (when (and (handempty) (obj-at o1 p4-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-1))))
                                       
          (when (and (handempty) (obj-at o2 p4-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p4-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-2))))
                                       
          (when (and (handempty) (obj-at o2 p4-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       
            ; X = 5
                ; Y = 1
          (when (and (handempty) (obj-at o1 p5-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-1))))
                                       
          (when (and (handempty) (obj-at o2 p5-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p5-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-2))))
                                       
          (when (and (handempty) (obj-at o2 p5-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p5-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-3))))
                                       
          (when (and (handempty) (obj-at o2 p5-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p5-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-4))))
                                       
          (when (and (handempty) (obj-at o2 p5-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-4))))
                                       
            ; X = 6
                ; Y = 1
          (when (and (handempty) (obj-at o1 p6-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-1))))
                                       
          (when (and (handempty) (obj-at o2 p6-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p6-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-2))))
                                       
          (when (and (handempty) (obj-at o2 p6-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p6-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-3))))
                                       
          (when (and (handempty) (obj-at o2 p6-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p6-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-4))))
                                       
          (when (and (handempty) (obj-at o2 p6-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-4))))
                                       ))

   (:action pickup-4-2-look-3
      :precondition (at p4-2) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p4-2)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p4-2)))
            
            ; X = 1
                ; Y = 1
          (when (and (handempty) (obj-at o1 p1-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-1))))
                                       
          (when (and (handempty) (obj-at o2 p1-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p1-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-2))))
                                       
          (when (and (handempty) (obj-at o2 p1-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p1-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-3))))
                                       
          (when (and (handempty) (obj-at o2 p1-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p1-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-4))))
                                       
          (when (and (handempty) (obj-at o2 p1-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p1-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-5))))
                                       
          (when (and (handempty) (obj-at o2 p1-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-5))))
                                       
            ; X = 2
                ; Y = 1
          (when (and (handempty) (obj-at o1 p2-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-1))))
                                       
          (when (and (handempty) (obj-at o2 p2-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p2-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-2))))
                                       
          (when (and (handempty) (obj-at o2 p2-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p2-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-3))))
                                       
          (when (and (handempty) (obj-at o2 p2-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p2-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-4))))
                                       
          (when (and (handempty) (obj-at o2 p2-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p2-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-5))))
                                       
          (when (and (handempty) (obj-at o2 p2-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-5))))
                                       
            ; X = 3
                ; Y = 1
          (when (and (handempty) (obj-at o1 p3-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-1))))
                                       
          (when (and (handempty) (obj-at o2 p3-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p3-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-2))))
                                       
          (when (and (handempty) (obj-at o2 p3-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p3-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-5))))
                                       
          (when (and (handempty) (obj-at o2 p3-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-5))))
                                       
            ; X = 4
                ; Y = 1
          (when (and (handempty) (obj-at o1 p4-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-1))))
                                       
          (when (and (handempty) (obj-at o2 p4-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p4-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-2))))
                                       
          (when (and (handempty) (obj-at o2 p4-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p4-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-5))))
                                       
          (when (and (handempty) (obj-at o2 p4-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-5))))
                                       
            ; X = 5
                ; Y = 1
          (when (and (handempty) (obj-at o1 p5-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-1))))
                                       
          (when (and (handempty) (obj-at o2 p5-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p5-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-2))))
                                       
          (when (and (handempty) (obj-at o2 p5-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p5-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-3))))
                                       
          (when (and (handempty) (obj-at o2 p5-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p5-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-4))))
                                       
          (when (and (handempty) (obj-at o2 p5-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p5-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-5))))
                                       
          (when (and (handempty) (obj-at o2 p5-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-5))))
                                       
            ; X = 6
                ; Y = 1
          (when (and (handempty) (obj-at o1 p6-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-1))))
                                       
          (when (and (handempty) (obj-at o2 p6-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p6-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-2))))
                                       
          (when (and (handempty) (obj-at o2 p6-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p6-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-3))))
                                       
          (when (and (handempty) (obj-at o2 p6-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p6-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-4))))
                                       
          (when (and (handempty) (obj-at o2 p6-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p6-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-5))))
                                       
          (when (and (handempty) (obj-at o2 p6-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-5))))
                                       ))

   (:action pickup-4-3-look-3
      :precondition (at p4-3) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p4-3)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p4-3)))
            
            ; X = 1
                ; Y = 1
          (when (and (handempty) (obj-at o1 p1-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-1))))
                                       
          (when (and (handempty) (obj-at o2 p1-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p1-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-2))))
                                       
          (when (and (handempty) (obj-at o2 p1-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p1-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-3))))
                                       
          (when (and (handempty) (obj-at o2 p1-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p1-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-4))))
                                       
          (when (and (handempty) (obj-at o2 p1-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p1-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-5))))
                                       
          (when (and (handempty) (obj-at o2 p1-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p1-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-6))))
                                       
          (when (and (handempty) (obj-at o2 p1-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-6))))
                                       
            ; X = 2
                ; Y = 1
          (when (and (handempty) (obj-at o1 p2-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-1))))
                                       
          (when (and (handempty) (obj-at o2 p2-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p2-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-2))))
                                       
          (when (and (handempty) (obj-at o2 p2-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p2-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-3))))
                                       
          (when (and (handempty) (obj-at o2 p2-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p2-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-4))))
                                       
          (when (and (handempty) (obj-at o2 p2-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p2-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-5))))
                                       
          (when (and (handempty) (obj-at o2 p2-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p2-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-6))))
                                       
          (when (and (handempty) (obj-at o2 p2-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-6))))
                                       
            ; X = 3
                ; Y = 1
          (when (and (handempty) (obj-at o1 p3-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-1))))
                                       
          (when (and (handempty) (obj-at o2 p3-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p3-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-2))))
                                       
          (when (and (handempty) (obj-at o2 p3-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p3-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-5))))
                                       
          (when (and (handempty) (obj-at o2 p3-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p3-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-6))))
                                       
          (when (and (handempty) (obj-at o2 p3-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-6))))
                                       
            ; X = 4
                ; Y = 1
          (when (and (handempty) (obj-at o1 p4-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-1))))
                                       
          (when (and (handempty) (obj-at o2 p4-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p4-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-2))))
                                       
          (when (and (handempty) (obj-at o2 p4-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p4-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-5))))
                                       
          (when (and (handempty) (obj-at o2 p4-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p4-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-6))))
                                       
          (when (and (handempty) (obj-at o2 p4-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-6))))
                                       
            ; X = 5
                ; Y = 1
          (when (and (handempty) (obj-at o1 p5-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-1))))
                                       
          (when (and (handempty) (obj-at o2 p5-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p5-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-2))))
                                       
          (when (and (handempty) (obj-at o2 p5-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p5-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-3))))
                                       
          (when (and (handempty) (obj-at o2 p5-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p5-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-4))))
                                       
          (when (and (handempty) (obj-at o2 p5-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p5-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-5))))
                                       
          (when (and (handempty) (obj-at o2 p5-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p5-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-6))))
                                       
          (when (and (handempty) (obj-at o2 p5-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-6))))
                                       
            ; X = 6
                ; Y = 1
          (when (and (handempty) (obj-at o1 p6-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-1))))
                                       
          (when (and (handempty) (obj-at o2 p6-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p6-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-2))))
                                       
          (when (and (handempty) (obj-at o2 p6-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p6-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-3))))
                                       
          (when (and (handempty) (obj-at o2 p6-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p6-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-4))))
                                       
          (when (and (handempty) (obj-at o2 p6-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p6-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-5))))
                                       
          (when (and (handempty) (obj-at o2 p6-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p6-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-6))))
                                       
          (when (and (handempty) (obj-at o2 p6-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-6))))
                                       ))

   (:action pickup-4-4-look-3
      :precondition (at p4-4) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p4-4)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p4-4)))
            
            ; X = 1
                ; Y = 1
          (when (and (handempty) (obj-at o1 p1-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-1))))
                                       
          (when (and (handempty) (obj-at o2 p1-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p1-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-2))))
                                       
          (when (and (handempty) (obj-at o2 p1-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p1-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-3))))
                                       
          (when (and (handempty) (obj-at o2 p1-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p1-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-4))))
                                       
          (when (and (handempty) (obj-at o2 p1-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p1-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-5))))
                                       
          (when (and (handempty) (obj-at o2 p1-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p1-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-6))))
                                       
          (when (and (handempty) (obj-at o2 p1-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-6))))
                                       
            ; X = 2
                ; Y = 1
          (when (and (handempty) (obj-at o1 p2-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-1))))
                                       
          (when (and (handempty) (obj-at o2 p2-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p2-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-2))))
                                       
          (when (and (handempty) (obj-at o2 p2-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p2-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-3))))
                                       
          (when (and (handempty) (obj-at o2 p2-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p2-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-4))))
                                       
          (when (and (handempty) (obj-at o2 p2-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p2-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-5))))
                                       
          (when (and (handempty) (obj-at o2 p2-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p2-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-6))))
                                       
          (when (and (handempty) (obj-at o2 p2-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-6))))
                                       
            ; X = 3
                ; Y = 1
          (when (and (handempty) (obj-at o1 p3-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-1))))
                                       
          (when (and (handempty) (obj-at o2 p3-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p3-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-2))))
                                       
          (when (and (handempty) (obj-at o2 p3-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p3-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-5))))
                                       
          (when (and (handempty) (obj-at o2 p3-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p3-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-6))))
                                       
          (when (and (handempty) (obj-at o2 p3-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-6))))
                                       
            ; X = 4
                ; Y = 1
          (when (and (handempty) (obj-at o1 p4-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-1))))
                                       
          (when (and (handempty) (obj-at o2 p4-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p4-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-2))))
                                       
          (when (and (handempty) (obj-at o2 p4-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p4-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-5))))
                                       
          (when (and (handempty) (obj-at o2 p4-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p4-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-6))))
                                       
          (when (and (handempty) (obj-at o2 p4-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-6))))
                                       
            ; X = 5
                ; Y = 1
          (when (and (handempty) (obj-at o1 p5-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-1))))
                                       
          (when (and (handempty) (obj-at o2 p5-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p5-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-2))))
                                       
          (when (and (handempty) (obj-at o2 p5-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p5-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-3))))
                                       
          (when (and (handempty) (obj-at o2 p5-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p5-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-4))))
                                       
          (when (and (handempty) (obj-at o2 p5-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p5-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-5))))
                                       
          (when (and (handempty) (obj-at o2 p5-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p5-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-6))))
                                       
          (when (and (handempty) (obj-at o2 p5-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-6))))
                                       
            ; X = 6
                ; Y = 1
          (when (and (handempty) (obj-at o1 p6-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-1))))
                                       
          (when (and (handempty) (obj-at o2 p6-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p6-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-2))))
                                       
          (when (and (handempty) (obj-at o2 p6-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p6-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-3))))
                                       
          (when (and (handempty) (obj-at o2 p6-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p6-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-4))))
                                       
          (when (and (handempty) (obj-at o2 p6-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p6-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-5))))
                                       
          (when (and (handempty) (obj-at o2 p6-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p6-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-6))))
                                       
          (when (and (handempty) (obj-at o2 p6-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-6))))
                                       ))

   (:action pickup-4-5-look-3
      :precondition (at p4-5) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p4-5)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p4-5)))
            
            ; X = 1
                ; Y = 2
          (when (and (handempty) (obj-at o1 p1-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-2))))
                                       
          (when (and (handempty) (obj-at o2 p1-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p1-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-3))))
                                       
          (when (and (handempty) (obj-at o2 p1-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p1-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-4))))
                                       
          (when (and (handempty) (obj-at o2 p1-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p1-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-5))))
                                       
          (when (and (handempty) (obj-at o2 p1-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p1-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-6))))
                                       
          (when (and (handempty) (obj-at o2 p1-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-6))))
                                       
            ; X = 2
                ; Y = 2
          (when (and (handempty) (obj-at o1 p2-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-2))))
                                       
          (when (and (handempty) (obj-at o2 p2-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p2-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-3))))
                                       
          (when (and (handempty) (obj-at o2 p2-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p2-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-4))))
                                       
          (when (and (handempty) (obj-at o2 p2-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p2-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-5))))
                                       
          (when (and (handempty) (obj-at o2 p2-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p2-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-6))))
                                       
          (when (and (handempty) (obj-at o2 p2-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-6))))
                                       
            ; X = 3
                ; Y = 2
          (when (and (handempty) (obj-at o1 p3-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-2))))
                                       
          (when (and (handempty) (obj-at o2 p3-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p3-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-5))))
                                       
          (when (and (handempty) (obj-at o2 p3-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p3-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-6))))
                                       
          (when (and (handempty) (obj-at o2 p3-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-6))))
                                       
            ; X = 4
                ; Y = 2
          (when (and (handempty) (obj-at o1 p4-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-2))))
                                       
          (when (and (handempty) (obj-at o2 p4-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p4-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-5))))
                                       
          (when (and (handempty) (obj-at o2 p4-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p4-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-6))))
                                       
          (when (and (handempty) (obj-at o2 p4-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-6))))
                                       
            ; X = 5
                ; Y = 2
          (when (and (handempty) (obj-at o1 p5-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-2))))
                                       
          (when (and (handempty) (obj-at o2 p5-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p5-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-3))))
                                       
          (when (and (handempty) (obj-at o2 p5-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p5-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-4))))
                                       
          (when (and (handempty) (obj-at o2 p5-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p5-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-5))))
                                       
          (when (and (handempty) (obj-at o2 p5-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p5-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-6))))
                                       
          (when (and (handempty) (obj-at o2 p5-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-6))))
                                       
            ; X = 6
                ; Y = 2
          (when (and (handempty) (obj-at o1 p6-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-2))))
                                       
          (when (and (handempty) (obj-at o2 p6-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p6-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-3))))
                                       
          (when (and (handempty) (obj-at o2 p6-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p6-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-4))))
                                       
          (when (and (handempty) (obj-at o2 p6-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p6-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-5))))
                                       
          (when (and (handempty) (obj-at o2 p6-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p6-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-6))))
                                       
          (when (and (handempty) (obj-at o2 p6-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-6))))
                                       ))

   (:action pickup-4-6-look-3
      :precondition (at p4-6) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p4-6)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p4-6)))
            
            ; X = 1
                ; Y = 3
          (when (and (handempty) (obj-at o1 p1-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-3))))
                                       
          (when (and (handempty) (obj-at o2 p1-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p1-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-4))))
                                       
          (when (and (handempty) (obj-at o2 p1-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p1-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-5))))
                                       
          (when (and (handempty) (obj-at o2 p1-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p1-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p1-6))))
                                       
          (when (and (handempty) (obj-at o2 p1-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p1-6))))
                                       
            ; X = 2
                ; Y = 3
          (when (and (handempty) (obj-at o1 p2-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-3))))
                                       
          (when (and (handempty) (obj-at o2 p2-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p2-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-4))))
                                       
          (when (and (handempty) (obj-at o2 p2-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p2-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-5))))
                                       
          (when (and (handempty) (obj-at o2 p2-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p2-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-6))))
                                       
          (when (and (handempty) (obj-at o2 p2-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-6))))
                                       
            ; X = 3
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p3-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-5))))
                                       
          (when (and (handempty) (obj-at o2 p3-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p3-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-6))))
                                       
          (when (and (handempty) (obj-at o2 p3-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-6))))
                                       
            ; X = 4
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p4-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-5))))
                                       
          (when (and (handempty) (obj-at o2 p4-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p4-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-6))))
                                       
          (when (and (handempty) (obj-at o2 p4-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-6))))
                                       
            ; X = 5
                ; Y = 3
          (when (and (handempty) (obj-at o1 p5-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-3))))
                                       
          (when (and (handempty) (obj-at o2 p5-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p5-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-4))))
                                       
          (when (and (handempty) (obj-at o2 p5-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p5-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-5))))
                                       
          (when (and (handempty) (obj-at o2 p5-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p5-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-6))))
                                       
          (when (and (handempty) (obj-at o2 p5-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-6))))
                                       
            ; X = 6
                ; Y = 3
          (when (and (handempty) (obj-at o1 p6-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-3))))
                                       
          (when (and (handempty) (obj-at o2 p6-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p6-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-4))))
                                       
          (when (and (handempty) (obj-at o2 p6-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p6-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-5))))
                                       
          (when (and (handempty) (obj-at o2 p6-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p6-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-6))))
                                       
          (when (and (handempty) (obj-at o2 p6-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-6))))
                                       ))

   (:action pickup-5-1-look-3
      :precondition (at p5-1) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p5-1)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p5-1)))
            
            ; X = 2
                ; Y = 1
          (when (and (handempty) (obj-at o1 p2-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-1))))
                                       
          (when (and (handempty) (obj-at o2 p2-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p2-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-2))))
                                       
          (when (and (handempty) (obj-at o2 p2-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p2-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-3))))
                                       
          (when (and (handempty) (obj-at o2 p2-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p2-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-4))))
                                       
          (when (and (handempty) (obj-at o2 p2-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-4))))
                                       
            ; X = 3
                ; Y = 1
          (when (and (handempty) (obj-at o1 p3-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-1))))
                                       
          (when (and (handempty) (obj-at o2 p3-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p3-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-2))))
                                       
          (when (and (handempty) (obj-at o2 p3-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
            ; X = 4
                ; Y = 1
          (when (and (handempty) (obj-at o1 p4-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-1))))
                                       
          (when (and (handempty) (obj-at o2 p4-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p4-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-2))))
                                       
          (when (and (handempty) (obj-at o2 p4-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       
            ; X = 5
                ; Y = 1
          (when (and (handempty) (obj-at o1 p5-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-1))))
                                       
          (when (and (handempty) (obj-at o2 p5-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p5-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-2))))
                                       
          (when (and (handempty) (obj-at o2 p5-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p5-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-3))))
                                       
          (when (and (handempty) (obj-at o2 p5-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p5-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-4))))
                                       
          (when (and (handempty) (obj-at o2 p5-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-4))))
                                       
            ; X = 6
                ; Y = 1
          (when (and (handempty) (obj-at o1 p6-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-1))))
                                       
          (when (and (handempty) (obj-at o2 p6-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p6-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-2))))
                                       
          (when (and (handempty) (obj-at o2 p6-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p6-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-3))))
                                       
          (when (and (handempty) (obj-at o2 p6-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p6-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-4))))
                                       
          (when (and (handempty) (obj-at o2 p6-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-4))))
                                       ))

   (:action pickup-5-2-look-3
      :precondition (at p5-2) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p5-2)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p5-2)))
            
            ; X = 2
                ; Y = 1
          (when (and (handempty) (obj-at o1 p2-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-1))))
                                       
          (when (and (handempty) (obj-at o2 p2-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p2-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-2))))
                                       
          (when (and (handempty) (obj-at o2 p2-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p2-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-3))))
                                       
          (when (and (handempty) (obj-at o2 p2-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p2-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-4))))
                                       
          (when (and (handempty) (obj-at o2 p2-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p2-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-5))))
                                       
          (when (and (handempty) (obj-at o2 p2-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-5))))
                                       
            ; X = 3
                ; Y = 1
          (when (and (handempty) (obj-at o1 p3-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-1))))
                                       
          (when (and (handempty) (obj-at o2 p3-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p3-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-2))))
                                       
          (when (and (handempty) (obj-at o2 p3-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p3-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-5))))
                                       
          (when (and (handempty) (obj-at o2 p3-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-5))))
                                       
            ; X = 4
                ; Y = 1
          (when (and (handempty) (obj-at o1 p4-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-1))))
                                       
          (when (and (handempty) (obj-at o2 p4-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p4-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-2))))
                                       
          (when (and (handempty) (obj-at o2 p4-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p4-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-5))))
                                       
          (when (and (handempty) (obj-at o2 p4-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-5))))
                                       
            ; X = 5
                ; Y = 1
          (when (and (handempty) (obj-at o1 p5-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-1))))
                                       
          (when (and (handempty) (obj-at o2 p5-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p5-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-2))))
                                       
          (when (and (handempty) (obj-at o2 p5-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p5-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-3))))
                                       
          (when (and (handempty) (obj-at o2 p5-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p5-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-4))))
                                       
          (when (and (handempty) (obj-at o2 p5-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p5-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-5))))
                                       
          (when (and (handempty) (obj-at o2 p5-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-5))))
                                       
            ; X = 6
                ; Y = 1
          (when (and (handempty) (obj-at o1 p6-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-1))))
                                       
          (when (and (handempty) (obj-at o2 p6-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p6-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-2))))
                                       
          (when (and (handempty) (obj-at o2 p6-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p6-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-3))))
                                       
          (when (and (handempty) (obj-at o2 p6-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p6-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-4))))
                                       
          (when (and (handempty) (obj-at o2 p6-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p6-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-5))))
                                       
          (when (and (handempty) (obj-at o2 p6-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-5))))
                                       ))

   (:action pickup-5-3-look-3
      :precondition (at p5-3) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p5-3)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p5-3)))
            
            ; X = 2
                ; Y = 1
          (when (and (handempty) (obj-at o1 p2-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-1))))
                                       
          (when (and (handempty) (obj-at o2 p2-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p2-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-2))))
                                       
          (when (and (handempty) (obj-at o2 p2-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p2-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-3))))
                                       
          (when (and (handempty) (obj-at o2 p2-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p2-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-4))))
                                       
          (when (and (handempty) (obj-at o2 p2-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p2-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-5))))
                                       
          (when (and (handempty) (obj-at o2 p2-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p2-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-6))))
                                       
          (when (and (handempty) (obj-at o2 p2-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-6))))
                                       
            ; X = 3
                ; Y = 1
          (when (and (handempty) (obj-at o1 p3-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-1))))
                                       
          (when (and (handempty) (obj-at o2 p3-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p3-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-2))))
                                       
          (when (and (handempty) (obj-at o2 p3-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p3-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-5))))
                                       
          (when (and (handempty) (obj-at o2 p3-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p3-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-6))))
                                       
          (when (and (handempty) (obj-at o2 p3-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-6))))
                                       
            ; X = 4
                ; Y = 1
          (when (and (handempty) (obj-at o1 p4-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-1))))
                                       
          (when (and (handempty) (obj-at o2 p4-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p4-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-2))))
                                       
          (when (and (handempty) (obj-at o2 p4-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p4-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-5))))
                                       
          (when (and (handempty) (obj-at o2 p4-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p4-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-6))))
                                       
          (when (and (handempty) (obj-at o2 p4-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-6))))
                                       
            ; X = 5
                ; Y = 1
          (when (and (handempty) (obj-at o1 p5-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-1))))
                                       
          (when (and (handempty) (obj-at o2 p5-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p5-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-2))))
                                       
          (when (and (handempty) (obj-at o2 p5-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p5-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-3))))
                                       
          (when (and (handempty) (obj-at o2 p5-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p5-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-4))))
                                       
          (when (and (handempty) (obj-at o2 p5-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p5-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-5))))
                                       
          (when (and (handempty) (obj-at o2 p5-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p5-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-6))))
                                       
          (when (and (handempty) (obj-at o2 p5-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-6))))
                                       
            ; X = 6
                ; Y = 1
          (when (and (handempty) (obj-at o1 p6-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-1))))
                                       
          (when (and (handempty) (obj-at o2 p6-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p6-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-2))))
                                       
          (when (and (handempty) (obj-at o2 p6-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p6-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-3))))
                                       
          (when (and (handempty) (obj-at o2 p6-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p6-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-4))))
                                       
          (when (and (handempty) (obj-at o2 p6-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p6-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-5))))
                                       
          (when (and (handempty) (obj-at o2 p6-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p6-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-6))))
                                       
          (when (and (handempty) (obj-at o2 p6-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-6))))
                                       ))

   (:action pickup-5-4-look-3
      :precondition (at p5-4) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p5-4)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p5-4)))
            
            ; X = 2
                ; Y = 1
          (when (and (handempty) (obj-at o1 p2-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-1))))
                                       
          (when (and (handempty) (obj-at o2 p2-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p2-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-2))))
                                       
          (when (and (handempty) (obj-at o2 p2-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p2-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-3))))
                                       
          (when (and (handempty) (obj-at o2 p2-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p2-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-4))))
                                       
          (when (and (handempty) (obj-at o2 p2-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p2-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-5))))
                                       
          (when (and (handempty) (obj-at o2 p2-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p2-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-6))))
                                       
          (when (and (handempty) (obj-at o2 p2-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-6))))
                                       
            ; X = 3
                ; Y = 1
          (when (and (handempty) (obj-at o1 p3-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-1))))
                                       
          (when (and (handempty) (obj-at o2 p3-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p3-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-2))))
                                       
          (when (and (handempty) (obj-at o2 p3-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p3-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-5))))
                                       
          (when (and (handempty) (obj-at o2 p3-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p3-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-6))))
                                       
          (when (and (handempty) (obj-at o2 p3-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-6))))
                                       
            ; X = 4
                ; Y = 1
          (when (and (handempty) (obj-at o1 p4-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-1))))
                                       
          (when (and (handempty) (obj-at o2 p4-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p4-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-2))))
                                       
          (when (and (handempty) (obj-at o2 p4-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p4-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-5))))
                                       
          (when (and (handempty) (obj-at o2 p4-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p4-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-6))))
                                       
          (when (and (handempty) (obj-at o2 p4-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-6))))
                                       
            ; X = 5
                ; Y = 1
          (when (and (handempty) (obj-at o1 p5-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-1))))
                                       
          (when (and (handempty) (obj-at o2 p5-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p5-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-2))))
                                       
          (when (and (handempty) (obj-at o2 p5-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p5-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-3))))
                                       
          (when (and (handempty) (obj-at o2 p5-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p5-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-4))))
                                       
          (when (and (handempty) (obj-at o2 p5-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p5-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-5))))
                                       
          (when (and (handempty) (obj-at o2 p5-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p5-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-6))))
                                       
          (when (and (handempty) (obj-at o2 p5-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-6))))
                                       
            ; X = 6
                ; Y = 1
          (when (and (handempty) (obj-at o1 p6-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-1))))
                                       
          (when (and (handempty) (obj-at o2 p6-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p6-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-2))))
                                       
          (when (and (handempty) (obj-at o2 p6-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p6-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-3))))
                                       
          (when (and (handempty) (obj-at o2 p6-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p6-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-4))))
                                       
          (when (and (handempty) (obj-at o2 p6-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p6-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-5))))
                                       
          (when (and (handempty) (obj-at o2 p6-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p6-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-6))))
                                       
          (when (and (handempty) (obj-at o2 p6-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-6))))
                                       ))

   (:action pickup-5-5-look-3
      :precondition (at p5-5) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p5-5)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p5-5)))
            
            ; X = 2
                ; Y = 2
          (when (and (handempty) (obj-at o1 p2-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-2))))
                                       
          (when (and (handempty) (obj-at o2 p2-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p2-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-3))))
                                       
          (when (and (handempty) (obj-at o2 p2-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p2-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-4))))
                                       
          (when (and (handempty) (obj-at o2 p2-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p2-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-5))))
                                       
          (when (and (handempty) (obj-at o2 p2-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p2-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-6))))
                                       
          (when (and (handempty) (obj-at o2 p2-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-6))))
                                       
            ; X = 3
                ; Y = 2
          (when (and (handempty) (obj-at o1 p3-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-2))))
                                       
          (when (and (handempty) (obj-at o2 p3-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p3-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-5))))
                                       
          (when (and (handempty) (obj-at o2 p3-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p3-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-6))))
                                       
          (when (and (handempty) (obj-at o2 p3-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-6))))
                                       
            ; X = 4
                ; Y = 2
          (when (and (handempty) (obj-at o1 p4-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-2))))
                                       
          (when (and (handempty) (obj-at o2 p4-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p4-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-5))))
                                       
          (when (and (handempty) (obj-at o2 p4-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p4-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-6))))
                                       
          (when (and (handempty) (obj-at o2 p4-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-6))))
                                       
            ; X = 5
                ; Y = 2
          (when (and (handempty) (obj-at o1 p5-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-2))))
                                       
          (when (and (handempty) (obj-at o2 p5-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p5-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-3))))
                                       
          (when (and (handempty) (obj-at o2 p5-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p5-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-4))))
                                       
          (when (and (handempty) (obj-at o2 p5-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p5-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-5))))
                                       
          (when (and (handempty) (obj-at o2 p5-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p5-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-6))))
                                       
          (when (and (handempty) (obj-at o2 p5-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-6))))
                                       
            ; X = 6
                ; Y = 2
          (when (and (handempty) (obj-at o1 p6-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-2))))
                                       
          (when (and (handempty) (obj-at o2 p6-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p6-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-3))))
                                       
          (when (and (handempty) (obj-at o2 p6-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p6-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-4))))
                                       
          (when (and (handempty) (obj-at o2 p6-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p6-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-5))))
                                       
          (when (and (handempty) (obj-at o2 p6-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p6-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-6))))
                                       
          (when (and (handempty) (obj-at o2 p6-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-6))))
                                       ))

   (:action pickup-5-6-look-3
      :precondition (at p5-6) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p5-6)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p5-6)))
            
            ; X = 2
                ; Y = 3
          (when (and (handempty) (obj-at o1 p2-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-3))))
                                       
          (when (and (handempty) (obj-at o2 p2-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p2-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-4))))
                                       
          (when (and (handempty) (obj-at o2 p2-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p2-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-5))))
                                       
          (when (and (handempty) (obj-at o2 p2-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p2-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p2-6))))
                                       
          (when (and (handempty) (obj-at o2 p2-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p2-6))))
                                       
            ; X = 3
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p3-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-5))))
                                       
          (when (and (handempty) (obj-at o2 p3-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p3-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-6))))
                                       
          (when (and (handempty) (obj-at o2 p3-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-6))))
                                       
            ; X = 4
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p4-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-5))))
                                       
          (when (and (handempty) (obj-at o2 p4-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p4-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-6))))
                                       
          (when (and (handempty) (obj-at o2 p4-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-6))))
                                       
            ; X = 5
                ; Y = 3
          (when (and (handempty) (obj-at o1 p5-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-3))))
                                       
          (when (and (handempty) (obj-at o2 p5-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p5-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-4))))
                                       
          (when (and (handempty) (obj-at o2 p5-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p5-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-5))))
                                       
          (when (and (handempty) (obj-at o2 p5-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p5-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-6))))
                                       
          (when (and (handempty) (obj-at o2 p5-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-6))))
                                       
            ; X = 6
                ; Y = 3
          (when (and (handempty) (obj-at o1 p6-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-3))))
                                       
          (when (and (handempty) (obj-at o2 p6-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p6-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-4))))
                                       
          (when (and (handempty) (obj-at o2 p6-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p6-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-5))))
                                       
          (when (and (handempty) (obj-at o2 p6-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p6-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-6))))
                                       
          (when (and (handempty) (obj-at o2 p6-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-6))))
                                       ))

   (:action pickup-6-1-look-3
      :precondition (at p6-1) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p6-1)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p6-1)))
            
            ; X = 3
                ; Y = 1
          (when (and (handempty) (obj-at o1 p3-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-1))))
                                       
          (when (and (handempty) (obj-at o2 p3-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p3-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-2))))
                                       
          (when (and (handempty) (obj-at o2 p3-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
            ; X = 4
                ; Y = 1
          (when (and (handempty) (obj-at o1 p4-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-1))))
                                       
          (when (and (handempty) (obj-at o2 p4-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p4-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-2))))
                                       
          (when (and (handempty) (obj-at o2 p4-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       
            ; X = 5
                ; Y = 1
          (when (and (handempty) (obj-at o1 p5-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-1))))
                                       
          (when (and (handempty) (obj-at o2 p5-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p5-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-2))))
                                       
          (when (and (handempty) (obj-at o2 p5-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p5-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-3))))
                                       
          (when (and (handempty) (obj-at o2 p5-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p5-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-4))))
                                       
          (when (and (handempty) (obj-at o2 p5-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-4))))
                                       
            ; X = 6
                ; Y = 1
          (when (and (handempty) (obj-at o1 p6-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-1))))
                                       
          (when (and (handempty) (obj-at o2 p6-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p6-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-2))))
                                       
          (when (and (handempty) (obj-at o2 p6-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p6-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-3))))
                                       
          (when (and (handempty) (obj-at o2 p6-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p6-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-4))))
                                       
          (when (and (handempty) (obj-at o2 p6-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-4))))
                                       ))

   (:action pickup-6-2-look-3
      :precondition (at p6-2) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p6-2)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p6-2)))
            
            ; X = 3
                ; Y = 1
          (when (and (handempty) (obj-at o1 p3-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-1))))
                                       
          (when (and (handempty) (obj-at o2 p3-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p3-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-2))))
                                       
          (when (and (handempty) (obj-at o2 p3-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p3-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-5))))
                                       
          (when (and (handempty) (obj-at o2 p3-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-5))))
                                       
            ; X = 4
                ; Y = 1
          (when (and (handempty) (obj-at o1 p4-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-1))))
                                       
          (when (and (handempty) (obj-at o2 p4-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p4-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-2))))
                                       
          (when (and (handempty) (obj-at o2 p4-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p4-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-5))))
                                       
          (when (and (handempty) (obj-at o2 p4-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-5))))
                                       
            ; X = 5
                ; Y = 1
          (when (and (handempty) (obj-at o1 p5-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-1))))
                                       
          (when (and (handempty) (obj-at o2 p5-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p5-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-2))))
                                       
          (when (and (handempty) (obj-at o2 p5-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p5-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-3))))
                                       
          (when (and (handempty) (obj-at o2 p5-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p5-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-4))))
                                       
          (when (and (handempty) (obj-at o2 p5-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p5-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-5))))
                                       
          (when (and (handempty) (obj-at o2 p5-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-5))))
                                       
            ; X = 6
                ; Y = 1
          (when (and (handempty) (obj-at o1 p6-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-1))))
                                       
          (when (and (handempty) (obj-at o2 p6-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p6-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-2))))
                                       
          (when (and (handempty) (obj-at o2 p6-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p6-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-3))))
                                       
          (when (and (handempty) (obj-at o2 p6-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p6-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-4))))
                                       
          (when (and (handempty) (obj-at o2 p6-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p6-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-5))))
                                       
          (when (and (handempty) (obj-at o2 p6-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-5))))
                                       ))

   (:action pickup-6-3-look-3
      :precondition (at p6-3) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p6-3)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p6-3)))
            
            ; X = 3
                ; Y = 1
          (when (and (handempty) (obj-at o1 p3-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-1))))
                                       
          (when (and (handempty) (obj-at o2 p3-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p3-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-2))))
                                       
          (when (and (handempty) (obj-at o2 p3-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p3-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-5))))
                                       
          (when (and (handempty) (obj-at o2 p3-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p3-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-6))))
                                       
          (when (and (handempty) (obj-at o2 p3-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-6))))
                                       
            ; X = 4
                ; Y = 1
          (when (and (handempty) (obj-at o1 p4-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-1))))
                                       
          (when (and (handempty) (obj-at o2 p4-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p4-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-2))))
                                       
          (when (and (handempty) (obj-at o2 p4-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p4-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-5))))
                                       
          (when (and (handempty) (obj-at o2 p4-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p4-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-6))))
                                       
          (when (and (handempty) (obj-at o2 p4-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-6))))
                                       
            ; X = 5
                ; Y = 1
          (when (and (handempty) (obj-at o1 p5-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-1))))
                                       
          (when (and (handempty) (obj-at o2 p5-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p5-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-2))))
                                       
          (when (and (handempty) (obj-at o2 p5-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p5-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-3))))
                                       
          (when (and (handempty) (obj-at o2 p5-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p5-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-4))))
                                       
          (when (and (handempty) (obj-at o2 p5-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p5-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-5))))
                                       
          (when (and (handempty) (obj-at o2 p5-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p5-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-6))))
                                       
          (when (and (handempty) (obj-at o2 p5-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-6))))
                                       
            ; X = 6
                ; Y = 1
          (when (and (handempty) (obj-at o1 p6-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-1))))
                                       
          (when (and (handempty) (obj-at o2 p6-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p6-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-2))))
                                       
          (when (and (handempty) (obj-at o2 p6-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p6-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-3))))
                                       
          (when (and (handempty) (obj-at o2 p6-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p6-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-4))))
                                       
          (when (and (handempty) (obj-at o2 p6-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p6-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-5))))
                                       
          (when (and (handempty) (obj-at o2 p6-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p6-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-6))))
                                       
          (when (and (handempty) (obj-at o2 p6-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-6))))
                                       ))

   (:action pickup-6-4-look-3
      :precondition (at p6-4) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p6-4)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p6-4)))
            
            ; X = 3
                ; Y = 1
          (when (and (handempty) (obj-at o1 p3-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-1))))
                                       
          (when (and (handempty) (obj-at o2 p3-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p3-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-2))))
                                       
          (when (and (handempty) (obj-at o2 p3-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p3-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-5))))
                                       
          (when (and (handempty) (obj-at o2 p3-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p3-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-6))))
                                       
          (when (and (handempty) (obj-at o2 p3-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-6))))
                                       
            ; X = 4
                ; Y = 1
          (when (and (handempty) (obj-at o1 p4-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-1))))
                                       
          (when (and (handempty) (obj-at o2 p4-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p4-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-2))))
                                       
          (when (and (handempty) (obj-at o2 p4-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p4-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-5))))
                                       
          (when (and (handempty) (obj-at o2 p4-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p4-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-6))))
                                       
          (when (and (handempty) (obj-at o2 p4-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-6))))
                                       
            ; X = 5
                ; Y = 1
          (when (and (handempty) (obj-at o1 p5-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-1))))
                                       
          (when (and (handempty) (obj-at o2 p5-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p5-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-2))))
                                       
          (when (and (handempty) (obj-at o2 p5-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p5-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-3))))
                                       
          (when (and (handempty) (obj-at o2 p5-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p5-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-4))))
                                       
          (when (and (handempty) (obj-at o2 p5-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p5-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-5))))
                                       
          (when (and (handempty) (obj-at o2 p5-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p5-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-6))))
                                       
          (when (and (handempty) (obj-at o2 p5-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-6))))
                                       
            ; X = 6
                ; Y = 1
          (when (and (handempty) (obj-at o1 p6-1))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-1))))
                                       
          (when (and (handempty) (obj-at o2 p6-1))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-1))))
                                       
                ; Y = 2
          (when (and (handempty) (obj-at o1 p6-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-2))))
                                       
          (when (and (handempty) (obj-at o2 p6-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p6-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-3))))
                                       
          (when (and (handempty) (obj-at o2 p6-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p6-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-4))))
                                       
          (when (and (handempty) (obj-at o2 p6-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p6-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-5))))
                                       
          (when (and (handempty) (obj-at o2 p6-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p6-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-6))))
                                       
          (when (and (handempty) (obj-at o2 p6-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-6))))
                                       ))

   (:action pickup-6-5-look-3
      :precondition (at p6-5) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p6-5)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p6-5)))
            
            ; X = 3
                ; Y = 2
          (when (and (handempty) (obj-at o1 p3-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-2))))
                                       
          (when (and (handempty) (obj-at o2 p3-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p3-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-5))))
                                       
          (when (and (handempty) (obj-at o2 p3-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p3-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-6))))
                                       
          (when (and (handempty) (obj-at o2 p3-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-6))))
                                       
            ; X = 4
                ; Y = 2
          (when (and (handempty) (obj-at o1 p4-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-2))))
                                       
          (when (and (handempty) (obj-at o2 p4-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p4-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-5))))
                                       
          (when (and (handempty) (obj-at o2 p4-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p4-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-6))))
                                       
          (when (and (handempty) (obj-at o2 p4-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-6))))
                                       
            ; X = 5
                ; Y = 2
          (when (and (handempty) (obj-at o1 p5-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-2))))
                                       
          (when (and (handempty) (obj-at o2 p5-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p5-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-3))))
                                       
          (when (and (handempty) (obj-at o2 p5-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p5-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-4))))
                                       
          (when (and (handempty) (obj-at o2 p5-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p5-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-5))))
                                       
          (when (and (handempty) (obj-at o2 p5-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p5-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-6))))
                                       
          (when (and (handempty) (obj-at o2 p5-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-6))))
                                       
            ; X = 6
                ; Y = 2
          (when (and (handempty) (obj-at o1 p6-2))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-2))))
                                       
          (when (and (handempty) (obj-at o2 p6-2))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-2))))
                                       
                ; Y = 3
          (when (and (handempty) (obj-at o1 p6-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-3))))
                                       
          (when (and (handempty) (obj-at o2 p6-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p6-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-4))))
                                       
          (when (and (handempty) (obj-at o2 p6-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p6-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-5))))
                                       
          (when (and (handempty) (obj-at o2 p6-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p6-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-6))))
                                       
          (when (and (handempty) (obj-at o2 p6-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-6))))
                                       ))

   (:action pickup-6-6-look-3
      :precondition (at p6-6) 
      :effect (and 
          (when (holding o1)
                (and (handempty) (not (holding o1)) (obj-at o1 p6-6)))
            
          (when (holding o2)
                (and (handempty) (not (holding o2)) (obj-at o2 p6-6)))
            
            ; X = 3
                ; Y = 3
          (when (and (handempty) (obj-at o1 p3-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-3))))
                                       
          (when (and (handempty) (obj-at o2 p3-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p3-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-4))))
                                       
          (when (and (handempty) (obj-at o2 p3-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p3-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-5))))
                                       
          (when (and (handempty) (obj-at o2 p3-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p3-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p3-6))))
                                       
          (when (and (handempty) (obj-at o2 p3-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p3-6))))
                                       
            ; X = 4
                ; Y = 3
          (when (and (handempty) (obj-at o1 p4-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-3))))
                                       
          (when (and (handempty) (obj-at o2 p4-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p4-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-4))))
                                       
          (when (and (handempty) (obj-at o2 p4-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p4-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-5))))
                                       
          (when (and (handempty) (obj-at o2 p4-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p4-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p4-6))))
                                       
          (when (and (handempty) (obj-at o2 p4-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p4-6))))
                                       
            ; X = 5
                ; Y = 3
          (when (and (handempty) (obj-at o1 p5-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-3))))
                                       
          (when (and (handempty) (obj-at o2 p5-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p5-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-4))))
                                       
          (when (and (handempty) (obj-at o2 p5-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p5-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-5))))
                                       
          (when (and (handempty) (obj-at o2 p5-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p5-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p5-6))))
                                       
          (when (and (handempty) (obj-at o2 p5-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p5-6))))
                                       
            ; X = 6
                ; Y = 3
          (when (and (handempty) (obj-at o1 p6-3))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-3))))
                                       
          (when (and (handempty) (obj-at o2 p6-3))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-3))))
                                       
                ; Y = 4
          (when (and (handempty) (obj-at o1 p6-4))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-4))))
                                       
          (when (and (handempty) (obj-at o2 p6-4))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-4))))
                                       
                ; Y = 5
          (when (and (handempty) (obj-at o1 p6-5))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-5))))
                                       
          (when (and (handempty) (obj-at o2 p6-5))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-5))))
                                       
                ; Y = 6
          (when (and (handempty) (obj-at o1 p6-6))
                (and (not (handempty)) (holding o1) (not (obj-at o1 p6-6))))
                                       
          (when (and (handempty) (obj-at o2 p6-6))
                (and (not (handempty)) (holding o2) (not (obj-at o2 p6-6))))
                                       ))

   (:action putdown
      :parameters (?p - pos)
      :precondition (at ?p)
      :effect (and 
                 (when (holding o1)
                       (and (handempty) (not (holding o1)) (obj-at o1 ?p)))
                       
                 (when (holding o2)
                       (and (handempty) (not (holding o2)) (obj-at o2 ?p)))
                       ))
      )

