;; ====================
;; Problem
;; ====================
;; Design a function called average that consumes (listof Number) and produces the
;; average of the numbers in the list.

;; (Listof Number) -> Number
;; Returns the average of all numbers in the given list
; (define (average lst) 0) ; stub

(check-expect (average empty) 0)
(check-expect (average (list 1 2 3 4 5)) 3)
(check-expect (average (list -1 2 -3 4 -5)) -0.6)

(define (average lst)
  (local [(define (average lst tot count)
            (cond [(empty? lst) (if (zero? count) 0 (/ tot count))]
                  [else (average (rest lst) (+ tot (first lst)) (add1 count))]))]
    (average lst 0 0)))
