;; ==========================
;; Data definitions
;; ==========================

;; LetterGrade is one of:
;; - "A"
;; - "B:
;; - "C"
;; Interpretation: the letter grade scored by a student in a course

; Examples are redundant for enumeration, still... here we go, for this one time
(define LG1 "A")
(define LG2 "B")
(define LG3 "C")

#;
(define (fn-for-letter-grade lg)
  (cond [(string=? lg "A") ...]
        [(string=? lg "B") ...]
        [(string=? lg "C") ...]))

;; Template rules
;; - One of 3 cases
;; -- Atomic Distinct "A"
;; -- Atomic Distinct "B"
;; -- Atomic Distinct "C"


;; =========================
;; Functions
;; =========================

;; LetterGrade -> LetterGrade
;; Bumps up a grade
; (define (bumpup lg) lg) ; stub

(check-expect (bump-up "A") "A")
(check-expect (bump-up "B") "A")
(check-expect (bump-up "C") "B")

(define (bump-up lg)
  (cond [(string=? lg "A") "A"]
        [(string=? lg "B") "A"]
        [else "B"]))
