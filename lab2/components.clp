(defclass COMPONENT
(is-a USER)
(slot ID# (create-accessor write)))

(defclass NO-OUTPUT
(is-a USER)
(slot number-of-outputs (access read-only)

(default 0)
(create-accessor read) ) )

(defmessage-handler NO-OUTPUT compute-output ( ) )

(defclass ONE-OUTPUT
(is-a NO-OUTPUT)
(slot number-of-outputs (access read-only)
(default 1)
(create-accessor read) )
(slot output-1 (default UNDEFINED)
(create-accessor write) )
(slot output-1-link (default GROUND)
(create-accessor write) )
(slot output-1-link-pin (default 1)
(create-accessor write) ) )

(defmessage-handler ONE-OUTPUT put-output-1 after
(?value)
(send ?self:output-1-link
(sym-cat put-input- ?self:output-1-link-pin)
?value))

(defclass TWO-OUTPUT
(is-a ONE-OUTPUT)
(slot number-of-outputs (access read-only)
(default 2)

(create-accessor read) )
(slot output-2
(default UNDEFINED)
(create-accessor write) )
(slot output-2-link
(default GROUND)
(create-accessor write) )
(slot output-2-link-pin
(default 1)
(create-accessor write) ) )

(defmessage-handler TWO-OUTPUT put-output-2 after
(?value)
(send ?self:output-2-link
(sym-cat put-input- ?self:output-2-link-pin)
?value))

(defclass NO-INPUT
(is-a USER)
(slot number-of-inputs
(access read-only)
(default 0)
(create-accessor read)))

(defclass ONE-INPUT
(is-a NO-INPUT)
(slot number-of-inputs (access read-only)
(default 1)
(create-accessor read))
(slot input-1 (default UNDEFINED)
(visibility public)
(create-accessor read-write))
(slot input-1-link
(default GROUND)
(create-accessor write))
(slot input-1-link-pin
(default 1)
(create-accessor write)))

(defmessage-handler ONE-INPUT put-input-1 after
(?value)
(send ?self compute-output))

(defclass TWO-INPUT (is-a ONE-INPUT)
(slot number-of-inputs (access read-only)
(default 2)
(create-accessor read) )
(slot input-2 (default UNDEFINED)
(visibility public)
(create-accessor write) )
(slot input-2-link (default GROUND)
(create-accessor write) )
(slot input-2-link-pin
(default 1)
(create-accessor write) ) )

(defmessage-handler TWO-INPUT put-input-2 after
(?value)
(send ?self compute-output))

(defclass SOURCE
(is-a NO-INPUT ONE-OUTPUT COMPONENT)
(role concrete)
(slot output-1
(default UNDEFINED)
(create-accessor write)) )

(defclass LED
(is-a ONE-INPUT NO-OUTPUT COMPONENT)
(role concrete))

(deffunction LED-response ()
(bind ?response (create$))
(do-for-all-instances ((?led LED)) TRUE
(bind ?response (create$ ?response
(send ?led get-input-1))))
?response)

(defclass NOT-GATE
(is-a ONE-INPUT ONE-OUTPUT COMPONENT)
(role concrete))
(deffunction not# (?x) (- 1 ?x))
(defmessage-handler NOT-GATE compute-output ()
(if (integerp ?self:input-1) then
(send ?self put-output-1 (not# ?self:input-1))))

(defclass AND-GATE
(is-a TWO-INPUT ONE-OUTPUT COMPONENT)
(role concrete))
(deffunction and# (?x ?y)
(if (and (!= ?x 0) (!= ?y 0)) then 1 else 0))
(defmessage-handler AND-GATE compute-output ()
(if (and (integerp ?self:input-1)
(integerp ?self:input-2) ) then
(send ?self put-output-1
(and# ?self:input-1 ?self:input-2))))

(defclass OR-GATE
(is-a TWO-INPUT ONE-OUTPUT COMPONENT)
 
(role concrete))
(deffunction or# (?x ?y)
(if (or (!= ?x 0) (!= ?y 0)) then 1 else 0))
(defmessage-handler OR-GATE compute-output ()
(if (and (integerp ?self:input-1)
(integerp ?self:input-2) ) then
(send ?self put-output-1
(or# ?self:input-1 ?self:input-2))))

(defclass NAND-GATE
 
(is-a TWO-INPUT ONE-OUTPUT COMPONENT)
(role concrete))
(deffunction nand# (?x ?y)
(if (not (and (!= ?x 0) (!= ?y 0))) then 1 else 0))
(defmessage-handler NAND-GATE compute-output ()
(if (and (integerp ?self:input-1)
(integerp ?self:input-2 )) then
(send ?self put-output-1
(nand# ?self:input-1 ?self:input-2))))

(defclass XOR-GATE
 
(is-a TWO-INPUT ONE-OUTPUT COMPONENT)
(role concrete))
(deffunction xor# (?x ?y)
 
(if (or (and (= ?x 1) (= ?y 0))
(and (= ?x 0) (= ?y 1))) then 1 else 0))
(defmessage-handler XOR-GATE compute-output ()
(if (and (integerp ?self:input-1)
(integerp ?self:input-2)) then
(send ?self put-output-1
(xor# ?self:input-1 ?self:input-2))))

(defclass SPLITTER
 
(is-a ONE-INPUT TWO-OUTPUT COMPONENT)
(role concrete))
 
(defmessage-handler SPLITTER compute-output ()
(if (integerp ?self:input-1) then
(send ?self put-output-1 ?self:input-1)
(send ?self put-output-2 ?self:input-1)))