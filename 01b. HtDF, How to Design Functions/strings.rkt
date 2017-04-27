;; String -> String
;; Returns a given string with an additional "s" at its end
; (define (pluralize s) "") ; stub

(check-expect (pluralize "") "s")
(check-expect (pluralize "apple") "apples")
(check-expect (pluralize "banana") "bananas")

#; ;; template
(define (pluralize str)
  (... str))

(define (pluralize s)
  (string-append s "s"))

;; =======================

;; String -> String
;; Returns a given string adding an "!" at its end
; (define (yell s) "") ; stub

(check-expect (yell "") "!")
(check-expect (yell "Hi") "Hi!")
(check-expect (yell "Hello") "Hello!")

#; ;; template
(define (yell s)
  (... s))

(define (yell s)
  (string-append s "!"))

;; =======================

;; String -> Boolean
;; Given a string, returns true if the string length is less than 5, false otherwise
; (define (less-than-5? s) false) ; stub

(check-expect (less-than-5? "") true)
(check-expect (less-than-5? "abc") true)
(check-expect (less-than-5? "hello") false)

#; ; template
(define (less-than-5? s)
  (... s))

(define (less-than-5? s)
  (> 5 (string-length s)))
