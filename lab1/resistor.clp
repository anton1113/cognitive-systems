(deffacts resistors
(resistor Ra 2)
(resistor Rb 5)
(resistor Rc 7))

(deffacts initial-fact
   (initial-fact))

(deffunction om
(?x ?y)
(div ?y ?x))

(defrule input
(initial-fact)
=>
(printout t crlf "Input current value: ")
(bind ?i (read))
(printout t "Input voltage value: ")
(bind ?u (read))
(assert (numbers ?i ?u)))

(defrule take
(numbers ?i ?u)
(resistor ?r =(om ?i ?u))
=>
(printout t crlf "You must take resistor " ?r crlf crlf)
(reset)
(halt))

(defrule nothing
(numbers ?i ?u)
(resistor ?r ~=(om ?i ?u))
=>
(printout t crlf "There is nothing for You in my database!" crlf crlf)
(reset)
(halt))