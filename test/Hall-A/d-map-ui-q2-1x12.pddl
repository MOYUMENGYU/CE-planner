(define (domain hall)
  (:constants p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 p12)
  (:predicates (x-agent ?p) (y-agent ?p)
               (visited-A) (visited-B) (visited-C) (visited-D)
               (obsA)
               (not-obsA-q0)
               (obsA-q0-Right-q0)
               (obsA-q0-Right-q1)
               (obsA-q0-Left-q0)
               (obsA-q0-Left-q1)
               (not-obsA-q1)
               (obsA-q1-Right-q0)
               (obsA-q1-Right-q1)
               (obsA-q1-Left-q0)
               (obsA-q1-Left-q1)
               (obsB)
               (not-obsB-q0)
               (obsB-q0-Right-q0)
               (obsB-q0-Right-q1)
               (obsB-q0-Left-q0)
               (obsB-q0-Left-q1)
               (not-obsB-q1)
               (obsB-q1-Right-q0)
               (obsB-q1-Right-q1)
               (obsB-q1-Left-q0)
               (obsB-q1-Left-q1)
               (obs-)
               (not-obs--q0)
               (obs--q0-Right-q0)
               (obs--q0-Right-q1)
               (obs--q0-Left-q0)
               (obs--q0-Left-q1)
               (not-obs--q1)
               (obs--q1-Right-q0)
               (obs--q1-Right-q1)
               (obs--q1-Left-q0)
               (obs--q1-Left-q1)
               (q0)
               (q1)
  )
  (:action map-A-q0-Right-q0 :precondition (not-obsA-q0) :effect (and (not (not-obsA-q0)) (obsA-q0-Right-q0)) )
  (:action app-A-q0-Right-q0
    :precondition (obsA-q0-Right-q0)
    :effect (and (when (and (obsA) (q0) (x-agent p1) (y-agent p1)) (and (x-agent p2) (not (x-agent p1)) (not (obsA))))
                 
                 (when (and (obsA) (q0) (x-agent p2) (y-agent p1)) (and (x-agent p3) (not (x-agent p2)) (not (obsA))))
                 
                 (when (and (obsA) (q0) (x-agent p3) (y-agent p1)) (and (x-agent p4) (not (x-agent p3)) (not (obsA))))
                 
                 (when (and (obsA) (q0) (x-agent p4) (y-agent p1)) (and (x-agent p5) (not (x-agent p4)) (not (obsA))))
                 
                 (when (and (obsA) (q0) (x-agent p5) (y-agent p1)) (and (x-agent p6) (not (x-agent p5)) (not (obsA))))
                 
                 (when (and (obsA) (q0) (x-agent p6) (y-agent p1)) (and (x-agent p7) (not (x-agent p6)) (not (obsA))))
                 
                 (when (and (obsA) (q0) (x-agent p7) (y-agent p1)) (and (x-agent p8) (not (x-agent p7)) (not (obsA))))
                 
                 (when (and (obsA) (q0) (x-agent p8) (y-agent p1)) (and (x-agent p9) (not (x-agent p8)) (not (obsA))))
                 
                 (when (and (obsA) (q0) (x-agent p9) (y-agent p1)) (and (x-agent p10) (not (x-agent p9)) (not (obsA))))
                 
                 (when (and (obsA) (q0) (x-agent p10) (y-agent p1)) (and (x-agent p11) (not (x-agent p10)) (not (obsA))))
                 
                 (when (and (obsA) (q0) (x-agent p11) (y-agent p1)) (and (x-agent p12) (not (x-agent p11)) (not (obsA))))
                  ))
  (:action map-A-q0-Right-q1 :precondition (not-obsA-q0) :effect (and (not (not-obsA-q0)) (obsA-q0-Right-q1)) )
  (:action app-A-q0-Right-q1
    :precondition (obsA-q0-Right-q1)
    :effect (and (when (and (obsA) (q0) (x-agent p1) (y-agent p1)) (and (x-agent p2) (not (x-agent p1)) (not (obsA)) (not (q0)) (q1)))
                 
                 (when (and (obsA) (q0) (x-agent p2) (y-agent p1)) (and (x-agent p3) (not (x-agent p2)) (not (obsA)) (not (q0)) (q1)))
                 
                 (when (and (obsA) (q0) (x-agent p3) (y-agent p1)) (and (x-agent p4) (not (x-agent p3)) (not (obsA)) (not (q0)) (q1)))
                 
                 (when (and (obsA) (q0) (x-agent p4) (y-agent p1)) (and (x-agent p5) (not (x-agent p4)) (not (obsA)) (not (q0)) (q1)))
                 
                 (when (and (obsA) (q0) (x-agent p5) (y-agent p1)) (and (x-agent p6) (not (x-agent p5)) (not (obsA)) (not (q0)) (q1)))
                 
                 (when (and (obsA) (q0) (x-agent p6) (y-agent p1)) (and (x-agent p7) (not (x-agent p6)) (not (obsA)) (not (q0)) (q1)))
                 
                 (when (and (obsA) (q0) (x-agent p7) (y-agent p1)) (and (x-agent p8) (not (x-agent p7)) (not (obsA)) (not (q0)) (q1)))
                 
                 (when (and (obsA) (q0) (x-agent p8) (y-agent p1)) (and (x-agent p9) (not (x-agent p8)) (not (obsA)) (not (q0)) (q1)))
                 
                 (when (and (obsA) (q0) (x-agent p9) (y-agent p1)) (and (x-agent p10) (not (x-agent p9)) (not (obsA)) (not (q0)) (q1)))
                 
                 (when (and (obsA) (q0) (x-agent p10) (y-agent p1)) (and (x-agent p11) (not (x-agent p10)) (not (obsA)) (not (q0)) (q1)))
                 
                 (when (and (obsA) (q0) (x-agent p11) (y-agent p1)) (and (x-agent p12) (not (x-agent p11)) (not (obsA)) (not (q0)) (q1)))
                  ))
  (:action map-A-q1-Right-q0 :precondition (not-obsA-q1) :effect (and (not (not-obsA-q1)) (obsA-q1-Right-q0)) )
  (:action app-A-q1-Right-q0
    :precondition (obsA-q1-Right-q0)
    :effect (and (when (and (obsA) (q1) (x-agent p1) (y-agent p1)) (and (x-agent p2) (not (x-agent p1)) (not (obsA)) (not (q1)) (q0)))
                 
                 (when (and (obsA) (q1) (x-agent p2) (y-agent p1)) (and (x-agent p3) (not (x-agent p2)) (not (obsA)) (not (q1)) (q0)))
                 
                 (when (and (obsA) (q1) (x-agent p3) (y-agent p1)) (and (x-agent p4) (not (x-agent p3)) (not (obsA)) (not (q1)) (q0)))
                 
                 (when (and (obsA) (q1) (x-agent p4) (y-agent p1)) (and (x-agent p5) (not (x-agent p4)) (not (obsA)) (not (q1)) (q0)))
                 
                 (when (and (obsA) (q1) (x-agent p5) (y-agent p1)) (and (x-agent p6) (not (x-agent p5)) (not (obsA)) (not (q1)) (q0)))
                 
                 (when (and (obsA) (q1) (x-agent p6) (y-agent p1)) (and (x-agent p7) (not (x-agent p6)) (not (obsA)) (not (q1)) (q0)))
                 
                 (when (and (obsA) (q1) (x-agent p7) (y-agent p1)) (and (x-agent p8) (not (x-agent p7)) (not (obsA)) (not (q1)) (q0)))
                 
                 (when (and (obsA) (q1) (x-agent p8) (y-agent p1)) (and (x-agent p9) (not (x-agent p8)) (not (obsA)) (not (q1)) (q0)))
                 
                 (when (and (obsA) (q1) (x-agent p9) (y-agent p1)) (and (x-agent p10) (not (x-agent p9)) (not (obsA)) (not (q1)) (q0)))
                 
                 (when (and (obsA) (q1) (x-agent p10) (y-agent p1)) (and (x-agent p11) (not (x-agent p10)) (not (obsA)) (not (q1)) (q0)))
                 
                 (when (and (obsA) (q1) (x-agent p11) (y-agent p1)) (and (x-agent p12) (not (x-agent p11)) (not (obsA)) (not (q1)) (q0)))
                  ))
  (:action map-A-q1-Right-q1 :precondition (not-obsA-q1) :effect (and (not (not-obsA-q1)) (obsA-q1-Right-q1)) )
  (:action app-A-q1-Right-q1
    :precondition (obsA-q1-Right-q1)
    :effect (and (when (and (obsA) (q1) (x-agent p1) (y-agent p1)) (and (x-agent p2) (not (x-agent p1)) (not (obsA))))
                 
                 (when (and (obsA) (q1) (x-agent p2) (y-agent p1)) (and (x-agent p3) (not (x-agent p2)) (not (obsA))))
                 
                 (when (and (obsA) (q1) (x-agent p3) (y-agent p1)) (and (x-agent p4) (not (x-agent p3)) (not (obsA))))
                 
                 (when (and (obsA) (q1) (x-agent p4) (y-agent p1)) (and (x-agent p5) (not (x-agent p4)) (not (obsA))))
                 
                 (when (and (obsA) (q1) (x-agent p5) (y-agent p1)) (and (x-agent p6) (not (x-agent p5)) (not (obsA))))
                 
                 (when (and (obsA) (q1) (x-agent p6) (y-agent p1)) (and (x-agent p7) (not (x-agent p6)) (not (obsA))))
                 
                 (when (and (obsA) (q1) (x-agent p7) (y-agent p1)) (and (x-agent p8) (not (x-agent p7)) (not (obsA))))
                 
                 (when (and (obsA) (q1) (x-agent p8) (y-agent p1)) (and (x-agent p9) (not (x-agent p8)) (not (obsA))))
                 
                 (when (and (obsA) (q1) (x-agent p9) (y-agent p1)) (and (x-agent p10) (not (x-agent p9)) (not (obsA))))
                 
                 (when (and (obsA) (q1) (x-agent p10) (y-agent p1)) (and (x-agent p11) (not (x-agent p10)) (not (obsA))))
                 
                 (when (and (obsA) (q1) (x-agent p11) (y-agent p1)) (and (x-agent p12) (not (x-agent p11)) (not (obsA))))
                  ))
  (:action map---q0-Right-q0 :precondition (not-obs--q0) :effect (and (not (not-obs--q0)) (obs--q0-Right-q0)) )
  (:action app---q0-Right-q0
    :precondition (obs--q0-Right-q0)
    :effect (and (when (and (obs-) (q0) (x-agent p1) (y-agent p1)) (and (x-agent p2) (not (x-agent p1)) (not (obs-))))
                 
                 (when (and (obs-) (q0) (x-agent p2) (y-agent p1)) (and (x-agent p3) (not (x-agent p2)) (not (obs-))))
                 
                 (when (and (obs-) (q0) (x-agent p3) (y-agent p1)) (and (x-agent p4) (not (x-agent p3)) (not (obs-))))
                 
                 (when (and (obs-) (q0) (x-agent p4) (y-agent p1)) (and (x-agent p5) (not (x-agent p4)) (not (obs-))))
                 
                 (when (and (obs-) (q0) (x-agent p5) (y-agent p1)) (and (x-agent p6) (not (x-agent p5)) (not (obs-))))
                 
                 (when (and (obs-) (q0) (x-agent p6) (y-agent p1)) (and (x-agent p7) (not (x-agent p6)) (not (obs-))))
                 
                 (when (and (obs-) (q0) (x-agent p7) (y-agent p1)) (and (x-agent p8) (not (x-agent p7)) (not (obs-))))
                 
                 (when (and (obs-) (q0) (x-agent p8) (y-agent p1)) (and (x-agent p9) (not (x-agent p8)) (not (obs-))))
                 
                 (when (and (obs-) (q0) (x-agent p9) (y-agent p1)) (and (x-agent p10) (not (x-agent p9)) (not (obs-))))
                 
                 (when (and (obs-) (q0) (x-agent p10) (y-agent p1)) (and (x-agent p11) (not (x-agent p10)) (not (obs-))))
                 
                 (when (and (obs-) (q0) (x-agent p11) (y-agent p1)) (and (x-agent p12) (not (x-agent p11)) (not (obs-))))
                  ))
  (:action map---q0-Right-q1 :precondition (not-obs--q0) :effect (and (not (not-obs--q0)) (obs--q0-Right-q1)) )
  (:action app---q0-Right-q1
    :precondition (obs--q0-Right-q1)
    :effect (and (when (and (obs-) (q0) (x-agent p1) (y-agent p1)) (and (x-agent p2) (not (x-agent p1)) (not (obs-)) (not (q0)) (q1)))
                 
                 (when (and (obs-) (q0) (x-agent p2) (y-agent p1)) (and (x-agent p3) (not (x-agent p2)) (not (obs-)) (not (q0)) (q1)))
                 
                 (when (and (obs-) (q0) (x-agent p3) (y-agent p1)) (and (x-agent p4) (not (x-agent p3)) (not (obs-)) (not (q0)) (q1)))
                 
                 (when (and (obs-) (q0) (x-agent p4) (y-agent p1)) (and (x-agent p5) (not (x-agent p4)) (not (obs-)) (not (q0)) (q1)))
                 
                 (when (and (obs-) (q0) (x-agent p5) (y-agent p1)) (and (x-agent p6) (not (x-agent p5)) (not (obs-)) (not (q0)) (q1)))
                 
                 (when (and (obs-) (q0) (x-agent p6) (y-agent p1)) (and (x-agent p7) (not (x-agent p6)) (not (obs-)) (not (q0)) (q1)))
                 
                 (when (and (obs-) (q0) (x-agent p7) (y-agent p1)) (and (x-agent p8) (not (x-agent p7)) (not (obs-)) (not (q0)) (q1)))
                 
                 (when (and (obs-) (q0) (x-agent p8) (y-agent p1)) (and (x-agent p9) (not (x-agent p8)) (not (obs-)) (not (q0)) (q1)))
                 
                 (when (and (obs-) (q0) (x-agent p9) (y-agent p1)) (and (x-agent p10) (not (x-agent p9)) (not (obs-)) (not (q0)) (q1)))
                 
                 (when (and (obs-) (q0) (x-agent p10) (y-agent p1)) (and (x-agent p11) (not (x-agent p10)) (not (obs-)) (not (q0)) (q1)))
                 
                 (when (and (obs-) (q0) (x-agent p11) (y-agent p1)) (and (x-agent p12) (not (x-agent p11)) (not (obs-)) (not (q0)) (q1)))
                  ))
  (:action map---q1-Right-q0 :precondition (not-obs--q1) :effect (and (not (not-obs--q1)) (obs--q1-Right-q0)) )
  (:action app---q1-Right-q0
    :precondition (obs--q1-Right-q0)
    :effect (and (when (and (obs-) (q1) (x-agent p1) (y-agent p1)) (and (x-agent p2) (not (x-agent p1)) (not (obs-)) (not (q1)) (q0)))
                 
                 (when (and (obs-) (q1) (x-agent p2) (y-agent p1)) (and (x-agent p3) (not (x-agent p2)) (not (obs-)) (not (q1)) (q0)))
                 
                 (when (and (obs-) (q1) (x-agent p3) (y-agent p1)) (and (x-agent p4) (not (x-agent p3)) (not (obs-)) (not (q1)) (q0)))
                 
                 (when (and (obs-) (q1) (x-agent p4) (y-agent p1)) (and (x-agent p5) (not (x-agent p4)) (not (obs-)) (not (q1)) (q0)))
                 
                 (when (and (obs-) (q1) (x-agent p5) (y-agent p1)) (and (x-agent p6) (not (x-agent p5)) (not (obs-)) (not (q1)) (q0)))
                 
                 (when (and (obs-) (q1) (x-agent p6) (y-agent p1)) (and (x-agent p7) (not (x-agent p6)) (not (obs-)) (not (q1)) (q0)))
                 
                 (when (and (obs-) (q1) (x-agent p7) (y-agent p1)) (and (x-agent p8) (not (x-agent p7)) (not (obs-)) (not (q1)) (q0)))
                 
                 (when (and (obs-) (q1) (x-agent p8) (y-agent p1)) (and (x-agent p9) (not (x-agent p8)) (not (obs-)) (not (q1)) (q0)))
                 
                 (when (and (obs-) (q1) (x-agent p9) (y-agent p1)) (and (x-agent p10) (not (x-agent p9)) (not (obs-)) (not (q1)) (q0)))
                 
                 (when (and (obs-) (q1) (x-agent p10) (y-agent p1)) (and (x-agent p11) (not (x-agent p10)) (not (obs-)) (not (q1)) (q0)))
                 
                 (when (and (obs-) (q1) (x-agent p11) (y-agent p1)) (and (x-agent p12) (not (x-agent p11)) (not (obs-)) (not (q1)) (q0)))
                  ))
  (:action map---q1-Right-q1 :precondition (not-obs--q1) :effect (and (not (not-obs--q1)) (obs--q1-Right-q1)) )
  (:action app---q1-Right-q1
    :precondition (obs--q1-Right-q1)
    :effect (and (when (and (obs-) (q1) (x-agent p1) (y-agent p1)) (and (x-agent p2) (not (x-agent p1)) (not (obs-))))
                 
                 (when (and (obs-) (q1) (x-agent p2) (y-agent p1)) (and (x-agent p3) (not (x-agent p2)) (not (obs-))))
                 
                 (when (and (obs-) (q1) (x-agent p3) (y-agent p1)) (and (x-agent p4) (not (x-agent p3)) (not (obs-))))
                 
                 (when (and (obs-) (q1) (x-agent p4) (y-agent p1)) (and (x-agent p5) (not (x-agent p4)) (not (obs-))))
                 
                 (when (and (obs-) (q1) (x-agent p5) (y-agent p1)) (and (x-agent p6) (not (x-agent p5)) (not (obs-))))
                 
                 (when (and (obs-) (q1) (x-agent p6) (y-agent p1)) (and (x-agent p7) (not (x-agent p6)) (not (obs-))))
                 
                 (when (and (obs-) (q1) (x-agent p7) (y-agent p1)) (and (x-agent p8) (not (x-agent p7)) (not (obs-))))
                 
                 (when (and (obs-) (q1) (x-agent p8) (y-agent p1)) (and (x-agent p9) (not (x-agent p8)) (not (obs-))))
                 
                 (when (and (obs-) (q1) (x-agent p9) (y-agent p1)) (and (x-agent p10) (not (x-agent p9)) (not (obs-))))
                 
                 (when (and (obs-) (q1) (x-agent p10) (y-agent p1)) (and (x-agent p11) (not (x-agent p10)) (not (obs-))))
                 
                 (when (and (obs-) (q1) (x-agent p11) (y-agent p1)) (and (x-agent p12) (not (x-agent p11)) (not (obs-))))
                  ))
  (:action map-B-q0-Left-q0 :precondition (not-obsB-q0) :effect (and (not (not-obsB-q0)) (obsB-q0-Left-q0)) )
  (:action app-B-q0-Left-q0
    :precondition (obsB-q0-Left-q0)
    :effect (and (when (and (obsB) (q0) (x-agent p2) (y-agent p1)) (and (x-agent p1) (not (x-agent p2)) (not (obsB))))
                 
                 (when (and (obsB) (q0) (x-agent p3) (y-agent p1)) (and (x-agent p2) (not (x-agent p3)) (not (obsB))))
                 
                 (when (and (obsB) (q0) (x-agent p4) (y-agent p1)) (and (x-agent p3) (not (x-agent p4)) (not (obsB))))
                 
                 (when (and (obsB) (q0) (x-agent p5) (y-agent p1)) (and (x-agent p4) (not (x-agent p5)) (not (obsB))))
                 
                 (when (and (obsB) (q0) (x-agent p6) (y-agent p1)) (and (x-agent p5) (not (x-agent p6)) (not (obsB))))
                 
                 (when (and (obsB) (q0) (x-agent p7) (y-agent p1)) (and (x-agent p6) (not (x-agent p7)) (not (obsB))))
                 
                 (when (and (obsB) (q0) (x-agent p8) (y-agent p1)) (and (x-agent p7) (not (x-agent p8)) (not (obsB))))
                 
                 (when (and (obsB) (q0) (x-agent p9) (y-agent p1)) (and (x-agent p8) (not (x-agent p9)) (not (obsB))))
                 
                 (when (and (obsB) (q0) (x-agent p10) (y-agent p1)) (and (x-agent p9) (not (x-agent p10)) (not (obsB))))
                 
                 (when (and (obsB) (q0) (x-agent p11) (y-agent p1)) (and (x-agent p10) (not (x-agent p11)) (not (obsB))))
                 
                 (when (and (obsB) (q0) (x-agent p12) (y-agent p1)) (and (x-agent p11) (not (x-agent p12)) (not (obsB))))
                  ))
  (:action map-B-q0-Left-q1 :precondition (not-obsB-q0) :effect (and (not (not-obsB-q0)) (obsB-q0-Left-q1)) )
  (:action app-B-q0-Left-q1
    :precondition (obsB-q0-Left-q1)
    :effect (and (when (and (obsB) (q0) (x-agent p2) (y-agent p1)) (and (x-agent p1) (not (x-agent p2)) (not (obsB)) (not (q0)) (q1)))
                 
                 (when (and (obsB) (q0) (x-agent p3) (y-agent p1)) (and (x-agent p2) (not (x-agent p3)) (not (obsB)) (not (q0)) (q1)))
                 
                 (when (and (obsB) (q0) (x-agent p4) (y-agent p1)) (and (x-agent p3) (not (x-agent p4)) (not (obsB)) (not (q0)) (q1)))
                 
                 (when (and (obsB) (q0) (x-agent p5) (y-agent p1)) (and (x-agent p4) (not (x-agent p5)) (not (obsB)) (not (q0)) (q1)))
                 
                 (when (and (obsB) (q0) (x-agent p6) (y-agent p1)) (and (x-agent p5) (not (x-agent p6)) (not (obsB)) (not (q0)) (q1)))
                 
                 (when (and (obsB) (q0) (x-agent p7) (y-agent p1)) (and (x-agent p6) (not (x-agent p7)) (not (obsB)) (not (q0)) (q1)))
                 
                 (when (and (obsB) (q0) (x-agent p8) (y-agent p1)) (and (x-agent p7) (not (x-agent p8)) (not (obsB)) (not (q0)) (q1)))
                 
                 (when (and (obsB) (q0) (x-agent p9) (y-agent p1)) (and (x-agent p8) (not (x-agent p9)) (not (obsB)) (not (q0)) (q1)))
                 
                 (when (and (obsB) (q0) (x-agent p10) (y-agent p1)) (and (x-agent p9) (not (x-agent p10)) (not (obsB)) (not (q0)) (q1)))
                 
                 (when (and (obsB) (q0) (x-agent p11) (y-agent p1)) (and (x-agent p10) (not (x-agent p11)) (not (obsB)) (not (q0)) (q1)))
                 
                 (when (and (obsB) (q0) (x-agent p12) (y-agent p1)) (and (x-agent p11) (not (x-agent p12)) (not (obsB)) (not (q0)) (q1)))
                  ))
  (:action map-B-q1-Left-q0 :precondition (not-obsB-q1) :effect (and (not (not-obsB-q1)) (obsB-q1-Left-q0)) )
  (:action app-B-q1-Left-q0
    :precondition (obsB-q1-Left-q0)
    :effect (and (when (and (obsB) (q1) (x-agent p2) (y-agent p1)) (and (x-agent p1) (not (x-agent p2)) (not (obsB)) (not (q1)) (q0)))
                 
                 (when (and (obsB) (q1) (x-agent p3) (y-agent p1)) (and (x-agent p2) (not (x-agent p3)) (not (obsB)) (not (q1)) (q0)))
                 
                 (when (and (obsB) (q1) (x-agent p4) (y-agent p1)) (and (x-agent p3) (not (x-agent p4)) (not (obsB)) (not (q1)) (q0)))
                 
                 (when (and (obsB) (q1) (x-agent p5) (y-agent p1)) (and (x-agent p4) (not (x-agent p5)) (not (obsB)) (not (q1)) (q0)))
                 
                 (when (and (obsB) (q1) (x-agent p6) (y-agent p1)) (and (x-agent p5) (not (x-agent p6)) (not (obsB)) (not (q1)) (q0)))
                 
                 (when (and (obsB) (q1) (x-agent p7) (y-agent p1)) (and (x-agent p6) (not (x-agent p7)) (not (obsB)) (not (q1)) (q0)))
                 
                 (when (and (obsB) (q1) (x-agent p8) (y-agent p1)) (and (x-agent p7) (not (x-agent p8)) (not (obsB)) (not (q1)) (q0)))
                 
                 (when (and (obsB) (q1) (x-agent p9) (y-agent p1)) (and (x-agent p8) (not (x-agent p9)) (not (obsB)) (not (q1)) (q0)))
                 
                 (when (and (obsB) (q1) (x-agent p10) (y-agent p1)) (and (x-agent p9) (not (x-agent p10)) (not (obsB)) (not (q1)) (q0)))
                 
                 (when (and (obsB) (q1) (x-agent p11) (y-agent p1)) (and (x-agent p10) (not (x-agent p11)) (not (obsB)) (not (q1)) (q0)))
                 
                 (when (and (obsB) (q1) (x-agent p12) (y-agent p1)) (and (x-agent p11) (not (x-agent p12)) (not (obsB)) (not (q1)) (q0)))
                  ))
  (:action map-B-q1-Left-q1 :precondition (not-obsB-q1) :effect (and (not (not-obsB-q1)) (obsB-q1-Left-q1)) )
  (:action app-B-q1-Left-q1
    :precondition (obsB-q1-Left-q1)
    :effect (and (when (and (obsB) (q1) (x-agent p2) (y-agent p1)) (and (x-agent p1) (not (x-agent p2)) (not (obsB))))
                 
                 (when (and (obsB) (q1) (x-agent p3) (y-agent p1)) (and (x-agent p2) (not (x-agent p3)) (not (obsB))))
                 
                 (when (and (obsB) (q1) (x-agent p4) (y-agent p1)) (and (x-agent p3) (not (x-agent p4)) (not (obsB))))
                 
                 (when (and (obsB) (q1) (x-agent p5) (y-agent p1)) (and (x-agent p4) (not (x-agent p5)) (not (obsB))))
                 
                 (when (and (obsB) (q1) (x-agent p6) (y-agent p1)) (and (x-agent p5) (not (x-agent p6)) (not (obsB))))
                 
                 (when (and (obsB) (q1) (x-agent p7) (y-agent p1)) (and (x-agent p6) (not (x-agent p7)) (not (obsB))))
                 
                 (when (and (obsB) (q1) (x-agent p8) (y-agent p1)) (and (x-agent p7) (not (x-agent p8)) (not (obsB))))
                 
                 (when (and (obsB) (q1) (x-agent p9) (y-agent p1)) (and (x-agent p8) (not (x-agent p9)) (not (obsB))))
                 
                 (when (and (obsB) (q1) (x-agent p10) (y-agent p1)) (and (x-agent p9) (not (x-agent p10)) (not (obsB))))
                 
                 (when (and (obsB) (q1) (x-agent p11) (y-agent p1)) (and (x-agent p10) (not (x-agent p11)) (not (obsB))))
                 
                 (when (and (obsB) (q1) (x-agent p12) (y-agent p1)) (and (x-agent p11) (not (x-agent p12)) (not (obsB))))
                  ))
  (:action map---q0-Left-q0 :precondition (not-obs--q0) :effect (and (not (not-obs--q0)) (obs--q0-Left-q0)) )
  (:action app---q0-Left-q0
    :precondition (obs--q0-Left-q0)
    :effect (and (when (and (obs-) (q0) (x-agent p2) (y-agent p1)) (and (x-agent p1) (not (x-agent p2)) (not (obs-))))
                 
                 (when (and (obs-) (q0) (x-agent p3) (y-agent p1)) (and (x-agent p2) (not (x-agent p3)) (not (obs-))))
                 
                 (when (and (obs-) (q0) (x-agent p4) (y-agent p1)) (and (x-agent p3) (not (x-agent p4)) (not (obs-))))
                 
                 (when (and (obs-) (q0) (x-agent p5) (y-agent p1)) (and (x-agent p4) (not (x-agent p5)) (not (obs-))))
                 
                 (when (and (obs-) (q0) (x-agent p6) (y-agent p1)) (and (x-agent p5) (not (x-agent p6)) (not (obs-))))
                 
                 (when (and (obs-) (q0) (x-agent p7) (y-agent p1)) (and (x-agent p6) (not (x-agent p7)) (not (obs-))))
                 
                 (when (and (obs-) (q0) (x-agent p8) (y-agent p1)) (and (x-agent p7) (not (x-agent p8)) (not (obs-))))
                 
                 (when (and (obs-) (q0) (x-agent p9) (y-agent p1)) (and (x-agent p8) (not (x-agent p9)) (not (obs-))))
                 
                 (when (and (obs-) (q0) (x-agent p10) (y-agent p1)) (and (x-agent p9) (not (x-agent p10)) (not (obs-))))
                 
                 (when (and (obs-) (q0) (x-agent p11) (y-agent p1)) (and (x-agent p10) (not (x-agent p11)) (not (obs-))))
                 
                 (when (and (obs-) (q0) (x-agent p12) (y-agent p1)) (and (x-agent p11) (not (x-agent p12)) (not (obs-))))
                  ))
  (:action map---q0-Left-q1 :precondition (not-obs--q0) :effect (and (not (not-obs--q0)) (obs--q0-Left-q1)) )
  (:action app---q0-Left-q1
    :precondition (obs--q0-Left-q1)
    :effect (and (when (and (obs-) (q0) (x-agent p2) (y-agent p1)) (and (x-agent p1) (not (x-agent p2)) (not (obs-)) (not (q0)) (q1)))
                 
                 (when (and (obs-) (q0) (x-agent p3) (y-agent p1)) (and (x-agent p2) (not (x-agent p3)) (not (obs-)) (not (q0)) (q1)))
                 
                 (when (and (obs-) (q0) (x-agent p4) (y-agent p1)) (and (x-agent p3) (not (x-agent p4)) (not (obs-)) (not (q0)) (q1)))
                 
                 (when (and (obs-) (q0) (x-agent p5) (y-agent p1)) (and (x-agent p4) (not (x-agent p5)) (not (obs-)) (not (q0)) (q1)))
                 
                 (when (and (obs-) (q0) (x-agent p6) (y-agent p1)) (and (x-agent p5) (not (x-agent p6)) (not (obs-)) (not (q0)) (q1)))
                 
                 (when (and (obs-) (q0) (x-agent p7) (y-agent p1)) (and (x-agent p6) (not (x-agent p7)) (not (obs-)) (not (q0)) (q1)))
                 
                 (when (and (obs-) (q0) (x-agent p8) (y-agent p1)) (and (x-agent p7) (not (x-agent p8)) (not (obs-)) (not (q0)) (q1)))
                 
                 (when (and (obs-) (q0) (x-agent p9) (y-agent p1)) (and (x-agent p8) (not (x-agent p9)) (not (obs-)) (not (q0)) (q1)))
                 
                 (when (and (obs-) (q0) (x-agent p10) (y-agent p1)) (and (x-agent p9) (not (x-agent p10)) (not (obs-)) (not (q0)) (q1)))
                 
                 (when (and (obs-) (q0) (x-agent p11) (y-agent p1)) (and (x-agent p10) (not (x-agent p11)) (not (obs-)) (not (q0)) (q1)))
                 
                 (when (and (obs-) (q0) (x-agent p12) (y-agent p1)) (and (x-agent p11) (not (x-agent p12)) (not (obs-)) (not (q0)) (q1)))
                  ))
  (:action map---q1-Left-q0 :precondition (not-obs--q1) :effect (and (not (not-obs--q1)) (obs--q1-Left-q0)) )
  (:action app---q1-Left-q0
    :precondition (obs--q1-Left-q0)
    :effect (and (when (and (obs-) (q1) (x-agent p2) (y-agent p1)) (and (x-agent p1) (not (x-agent p2)) (not (obs-)) (not (q1)) (q0)))
                 
                 (when (and (obs-) (q1) (x-agent p3) (y-agent p1)) (and (x-agent p2) (not (x-agent p3)) (not (obs-)) (not (q1)) (q0)))
                 
                 (when (and (obs-) (q1) (x-agent p4) (y-agent p1)) (and (x-agent p3) (not (x-agent p4)) (not (obs-)) (not (q1)) (q0)))
                 
                 (when (and (obs-) (q1) (x-agent p5) (y-agent p1)) (and (x-agent p4) (not (x-agent p5)) (not (obs-)) (not (q1)) (q0)))
                 
                 (when (and (obs-) (q1) (x-agent p6) (y-agent p1)) (and (x-agent p5) (not (x-agent p6)) (not (obs-)) (not (q1)) (q0)))
                 
                 (when (and (obs-) (q1) (x-agent p7) (y-agent p1)) (and (x-agent p6) (not (x-agent p7)) (not (obs-)) (not (q1)) (q0)))
                 
                 (when (and (obs-) (q1) (x-agent p8) (y-agent p1)) (and (x-agent p7) (not (x-agent p8)) (not (obs-)) (not (q1)) (q0)))
                 
                 (when (and (obs-) (q1) (x-agent p9) (y-agent p1)) (and (x-agent p8) (not (x-agent p9)) (not (obs-)) (not (q1)) (q0)))
                 
                 (when (and (obs-) (q1) (x-agent p10) (y-agent p1)) (and (x-agent p9) (not (x-agent p10)) (not (obs-)) (not (q1)) (q0)))
                 
                 (when (and (obs-) (q1) (x-agent p11) (y-agent p1)) (and (x-agent p10) (not (x-agent p11)) (not (obs-)) (not (q1)) (q0)))
                 
                 (when (and (obs-) (q1) (x-agent p12) (y-agent p1)) (and (x-agent p11) (not (x-agent p12)) (not (obs-)) (not (q1)) (q0)))
                  ))
  (:action map---q1-Left-q1 :precondition (not-obs--q1) :effect (and (not (not-obs--q1)) (obs--q1-Left-q1)) )
  (:action app---q1-Left-q1
    :precondition (obs--q1-Left-q1)
    :effect (and (when (and (obs-) (q1) (x-agent p2) (y-agent p1)) (and (x-agent p1) (not (x-agent p2)) (not (obs-))))
                 
                 (when (and (obs-) (q1) (x-agent p3) (y-agent p1)) (and (x-agent p2) (not (x-agent p3)) (not (obs-))))
                 
                 (when (and (obs-) (q1) (x-agent p4) (y-agent p1)) (and (x-agent p3) (not (x-agent p4)) (not (obs-))))
                 
                 (when (and (obs-) (q1) (x-agent p5) (y-agent p1)) (and (x-agent p4) (not (x-agent p5)) (not (obs-))))
                 
                 (when (and (obs-) (q1) (x-agent p6) (y-agent p1)) (and (x-agent p5) (not (x-agent p6)) (not (obs-))))
                 
                 (when (and (obs-) (q1) (x-agent p7) (y-agent p1)) (and (x-agent p6) (not (x-agent p7)) (not (obs-))))
                 
                 (when (and (obs-) (q1) (x-agent p8) (y-agent p1)) (and (x-agent p7) (not (x-agent p8)) (not (obs-))))
                 
                 (when (and (obs-) (q1) (x-agent p9) (y-agent p1)) (and (x-agent p8) (not (x-agent p9)) (not (obs-))))
                 
                 (when (and (obs-) (q1) (x-agent p10) (y-agent p1)) (and (x-agent p9) (not (x-agent p10)) (not (obs-))))
                 
                 (when (and (obs-) (q1) (x-agent p11) (y-agent p1)) (and (x-agent p10) (not (x-agent p11)) (not (obs-))))
                 
                 (when (and (obs-) (q1) (x-agent p12) (y-agent p1)) (and (x-agent p11) (not (x-agent p12)) (not (obs-))))
                  ))
  (:action zoom
    :effect (and (when (and (x-agent p1) (y-agent p1)) (obsA))
                 (when (and (x-agent p2) (y-agent p1)) (obs-))
                 (when (and (x-agent p3) (y-agent p1)) (obs-))
                 (when (and (x-agent p4) (y-agent p1)) (obs-))
                 (when (and (x-agent p5) (y-agent p1)) (obs-))
                 (when (and (x-agent p6) (y-agent p1)) (obs-))
                 (when (and (x-agent p7) (y-agent p1)) (obs-))
                 (when (and (x-agent p8) (y-agent p1)) (obs-))
                 (when (and (x-agent p9) (y-agent p1)) (obs-))
                 (when (and (x-agent p10) (y-agent p1)) (obs-))
                 (when (and (x-agent p11) (y-agent p1)) (obs-))
                 (when (and (x-agent p12) (y-agent p1)) (obsB))
                 (when (and (x-agent p1) (y-agent p1)) (visited-A))
                 (when (and (x-agent p12) (y-agent p1)) (visited-B)) ))
)
