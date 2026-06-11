
(define (problem ring-3)

  (:domain ring)

  (:objects win1 win2 win3 win4 win5 pos1 pos2 pos3 pos4 pos5)

  (:init 

    (oneof   (position pos1)
	     (position pos2)
	     (position pos3)
	     (position pos4)
	     (position pos5))


    (oneof   (open win1)
             (closed win1)
             (locked win1))



    (oneof   (open win2)
             (closed win2)
             (locked win2))


    (oneof   (open win3)
             (closed win3)
             (locked win3))


    (oneof   (open win4)
             (closed win4)
             (locked win4))


    (oneof   (open win5)
             (closed win5)
             (locked win5))
	)



(:goal 

(and 
	(locked win1) 
	(locked win2) 
	(locked win3)
	(locked win4)
	(locked win5)
)

)

)
