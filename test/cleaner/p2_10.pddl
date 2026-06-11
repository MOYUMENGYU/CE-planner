(define (problem cleaner-2-10)
  (:domain cleaner)
  (:objects
r0
r1
o0
o1
o2
o3
o4
o5
o6
o7
o8
o9
)
  (:init
(ROOM r0)
(ROOM r1)
(OBJECT o0)
(OBJECT o1)
(OBJECT o2)
(OBJECT o3)
(OBJECT o4)
(OBJECT o5)
(OBJECT o6)
(OBJECT o7)
(OBJECT o8)
(OBJECT o9)
(oneof (cleaned r0 o0) (not (cleaned r0 o0)))
(oneof (cleaned r0 o1) (not (cleaned r0 o1)))
(oneof (cleaned r0 o2) (not (cleaned r0 o2)))
(oneof (cleaned r0 o3) (not (cleaned r0 o3)))
(oneof (cleaned r0 o4) (not (cleaned r0 o4)))
(oneof (cleaned r0 o5) (not (cleaned r0 o5)))
(oneof (cleaned r0 o6) (not (cleaned r0 o6)))
(oneof (cleaned r0 o7) (not (cleaned r0 o7)))
(oneof (cleaned r0 o8) (not (cleaned r0 o8)))
(oneof (cleaned r0 o9) (not (cleaned r0 o9)))
(oneof (cleaned r1 o0) (not (cleaned r1 o0)))
(oneof (cleaned r1 o1) (not (cleaned r1 o1)))
(oneof (cleaned r1 o2) (not (cleaned r1 o2)))
(oneof (cleaned r1 o3) (not (cleaned r1 o3)))
(oneof (cleaned r1 o4) (not (cleaned r1 o4)))
(oneof (cleaned r1 o5) (not (cleaned r1 o5)))
(oneof (cleaned r1 o6) (not (cleaned r1 o6)))
(oneof (cleaned r1 o7) (not (cleaned r1 o7)))
(oneof (cleaned r1 o8) (not (cleaned r1 o8)))
(oneof (cleaned r1 o9) (not (cleaned r1 o9)))
(position r0)
)

(:goal 
(and 
(cleaned r0 o0 )
(cleaned r0 o1 )
(cleaned r0 o2 )
(cleaned r0 o3 )
(cleaned r0 o4 )
(cleaned r0 o5 )
(cleaned r0 o6 )
(cleaned r0 o7 )
(cleaned r0 o8 )
(cleaned r0 o9 )
(cleaned r1 o0 )
(cleaned r1 o1 )
(cleaned r1 o2 )
(cleaned r1 o3 )
(cleaned r1 o4 )
(cleaned r1 o5 )
(cleaned r1 o6 )
(cleaned r1 o7 )
(cleaned r1 o8 )
(cleaned r1 o9 )
)))