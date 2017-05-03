;; ============================
;; Data Definition
;; ============================

;; ListOfNumber is one of:
;; - empty
;; (cons String ListOfNumber)

(define L0 empty)
(define L1 (cons 1 empty))
(define L2 (cons -2 (cons 1 empty)))
(define L3 (cons 3 (cons -2 (cons 1 empty))))

#;
(define (fn-for-lon lon)
  (cond [(empty? lon) (...)]
        [else (... (first lon)                  ; Number
                   (fn-for-lon (rest lon)))]))  ; ListOfNumber

;; Template rules used
;; - One of:
;; -- Atomic Distinct      empty
;; -- Compound Data        (cons Number ListOfNumber)
;; -- Self-Reference       (rest lon) is ListOfNumber


;; ============================
;; Functions
;; ============================

;; ListOfNumber -> Boolean
;; Returns true if the given list contains a negative number, false otherwise
; (define (contains-negative? los) false) ; stub

(check-expect (contains-negative? empty) false)
(check-expect (contains-negative? L1) false)
(check-expect (contains-negative? L2) true)
(check-expect (contains-negative? L3) true)

;; Template from ListOfNumber

(define (contains-negative? lon)
  (cond [(empty? lon) false]
        [else (if (> 0 (first lon))
                  true
                  (contains-negative? (rest lon)))]))


;; ListOfNumbers -> Number
;; Returns the sum of all numbers in the given list
; (define (add-all lon) 0) ; stub

(check-expect (add-all empty) 0)
(check-expect (add-all L1) 1)
(check-expect (add-all L2) -1)
(check-expect (add-all L3) 2)

;; Template from ListOfNumber

(define (add-all lon)
  (cond [(empty? lon) 0]
        [else (+ (first lon)
                 (add-all (rest lon)))]))


;; ListOfNumber -> Number
;; Returns the total number of numbers in the list
; (define (count-list lon) 0) ; stub

(check-expect (count-list L0) 0)
(check-expect (count-list L1) 1)
(check-expect (count-list L2) 2)
(check-expect (count-list L3) 3)

(define (count-list lon)
  (cond [(empty? lon) 0]
        [else (+ 1 (count-list (rest lon)))]))


;; ListOfNumber -> Number
;; Returns the product of all numbers in the list
; (define (times-all lon) 0) ; stub

(check-expect (times-all L0) 1)
(check-expect (times-all L1) 1)
(check-expect (times-all L2) -2)
(check-expect (times-all L3) -6)

(define (times-all lon)
  (cond [(empty? lon) 1]
        [else (* (first lon)
                 (times-all (rest lon)))]))


;; ListOfNumber -> ListOfNumber
;; Given a list of numbers, returns a list such that n = 2n
; (define (double-all lon) empty) ; stub

(check-expect (double-all L0) empty)
(check-expect (double-all L1) (cons 2 empty))
(check-expect (double-all L2) (cons -4 (cons 2 empty)))
(check-expect (double-all L3) (cons 6 (cons -4 (cons 2 empty))))

(define (double-all lon)
  (cond [(empty? lon) empty]
        [else (cons (* 2 (first lon))
                    (double-all (rest lon)))]))


;; ListOfNumber -> Number
;; Returns the largest number in the list
; (define (largest lon) 0) ; stub

(check-expect (largest L0) empty)
(check-expect (largest L1) 1)
(check-expect (largest L2) 1)
(check-expect (largest L3) 3)
(check-expect (largest (cons -2 (cons -4 (cons -1 empty)))) -1)

(define (largest lon)
  (cond [(empty? lon) empty]
        [(empty? (rest lon)) (first lon)]
        [else (if (> (first lon) (largest (rest lon)))
                  (first lon)
                  (largest (rest lon)))]))
