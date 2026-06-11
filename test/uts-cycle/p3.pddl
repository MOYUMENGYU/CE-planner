(define (problem uts_cycle_3)
 (:domain uts_cycle_3)
 (:objects l1 l2 - label)
 (:init 
 (oneof
   (and (at_node n0) (visited n0))
   (and (at_node n1) (visited n1))
   (and (at_node n2) (visited n2))
  )
  (oneof
   (and (edge_label n0 n1 l1) (edge_label n0 n2 l2))
   (and (edge_label n0 n1 l2) (edge_label n0 n2 l1))
  )
  (oneof
   (and (edge_label n1 n2 l1) (edge_label n1 n0 l2))
   (and (edge_label n1 n2 l2) (edge_label n1 n0 l1))
  )
  (oneof
   (and (edge_label n2 n0 l1) (edge_label n2 n1 l2))
   (and (edge_label n2 n0 l2) (edge_label n2 n1 l1))
  )
  
 )(:goal (and
        (visited n0)
        (visited n1)
        (visited n2)
       ))
)
