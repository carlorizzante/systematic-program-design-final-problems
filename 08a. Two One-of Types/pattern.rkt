;; ====================
;; Data Definitions
;; ====================

;; 1String is String
;; interp. these are strings only 1 character long
(define 1SA "x")
(define 1SB "2")

;; Pattern is one of:
;;  - empty
;;  - (cons "A" Pattern)
;;  - (cons "N" Pattern)
;; interp.
;;   A pattern describing certain ListOf1String.
;;  "A" means the corresponding letter must be alphabetic.
;;  "N" means it must be numeric.  For example:
;;      (list "A" "N" "A" "N" "A" "N")
;;   describes Canadian postal codes like:
;;      (list "V" "6" "T" "1" "Z" "4")
(define PATTERN1 (list "A" "N" "A" "N" "A" "N"))

;; ListOf1String is one of:
;;  - empty
;;  - (cons 1String ListOf1String)
;; interp. a list of strings each 1 long
(define LOS1 (list "V" "6" "T" "1" "Z" "4"))


;; ====================
;; Functions
;; ====================

;; 1String -> Boolean
;; produce true if 1s is alphabetic/numeric

(check-expect (alphabetic? " ") false)
(check-expect (alphabetic? "1") false)
(check-expect (alphabetic? "a") true)
(check-expect (numeric? " ") false)
(check-expect (numeric? "1") true)
(check-expect (numeric? "a") false)

(define (alphabetic? 1s) (char-alphabetic? (string-ref 1s 0)))
(define (numeric?    1s) (char-numeric?    (string-ref 1s 0)))


;; ListOf1String ListOf1String -> Boolean
;; Returns true if the second list matches the pattern of the first, false otherwise
; (define (pattern-match? p l) false) ; stub

(check-expect (pattern-match? empty empty) true)
(check-expect (pattern-match? empty (list "A" "2" "C")) true)
(check-expect (pattern-match? (list "A" "N" "N") (list "W" "3" "7")) true)
(check-expect (pattern-match? (list "A" "N" "N") (list "W" "3" "7" "E")) true)
(check-expect (pattern-match? (list "N" "A" "N") (list "W" "3" "7")) false)
(check-expect (pattern-match? (list "A" "N" "N") (list "N" "9")) false)

;; a        /       b | empty | (cons 1String ListOf1String)
;; --------------------------------------------------------------------
;; empty              | true  | true
;; --------------------------------------------------------------------
;; (cons "A" Pattern) | false | ...a ...b ...
;; --------------------------------------------------------------------
;; (cons "N" Pattern) | false | ...a ...b ...
;; --------------------------------------------------------------------

;; Table simplified below

;; a        /       b | empty | (cons 1String ListOf1String)
;; --------------------------------------------------------------------
;; empty              |     true
;; --------------------------------------------------------------------
;; (cons "A" Pattern) |       | ...a ...b ...
;; -------------------- false -----------------------------------------
;; (cons "N" Pattern) |       | ...a ...b ...
;; --------------------------------------------------------------------

(define (pattern-match? p l)
  (cond [(empty? p) true]
        [(empty? l) false]
        [(or (and (string=? "A" (first p)) (alphabetic? (first l)))
             (and (string=? "N" (first p)) (numeric? (first l))))
         (pattern-match? (rest p) (rest l))]
        [else false]))
