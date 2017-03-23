;; =================
;; Data Definitions
;; =================

;; Char is String
;; interp. a single character

(define C1 "x")
(define C2 "2")

;; Pattern is one of:
;;  - empty
;;  - (cons "A" Pattern)
;;  - (cons "N" Pattern)
;; interp.
;; - A pattern describing certain ListOfChars.
;; - "A" means the corresponding letter must be alphabetic.
;; - "N" means it must be numeric.

(define P1 (list "A" "N" "A" "N" "A" "N"))

;; ListOfChars is one of:
;;  - empty
;;  - (cons Char ListOfChars)
;; interp. a list of characters

(define LOS1 (list "V" "6" "T" "1" "Z" "4"))


;; =================
;; Functions
;; =================

;; Pattern ListOfChars -> Boolean
;; Returns true if the list of characters follows the pattern, false otherwise
; (define (match? p loc) false) ; stub

;;  pattern / listOfChars |  empty  |  (cons Char ListOfChars)
;; --------------------------------------------------------------
;;  empty                 |  true   |  true
;; --------------------------------------------------------------
;;  (cons "A" Pattern)    |  false  |  (if (alpha? (first loc)) (match? (rest p) (rest loc)) false)
;; --------------------------------------------------------------
;;  (cons "N" Pattern)    |  false  |  (if (num? (first loc)) (match? (rest p) (rest loc)) false)

(check-expect (match? empty empty) true)
(check-expect (match? empty (list "a")) true)
(check-expect (match? empty (list "1")) true)
(check-expect (match? (list "A") empty) false)
(check-expect (match? (list "N") empty) false)
(check-expect (match? (list "A") (list "1")) false)
(check-expect (match? (list "N") (list "a")) false)
(check-expect (match? (list "A") (list "a")) true)
(check-expect (match? (list "N") (list "1")) true)
(check-expect (match? (list "A" "N") (list "a" "1")) true)
(check-expect (match? (list "N" "A") (list "1" "a")) true)
(check-expect (match? (list "A" "N") (list "a" "1" "b" 2)) true)
(check-expect (match? (list "N" "A") (list "1" "a" "2" "b")) true)
(check-expect (match? (list "A" "N" "A" "N" "A" "N")
                      (list "V" "6" "T" "1" "Z" "4")) true)

#;
;; First solution
(define (match? p loc)
  (cond [(and (empty? p) (empty? loc)) true]
        [(and (empty? p) (cons? loc)) true]
        [(and (string=? "A" (first p)) (empty? loc)) false]
        [(and (string=? "N" (first p)) (empty? loc)) false]
        [(and (string=? "A" (first p)) (cons? loc)) (if (alpha? (first loc)) (match? (rest p) (rest loc)) false)]
        [(and (string=? "N" (first p)) (cons? loc)) (if (num? (first loc)) (match? (rest p) (rest loc)) false)]))

#;
;; Simplified solution
(define (match? p loc)
  (cond [(empty? p) true]
        [(empty? loc) false]
        [(string=? "A" (first p)) (if (alpha? (first loc)) (match? (rest p) (rest loc)) false)]
        [(string=? "N" (first p)) (if (num? (first loc)) (match? (rest p) (rest loc)) false)]))

#;
;; First refactoring
(define (match? p loc)
  (cond [(empty? p) true]
        [(empty? loc) false]
        [(and (string=? "A" (first p)) (alpha? (first loc))) (match? (rest p) (rest loc))]
        [(and (string=? "N" (first p)) (num? (first loc))) (match? (rest p) (rest loc))]
        [else false]))

#;
;; Final refactoring
(define (match? p loc)
  (cond [(empty? p) true]
        [(empty? loc) false]
        [(or
          (and (string=? "A" (first p)) (alpha? (first loc)))
          (and (string=? "N" (first p)) (num? (first loc))))
         (match? (rest p) (rest loc))]
        [else false]))

;; Alternative refactoring -> backward recursion
(define (match? p loc)
  (cond [(empty? p) true]
        [(empty? loc) false]
        [(match? (rest p) (rest loc))
         (or
          (and (string=? "A" (first p)) (alpha? (first loc)))
          (and (string=? "N" (first p)) (num? (first loc))))]))


;; =================
;; Helpers
;; =================

;; Char -> Boolean
;; produce true if the character is alphabetic or numeric
; (define (alpha? c) false) ; stub

(check-expect (alpha? " ") false)
(check-expect (alpha? "1") false)
(check-expect (alpha? "a") true)

(define (alpha? c)
  (char-alphabetic? (string-ref c 0)))


;; Char -> Boolean
;; produce true if the character is alphabetic or numeric
; (define (num? c) false) ; stub

(check-expect (num? " ") false)
(check-expect (num? "1") true)
(check-expect (num? "a") false)

(define (num? c)
  (char-numeric? (string-ref c 0)))
