;; ===========================
;; Data Definition
;; ===========================

;; Natural is one of:
;; - 0
;; (add1 Natural)
;; A natural number

(define N0 0)
(define N1 (add1 N0))
(define N2 (add1 N1))
(define N3 (add1 N2))
(define N4 (add1 N3))
(define N5 (add1 N4))
(define N6 (add1 N5))
(define N7 (add1 N6))
(define N8 (add1 N7))
(define N9 (add1 N8))
(define N10 (add1 N9))

#;
(define (fn-for-natural n)
  (cond [(zero? n) (...)]
        [else (... n
                   (fn-for-natural (sub1 n)))]))


;; Template rules used:
;; - Atomic Distinct                0
;; - Compound Data                  (add1 Natural)
;; - Self Reference                 (sub1 n) is Natural


;; ===========================
;; Functions
;; ===========================

;; Natural -> Natural
;; Given a natural n, returns the sum of all numbers between n and 0
; (define (sum-all n) 0) ; stub

(check-expect (sum-all N0) N0)
(check-expect (sum-all N1) N1)
(check-expect (sum-all N3) N6)
(check-expect (sum-all N4) N10)

(define (sum-all n)
  (cond [(zero? n) 0]
        [else (+ n (sum-all (sub1 n)))]))


;; Natural -> ListOfNatural
;; Given a natural n, returns a list of all natural between n and 0, escluding 0
; (define (list-all n) empty) ; stub

(check-expect (list-all N0) empty)
(check-expect (list-all N1) (cons N1 empty))
(check-expect (list-all N3) (cons N3 (cons N2 (cons N1 empty))))

(define (list-all n)
  (cond [(zero? n) empty]
        [else (cons n (list-all (sub1 n)))]))


;; Natural -> Natural
;; Returns the factorial of a given natural n
; (define (factorial n) 0) ; stub

(check-expect (factorial 0) 1)
(check-expect (factorial 1) 1)
(check-expect (factorial 3) 6)
(check-expect (factorial 5) 120)

(define (factorial n)
  (cond [(zero? n) 1]
        [else (* n (factorial (sub1 n)))]))


;; Natural Natural -> ListOfNatural
;; Given two natural a, b, such as a <=b, returns a list of all naturals between a and b
; (define (range-list a b) empty) ; stub

(check-expect (range-list 0 0) (cons 0 empty))
(check-expect (range-list 2 2) (cons 2 empty))
(check-expect (range-list 3 7) (cons 3 (cons 4 (cons 5 (cons 6 (cons 7 empty))))))

(define (range-list a b)
  (cond [(zero? (- a b)) (cons a empty)]
        [else (cons a (range-list (+ a 1) b))]))
