
(define (problem cube-cube-d19-g9)
 (:domain cube)
 (:init


      (oneof (x p1) (x p2) (x p3) (x p4) (x p5) (x p6) (x p7) (x p8) (x p9) (x p10) (x p11) (x p12) (x p13) (x p14) (x p15) (x p16) (x p17) (x p18) (x p19) 
      ) 
      (oneof (y p1) (y p2) (y p3) (y p4) (y p5) (y p6) (y p7) (y p8) (y p9) (y p10) (y p11) (y p12) (y p13) (y p14) (y p15) (y p16) (y p17) (y p18) (y p19) 
      ) 
      (oneof (z p1) (z p2) (z p3) (z p4) (z p5) (z p6) (z p7) (z p8) (z p9) (z p10) (z p11) (z p12) (z p13) (z p14) (z p15) (z p16) (z p17) (z p18) (z p19) 
      ) 
       )
 (:goal
       (and (x p10)(y p10)(z p10))
       ))

