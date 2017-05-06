;; ===============================
;; Data definition
;; ===============================

;; ListOfNatural is one of:
;; - empty
;; - (cons Natural ListOfNatural)
;; Interpr. A list of Natural numbers, from the highest to the lowest so that (n... 0)
;; or an empty list with no natural numbers

(define LON0 empty)
(define LON1 (cons 1 empty))
(define LON3 (cons 3 (cons 2 (cons 1 empty))))

#;
(define (fn-for-lon lon)
  (cond
    [(empty?) (...)]
    [else
     (... (... n)
          (fn-for-lon lon))]))


;; ===============================
;; Functions
;; ===============================

;; Natural -> ListOfNatural
;; Given a natural n, returns a list of all odds natural numbers comprised between n and 0.
; (define (odd-from-n n) empty) ; stub

(check-expect (odd-from-n 0) empty)
(check-expect (odd-from-n 1) (cons 1 empty))
(check-expect (odd-from-n 2) (cons 1 empty))
(check-expect (odd-from-n 7) (cons 7 (cons 5 (cons 3 (cons 1 empty)))))

(define (odd-from-n n)
  (cond
    [(zero? n) empty]
    [else
     (if (odd? n)
         (cons n (odd-from-n (- n 1)))
         (odd-from-n (- n 1)))]))


;; ===============================
;; Try out
;; ===============================

(odd-from-n 13) ; 13 11 9 7 5 3 1
