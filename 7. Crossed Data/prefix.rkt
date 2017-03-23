;; =================
;; Data Definitions:

;; ListOfStrings is one of:
;; - empty
;; - (cons String ListOfStrings)
;; interp. a list of strings

(define LS0 empty)
(define LS1 (cons "a" empty))
(define LS2 (cons "a" (cons "b" empty)))
(define LS3 (cons "c" (cons "b" (cons "a" empty))))

#;
(define (fn-for-los los)
  (cond [(empty? los) (...)]
        [else
         (... (first los)
              (fn-for-los (rest los)))]))

;; ==========
;; Functions:

;; ListOfStrings -> Boolean
;; Returns true if listA is prefix of listB, false otherwise
; (define (prefix=? la lb) false) ; stub

(check-expect (prefix=? empty empty) true)
(check-expect (prefix=? (list "x") empty) false)
(check-expect (prefix=? empty (list "x")) true)
(check-expect (prefix=? (list "x") (list "x")) true)
(check-expect (prefix=? (list "x") (list "x" "y")) true)
(check-expect (prefix=? (list "x" "y") (list "x" "y")) true)
(check-expect (prefix=? (list "x" "y") (list "x" "z")) false)
(check-expect (prefix=? (list "x" "y" "z") (list "x" "y")) false)

#;
;; Template with 4 cases, however, looking at the table of all possible cases
;; it is clear that if la is empty, no matter what lb is, the result should be
;; true, so in fact we have a template with 3 cases. See next template below.
(define (prefix=? la lb)
  (cond [(and (empty? la) (empty? lb)) (...)]
        [(and (cons? la) (empty? lb)) (... la ...)]
        [(and (empty? la) (cons? lb)) (... lb ...)]
        [(and (cons? la) (cons? lb)) (... la lb ...)]))
#;
;; Simplified template
(define (prefix=? la lb)
  (cond [(empty? la) true]
        [(empty? lb) false]
        [else (... (first la) ; string
                   (first lb) ; string
                   (prefix=? (rest la) (rest lb)))]))

(define (prefix=? la lb)
  (cond [(empty? la) true]
        [(empty? lb) false]
        [else
         (and (equal? (first la) (first lb))
             (prefix=? (rest la) (rest lb)))]))
