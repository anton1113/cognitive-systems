(deffacts initial-fact
   (initial-fact))

(defglobal ?*DayAndMonthSearch* = 1)
(defglobal ?*MonthSearch* = 2)
(defglobal ?*ResponsibleSearch* = 3)

(deffacts event; Event Name Responsible Day Month Accountability
(event "Block assembly" Starosts of blocs 3 may Chairman)
(event "General Faculty Meeting " Chairman 5 may Decan)
(event "Subbotnik " Chairman 29 april Comendant)

(event "Subbotnik " Chairman 6 may Comendant)
(event "Checking the status of the block " Chairman 4 may Comendant)
(event "Checking the status of the block " Comendan 10 may Decan)
(event "Arrival of debtors " Chairman 11 may Comendant)
(event "Collecting problems " Chairman 4 may Comendant)
(event "Collecting problems " Chairman 26 may Decan)
(event "Cleaning of hostel " Deputy chairman 15 may Comendant)
(event "Disinfection of premises " Deputy chairman 1 june Comendant)
)

(defclass Event (is-a USER)
(role concrete)
(slot eventName (create-accessor read-write); title of the event
(override-message name-put))
(slot responsible (create-accessor read-write); responsible for holding the event
(override-message responsible-put))
(slot day (create-accessor read-write); day of the event
(override-message day-put))
(slot month (create-accessor read-write); month of the event
(override-message month-put))
(slot accountability (create-accessor read-write); who to provide a report of the event
(override-message accountability-put))
(message-handler name-put)
(message-handler responsible-put)
(message-handler day-put)
(message-handler month-put)
(message-handler accountability-put)
(message-handler print))

(defmessage-handler Event name-put primary (?value); handler for editing the name slot value
(bind ?self:eventName ?value))

(defmessage-handler Event responsible-put (?value); handler for editing the responsible slot value
(bind ?self:responsible ?value))

(defmessage-handler Event day-put (?value); handler for editing the slot value of the day
(bind ?self:day ?value))

(defmessage-handler Event month-put (?value); handler for editing the month slot value
(bind ?self:month ?value))

(defmessage-handler Event accountability-put (?value); handler for editing the reporting slot value
(bind ?self:accountability ?value))

(defmessage-handler Event print ()
(printout t " Event '" ?self:eventName "' will take place "
?self:day ?self:month ". Responsible is appointed "
?self:responsible ". Report must be provided "
?self:accountability "." crlf))

(defrule mainrule; The rule displaying the program menu
(initial-fact)
=>
(printout t "Menu" crlf)
(printout t "1. Find event by day and month" crlf)
(printout t "2. Find event by month" crlf)
(printout t "3. Find event by responsible" crlf)
(printout t crlf "Input menu choice: ")
(bind ?menu (read)); Enter a menu item
(if (integerp ?menu) then; If the input value is an integer, then
(assert (menu ?menu)))); add menu fact in the database;

(defrule menurule; Rule for managing the menu
(menu ?m)
=>
(switch ?m; If user choose day and month search
(case ?*DayAndMonthSearch* then
(printout t crlf " Enter the day of the event:")

(bind ?d (read))

(printout t crlf " Enter the month of the event:")

(bind ?mon (read))
(printout t crlf " List of events:" crlf crlf)
(assert (gdaymon ?d ?mon))); If user choosed to search only month of activity
(case ?*MonthSearch* then
(printout t crlf " Enter the month of the event:")

(bind ?mon (read))
(printout t crlf " List of events:" crlf crlf)
(assert (gmon ?mon))); If user choosed by a responsible chief who should provide a report on the activity

(case ?*ResponsibleSearch* then
(printout t crlf " Enter the responsible

person of the event (Comendant/Chairman/Deputy
chairman/Starosts of blocs): ")
(bind ?r (read))
(printout t crlf " List of events:" crlf crlf)
(assert (gresponsible ?r)))))

(defrule findEventByDayAndMonth; The rule for finding an event by day and month
(gdaymon ?findday ?findmonth)
(event ?evname ?res ?day ?month ?account)
=>
(make-instance ev of Event (eventName ?evname)

(responsible ?res) (day ?day) (month ?month)
(accountability ?account))
(if (and (eq ?findday ?day)(eq ?findmonth ?month))
then

(send [ev] print))); Use the print handler to display information

(defrule findEventByMonth; The rule of the search for the event by month
(gmon ?findmonth)
(event ?evname ?res ?day ?month ?account)

=>
(if (eq ?findmonth ?month) then
(make-instance ev of Event (eventName ?evname)

(responsible ?res) (day ?day) (month ?month)
(accountability ?account))
(send [ev] print))); Use the print handler to display information

(defrule findEventByResponsible; The rule of the search for the event on the responsible person
(gresponsible ?findresponsible)
(event ?evname ?res ?day ?month ?account)
=>
(if (eq ?findresponsible ?res) then
(make-instance ev of Event (eventName ?evname)
(responsible ?res) (day ?day) (month ?month)
(accountability ?account))
(send [ev] print))); Use the print handler to display information.