;
; An interesting experiment, using '!' as fundamental unit in a custom made counting system.
; Therefore a custom-made NATURAL is a list of '!' (or an empty list for the entity zero).
; The series of functions below are implementation of a rudimentary algebraic set of rules
; to work with the data definition of NATURAL.
;
; Methods:
; ------------------------------------------------
; - ZERO? n       > Equality for the entity zero
; - ADD1 n        > Add one unit to n
; - SUB1 n        > Subtract one unit from n
; - ADD n1 n2     > Adds n1 to n2
; - DIFF n1 n2    > Substract n2 from n1
; - EQUAL n1 n2   > Equality for n1 against n2
; - TIMES n1 n2   > n1 times n2
; - FACTORIAL n   > Factorial for n


;; ============================
;; Data definition
;; ============================

;; NATURAL is one of:
;; - empty
;; - (cons "!" NATURAL)

(define N0 empty)
(define N1 (cons "!" N0))     ; 1
(define N2 (cons "!" N1))     ; 2
(define N3 (cons "!" N2))     ; 3
(define N4 (cons "!" N3))     ; 4
(define N5 (cons "!" N4))     ; 5
(define N6 (cons "!" N5))     ; 6
(define N7 (cons "!" N6))     ; 7
(define N8 (cons "!" N7))     ; 8
(define N9 (cons "!" N8))     ; 9
(define N10 (cons "!" N9))    ; 10

(define (fn-for-natural n)
  (cond [(ZERO? n) (...)]
        [else
         (... n
              (fn-for-natural (SUB1 n)))]))


;; ============================
;; Functions (methods)
;; ============================

(define (ZERO? n) (empty? n))     ; Any          -> Boolean
(define (ADD1 n) (cons "!" n))    ; NATURAL[>=0] -> NATURAL
(define (SUB1 n) (rest n))        ; NATURAL[>0]  -> NATURAL


;; NATURAL NATURAL -> NATURAL
;; Returns the sum of two naturals
; (define (ADD n1 n2) 0) ; stub

(check-expect (ADD N0 N0) N0)
(check-expect (ADD N0 N1) N1)
(check-expect (ADD N1 N2) N3)
(check-expect (ADD N2 N2) N4)
(check-expect (ADD N3 N4) N7)
(check-expect (ADD N3 N6) N9)

(define (ADD n1 n2)
  (cond [(ZERO? n1) n2]
        [else
         (ADD (SUB1 n1) (ADD1 n2))]))


;; NATURAL NATURAL -> NATURAL
;; Returns the different of two naturals, where n1 > n2 (!)
; (define (DIFF n1 n2) 0) ; stub

(check-expect (DIFF N1 N0) N1)
(check-expect (DIFF N1 N1) N0)
(check-expect (DIFF N2 N1) N1)
(check-expect (DIFF N9 N3) N6)

(define (DIFF n1 n2)
  (cond [(ZERO? n2) n1]
        [else
         (DIFF (SUB1 n1) (SUB1 n2))]))

;; Let's combine ADD and DIFF

(check-expect (ADD N1 (DIFF N3 N2)) N2) ; 1 + (3 - 2) = 2
(check-expect (DIFF N9 (ADD N3 N2)) N4) ; 9 - (3 + 2) = 4


;; NATURAL NATURAL -> Boolean
;; While n1 > n2, returns true if n1 equals n2, false otherwise
; (define (EQUAL n1 n2) false) ; stub

(check-expect (EQUAL N0 N0) true)
(check-expect (EQUAL N1 N0) false)
; (check-expect (EQUAL N0 N1) false)
(check-expect (EQUAL N3 N3) true)
; (check-expect (EQUAL N4 N5) false)
(check-expect (EQUAL N6 N2) false)

(define (EQUAL n1 n2)
  (cond [(ZERO? (DIFF n1 n2)) true]
        [else false]))


;; NATURAL NATURAL NATURAL -> NATURAL
;; Returns n1 times n2, n3 = n2
; (define (TIMES n1 n2 n3) 0) ; stub

(check-expect (TIMES-HELPER N0 N3 N3) N0)
(check-expect (TIMES-HELPER N1 N4 N4) N4)
(check-expect (TIMES-HELPER N3 N2 N2) N6)
(check-expect (TIMES-HELPER N2 N2 N2) N4)
(check-expect (TIMES-HELPER N4 N2 N2) N8)
(check-expect (TIMES-HELPER N2 N4 N4) N8)
(check-expect (TIMES-HELPER N3 N3 N3) N9)

(define (TIMES-HELPER n1 n2 n3)
  (cond [(or (ZERO? n1) (ZERO? n2)) N0]
        [else
         (if (EQUAL n1 N1)
             n2
             (TIMES-HELPER (SUB1 n1) (ADD n2 n3) n3))]))


;; NATURAL NATURAL -> NATURAL
;; Returns n1 times n2
; (define (TIMES n1 n2) 0) ; stub

(check-expect (TIMES N0 N3) N0)
(check-expect (TIMES N1 N4) N4)
(check-expect (TIMES N3 N2) N6)
(check-expect (TIMES N2 N2) N4)
(check-expect (TIMES N4 N2) N8)
(check-expect (TIMES N2 N4) N8)
(check-expect (TIMES N3 N3) N9)

(define (TIMES n1 n2)
  (TIMES-HELPER n1 n2 n2))


;; NATURAL -> NATURAL
;; Returns the factorial of a natural
; (define (FACTORIAL n) 0) ; stub

(check-expect (FACTORIAL N0) N1)
(check-expect (FACTORIAL N1) N1)
(check-expect (FACTORIAL N2) N2)
(check-expect (FACTORIAL N3) N6)

(define (FACTORIAL n)
  (cond [(ZERO? n) N1]
        [else
         (TIMES n (FACTORIAL (SUB1 n)))]))
