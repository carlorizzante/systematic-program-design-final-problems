empty                              ; empty list
(cons "Jon" empty)                 ; list of 1 element
(cons "Jon" (cons "Anne" empty))   ; list of 2 elements
(cons 1 (cons 2 (cons 3 empty)))   ; list of 3 elements

(define L0 empty)                              ; empty list
(define L1 (cons "Jon" empty))                 ; list of 1 element
(define L2 (cons "Jon" (cons "Anne" empty)))   ; list of 2 elements
(define L4 (cons 1 (cons 2 (cons 3 empty))))   ; list of 3 elements

(first L4) ; 1
(rest L4)  ; rest of the list L4

(second L4)       ; 2
(first (rest L4)) ; 2
