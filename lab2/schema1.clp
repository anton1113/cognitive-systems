(definstances circuit
(S-1 of SOURCE)
(S-2 of SOURCE)
(P-1 of SPLITTER)
(P-2 of SPLITTER)
(N-1 of NOT-GATE)
(O-1 of OR-GATE)
(X-1 of XOR-GATE)
(L-1 of LED)
(L-2 of LED))

(deffunction connect-circuit()
(connect [S-1] [P-1])
(connect [S-2] [X-1] 2)
(connect [P-1] 1 [N-1])
(connect [P-1] 2 [O-1] 2)
(connect [N-1] [O-1] 1)
(connect [O-1] [P-2])
(connect [P-2] 1 [L-1])
(connect [P-2] 2 [X-1] 1)
(connect [X-1] [L-2]))
