(define (problem b2)
  (:domain blocks)
  (:objects A B - block)
  (:init
     (oneof (handempty) (holding A) (holding B))          ; (holding ?x)
         (oneof (holding A) (clear A) (on B A))               ; (above A ?x)
         (oneof (holding A) (ontable A) (on A B))             ; (on A ?x)
         (oneof (holding B) (clear B) (on A B))               ; (above B ?x)
         (oneof (holding B) (ontable B) (on B A))             ; (on B ?x)


         (or (not (on A B)) (not (on B A)))                   ; cycles
    )
  
  (:goal (and (ontable A) (on B A)))
)
