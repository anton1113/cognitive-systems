(defglobal ?*odesa* = 0)
(defglobal ?*kiev* = 0)
(defglobal ?*kharkiv* = 0)
(defrule start
(initial-fact)
=>
(printout t crlf «REPRESENTATIVES» crlf))

(defrule odesa
(rep ? Odesa)
=>
(bind ?*odesa* (+ ?*odesa* 1)))

(defrule kiev
(rep ? Kiev)
=>
(bind ?*kiev* (+ ?*kiev* 1)))

(defrule kharkiv
(rep ? Kharkiv)
=>
(bind ?*kharkiv* (+ ?*kharkiv* 1)))

(defrule result
(declare (salience -1))
(initial-fact)
=>
(printout t «from Odesa:» ?*odesa* crlf)
(printout t «from Kiev:» ?*kiev* crlf)
(printout t «from Kharkiv:» ?*kharkiv* crlf))