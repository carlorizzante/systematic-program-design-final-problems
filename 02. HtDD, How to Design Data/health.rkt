;; ======================
;; Data definitions
;; ======================

;; Age is Natural
;; Interpretation: the age of a person in years

(define A0 18)
(define A1 25)

#;
(define (fn-for-age a)
  (... a))

;; Template rules used:
;; - atomic non-distinct: Natural


;; MonthAge is Natural
;; Interpretation: the age of a person in Months

(define M0 (* 12 A0))
(define M1 (* 12 A1))

#;
(define (fn-for-month-age m)
  (... m))

;; Template rules used:
;; - atomic non-distinct: Natural


;; ======================
;; Functions
;; ======================

;; Age -> Boolean
;; Returns true if age is less than 20, false otherwise
; (define (teenager? a) false) ; stub

(check-expect (teenager? 12) false)
(check-expect (teenager? 13) true)     ; edge case
(check-expect (teenager? 19) true)     ; edge case
(check-expect (teenager? 25) false)

;; Template from Age

(define (teenager? a)
  (<= 13 a 19))


;; Age -> MonthAge
;; Returns the age of a person in months
; (define (months-old a) 0) ; stub

(check-expect (months-old 0) 0)
(check-expect (months-old 18) (* 12 18))
(check-expect (months-old 25) (* 12 25))

;; Template from MonthAge

(define (months-old a)
  (* 12 a))


;; ======================
;; Health
;; ======================

;; Health is one of:
;; - false              the player's character is dead
;; - Natural[1, 100]    the player's character current health
;; Interpretation: the health of a character in a video game

(define H0 false)    ; dead!
(define H1 20)       ; some kind of health...
(define H2 100)      ; full health!

#;
(define (fn-for-health h)
  (cond [(false? h) (...)]
        [else (... h)]))

;; Template rules used:
;; - One of 2 cases
;; -- Atomic Distinct        false              dead
;; -- Atomic Non-Disctinct   Natural[1, 100]    current life


;; Health -> Health
;; Increase the health of a character in game, unless health is false, then the character is dead
; (define (increase-health h) false) ; stub

(check-expect (increase-health H0) false)
(check-expect (increase-health H1) 21)
(check-expect (increase-health H2) 100)

;; Template from Health

(define (increase-health h)
  (cond [(false? h) false]
        [else (if (> 100 h) (add1 h) 100)]))
