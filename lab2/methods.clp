(defgeneric connect)
(defmethod connect ((?out ONE-OUTPUT)
(?in ONE-INPUT))

(send ?out put-output-1-link ?in)
(send ?out put-output-1-link-pin 1)
(send ?in put-input-1-link ?out)
(send ?in put-input-1-link-pin 1))
(defmethod connect ((?out ONE-OUTPUT)

(?in TWO-INPUT) (?in-pin INTEGER))

(send ?out put-output-1-link ?in)
(send ?out put-output-1-link-pin ?in-pin)
(send ?in (sym-cat put-input- ?in-pin -link) ?out)
(send ?in (sym-cat put-input- ?in-pin -link-pin) 1))
(defmethod connect ((?out TWO-OUTPUT)

(?out-pin INTEGER) (?in ONE-INPUT))

(send ?out (sym-cat put-output- ?out-pin -link) ?in)
(send ?out (sym-cat put-output- ?out-pin -link-pin) 1)
(send ?in put-input-1-link ?out)
(send ?in put-input-1-link-pin ?out-pin))
(defmethod connect ((?out TWO-OUTPUT)
(?out-pin INTEGER) (?in TWO-INPUT) (?in-pin INTEGER))
(send ?out (sym-cat put-output- ?out-pin -link) ?in)
(send ?out (sym-cat put-output- ?out-pin -link-pin)
?in-pin)
(send ?in (sym-cat put-input- ?in-pin -link) ?out)
(send ?in (sym-cat put-input- ?in-pin -link-pin)
?out-pin))

(deffunction connect-circuit ())

(defglobal ?*gray-code* =(create$)
?*sources* =(create$)
?*max-iterations* = 0)

(deffunction change-which-bit (?x)
(bind ?i 1)
(while (and (evenp ?x) (!= ?x 0)) do
(bind ?x (div ?x 2))
(bind ?i (+ ?i 1)))
?i)

(defrule startup
=>
(connect-circuit)

(bind ?*sources* (find-all-instances ((?x SOURCE)) TRUE))

(do-for-all-instances ((?x SOURCE)) TRUE
(bind ?*gray-code* (create$ ?*gray-code* 0) ) )
(bind ?*max-iterations* (round (** 2 (length$ ?*sources*))))

(assert (current-iteration 0)))

(defrule compute-response-1st-time
?f <- (current-iteration 0)

=>
(do-for-all-instances ((?source SOURCE)) TRUE
(send ?source put-output-1 0))

(assert (result ?*gray-code* =(implode$ (LED-response))))

(retract ?f)
(assert (current-iteration 1)))

(defrule compute-response-other-times

?f <- (current-iteration ?n&~0&:(< ?n ?*max-iterations*))

=>
(bind ?pos (change-which-bit ?n))
(bind ?nv (- 1 (nth$ ?pos ?*gray-code*)))
(bind ?*gray-code* (replace$ ?*gray-code* ?pos ?pos ?nv))

(send (nth$ ?pos ?*sources*) put-output-1 ?nv)

(assert (result ?*gray-code* =(implode$ (LED-response))))

(retract ?f)
(assert (current-iteration =(+ ?n 1))))

(defrule merge-responses
(declare (salience 10))
?fl <- (result $?b ?x $?e ?response)
?f2 <- (result $?b ~?x $?e ?response)
=>
(retract ?fl ?f2)
(assert (result ?b * ?e ?response)))

(defrule print-header
(declare (salience -10) )
=>
(do-for-all-instances ((?x SOURCE)) TRUE
(format t " %3s " (sym-cat ?x) ) )
(printout t " | ")
(do-for-all-instances ((?x LED)) TRUE
(format t " %3s " ( sym-cat ?x) ) )
(format t "%n")
(do-for-all-instances ((?x SOURCE)) TRUE
(printout t " ----"))
(printout t "-+-")
(do-for-all-instances ((?x LED)) TRUE
(printout t " ----"))
(format t "%n")
(assert (print-results)))

(defrule print-result
(print-results)
?f <- (result $?input ?response)
(not (result $?input-2 ?response-2&:
(< (str-compare ?response-2 ?response) 0) ) )
=>
(retract ?f)
(while (neq ?input (create$)) do
(printout t " " (nth$ 1 ?input) " ")
(bind ?input (rest$ ?input)))
(printout t " | ")
(bind ?response (explode$ ?response))
(while (neq ?response (create$)) do
(printout t " " (nth$ 1 ?response) " ")
(bind ?response (rest$ ?response)))
(printout t crlf))
