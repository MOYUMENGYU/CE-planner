
(define (problem ring-8)

  (:domain ring)

  (:objects win1 win2 win3 win4 win5 win6 win7 win8 pos1 pos2 pos3 pos4 pos5 pos6 pos7 pos8)

  (:init 

    (oneof   (position pos1)
	     (position pos2)
	     (position pos3)
	     (position pos4)
	     (position pos5)
	     (position pos6)     
	     (position pos7)     
	     (position pos8)     

    )


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


    (oneof   (open win6)
             (closed win6)
             (locked win6))


    (oneof   (open win7)
             (closed win7)
             (locked win7))


    (oneof   (open win8)
             (closed win8)
             (locked win8))

  )



(:goal 

(and 
	(locked win1) 
	(locked win2) 
	(locked win3)
	(locked win4)
	(locked win5)
	(locked win6)
	(locked win7)
	(locked win8)


)

)

)
