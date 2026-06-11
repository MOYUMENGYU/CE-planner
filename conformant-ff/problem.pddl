(define (problem robot-problem)
  (:domain robot)
  (:objects
    robot1
    room1 room2
  )
  (:init (at robot1 room1))
  (:goal (at robot1 room2))
)
