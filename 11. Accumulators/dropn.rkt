;; =================
;; Problem
;; =================
;; Design a function that consumes a list of elements lox and a natural number
;; n and produces the list formed by dropping every nth element from lox.

;; (Listof X) -> (Listof X)
;; Drops every nth element in a given list
; (define (dropn n lst) empty) ; stub

(check-expect (dropn 0 empty) empty)
(check-expect (dropn 0 (list "a" "b" "c" "d" "e" "f")) empty)
(check-expect (dropn 1 (list "a" "b" "c" "d" "e" "f")) (list "a" "c" "e"))
(check-expect (dropn 2 (list "a" "b" "c" "d" "e" "f")) (list "a" "b" "d" "e"))

(define (dropn n lst)
  ; - index is Natural[0, n]
  ;   content preserving accumulator, decreases from n to 0
  ;   base case for index is 0
  (local [(define (dropn n lst index)
            (cond [(or (empty? lst) (zero? n)) empty]
                  [else (if (zero? index)
                            (dropn n (rest lst) n)
                            (cons (first lst) (dropn n (rest lst) (sub1 index))))]))]
    (dropn n lst n)))
