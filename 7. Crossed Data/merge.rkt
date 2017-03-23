;; =============================
;; Data definition
;; =============================

;; ListOfNumbers is one of:
;; - empty
;; - (cons Number ListOfNumbers)
;; Interp. A list of numbers

(define LN0 empty)
(define LN1 (list 1 2 3))
(define LN2 (list 3 4 5))
(define LN3 (list 2 5 7))

#;
(define (fn-for-ln ln)
  (cond [(empty? ln) (...)]
        [else
         (... (first ln)
              (fn-for-ln (rest ln)))]))


;; =============================
;; Functions
;; =============================

;; ListOfNumbers ListOfNumbers -> ListOfNumbers
;; Merges two sorted lists of numbers into one sorted list of numbers
; (define (merge ln1 ln2) empty) ; stub

;;  ln1        ln2 |  empty  |  ListOfNumbers
;; -------------------------------------------------
;;  empty          |  empty  |  ln2
;; -------------------------------------------------
;;  ListOfNumbers  |  ln1    |  ??
;; -------------------------------------------------

(check-expect (merge empty empty) empty)
(check-expect (merge empty (list 1 2 3)) (list 1 2 3))
(check-expect (merge (list 1 2 3) empty) (list 1 2 3))
(check-expect (merge (list 1 3 5) (list 2 4 6)) (list 1 2 3 4 5 6))
(check-expect (merge (list -4 -2 0 1 4 7 18) (list -7 -3 -1 1 2 5 7 8 19))
              (list -7 -4 -3 -2 -1 0 1 1 2 4 5 7 7 8 18 19)) ; extra test, not necessary but fun

#;
;; First attempt, 4 conditions
(define (merge ln1 ln2)
  (cond [(and (empty? ln1) (empty? ln2)) empty]
        [(empty? ln1) ln2]
        [(empty? ln2) ln1]
        [else (if (< (first ln1) (first ln2))
                  (cons (first ln1) (merge (rest ln1) ln2))
                  (cons (first ln2) (merge ln1 (rest ln2))))]))

;;  ln1        ln2 |  empty  |  ListOfNumbers
;; -------------------------------------------------
;;  empty          |  ln2    |  ln2
;; -------------------------------------------------
;;  ListOfNumbers  |  ln1    |  ??
;; -------------------------------------------------

;; Simplified solution, 3 conditions, if ln1 empty then just return ln2
(define (merge ln1 ln2)
  (cond [(empty? ln1) ln2]
        [(empty? ln2) ln1]
        [else (if (< (first ln1) (first ln2))
                  (cons (first ln1) (merge (rest ln1) ln2))
                  (cons (first ln2) (merge ln1 (rest ln2))))]))
