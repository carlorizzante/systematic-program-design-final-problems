;; NOTES
;; - (listof X) stands for a list of equal entities)
;; - (X -> Y) stands for a function signature, requires an X type, returns an Y type - X and Y might be of the same type.
;; - Types must be consistent within a signature. X represent a specific type, Y another specific type.

;; The current set of code is about abstraction, in functions consuming other functions
;; and in the signature used to represent abstractions.


;; Number -> Number
;; Return the area of a circle by its radius
(define (area-of-circle r)
  (* pi (sqr r)))

; check-expect cannot compare inexact numbers.
(equal? (area-of-circle 4)(* pi (sqr 4))) ; true
(equal? (area-of-circle 6)(* pi (sqr 6))) ; true


;; ====================

;; ListOfStrings -> Boolean
;; produce true if los includes "UBC"
;(define (contains-ubc? los) false) ;stub

(check-expect (contains-ubc? empty) false)
(check-expect (contains-ubc? (cons "McGill" empty)) false)
(check-expect (contains-ubc? (cons "UBC" empty)) true)
(check-expect (contains-ubc? (cons "McGill" (cons "UBC" empty))) true)

(define (contains-ubc? los)
  (contains? "UBC" los))

;; ListOfStrings -> Boolean
;; produce true if los includes "McGill"
;(define (contains-mcgill? los) false) ;stub

(check-expect (contains-mcgill? empty) false)
(check-expect (contains-mcgill? (cons "UBC" empty)) false)
(check-expect (contains-mcgill? (cons "McGill" empty)) true)
(check-expect (contains-mcgill? (cons "UBC" (cons "McGill" empty))) true)

(define (contains-mcgill? los)
  (contains? "McGill" los))


;; String ListOfStrings -> Boolean
;; ALT: String (listof String) -> Boolean
;; produce true if los includes the given string
;(define (contains? s los) false) ;stub

(check-expect (contains? "" empty) false)
(check-expect (contains? "abc" empty) false)
(check-expect (contains? "abc" (cons "xyz" empty)) false)
(check-expect (contains? "abc" (cons "abc" empty)) true)
(check-expect (contains? "abc" (cons "xyz" (cons "abc" empty))) true)

;<template from ListOfStrings>

(define (contains? s los)
  (cond [(empty? los) false]
        [else
         (if (string=? (first los) s)
             true
             (contains? s (rest los)))]))


;; ====================

;; ListOfNumbers -> ListOfNumbers
;; produce list of sqr of every number in lon
;(define (squares lon) empty) ;stub

(check-expect (squares empty) empty)
(check-expect (squares (list 3 4)) (list 9 16))

(define (squares lon)
  (map-to sqr lon))

;; ListOfNumbers -> ListOfNumbers
;; produce list of sqrt of every number in lon
;(define (square-roots lon) empty) ;stub

(check-expect (square-roots empty) empty)
(check-expect (square-roots (list 9 16)) (list 3 4))

(define (square-roots lon)
  (map-to sqrt lon))


;; (X -> Y) (listof X) -> (listof Y)
;; Maps a list of elements by a given function, able to consume those elements
;(define (map-to fn lon) empty) ;stub

(check-expect (map-to sqr empty) empty)
(check-expect (map-to sqrt empty) empty)
(check-expect (map-to sqr (list 3 4)) (list 9 16))
(check-expect (map-to sqrt (list 9 16)) (list 3 4))
(check-expect (map-to abs (list 9 -12 16)) (list 9 12 16))
(check-expect (map-to add1 (list 9 -12 16)) (list 10 -11 17))
(check-expect (map-to sub1 (list 9 -12 16)) (list 8 -13 15))
(check-expect (map-to string-length (list "Jon" "Janet" "Abraham")) (list 3 5 7))

;<template from (listof X)>

(define (map-to fn lon)
  (cond [(empty? lon) empty]
        [else
         (cons (fn (first lon))
               (map-to fn (rest lon)))]))


;; ====================

;; ListOfNumbers -> ListOfNumbers
;; produce list with only positive? elements of lon
;(define (positive-only lon) empty) ;stub

(check-expect (positive-only empty) empty)
(check-expect (positive-only (list 1 -2 3 -4)) (list 1 3))

(define (positive-only lon)
  (filter-by positive? lon))


;; ListOfNumbers -> ListOfNumbers
;; produce list with only negative? elements of lon
;(define (negative-only lon) empty) ;stub

(check-expect (negative-only empty) empty)
(check-expect (negative-only (list 1 -2 3 -4)) (list -2 -4))

(define (negative-only lon)
  (filter-by negative? lon))


;; (X -> Boolean) (listof X) -> (listof X)
;; Filters a list by the given predicate
; (define (filter-by pr lon) empty) ; stub

(check-expect (filter-by positive? empty) empty)
(check-expect (filter-by negative? empty) empty)
(check-expect (filter-by positive? (list 1 -2 3 -4)) (list 1 3))
(check-expect (filter-by negative? (list 1 -2 3 -4)) (list -2 -4))
(check-expect (filter-by false? (list true false false true)) (list false false))

;<template from (listof X)>

(define (filter-by pr lon)
  (cond [(empty? lon) empty]
        [else
         (if (pr (first lon))                  ; consumes X, returns Boolean
             (cons (first lon)                 ; returns (listof X)
                   (filter-by pr (rest lon)))
             (filter-by pr (rest lon)))]))


;; ====================

;; ListOfNumber -> Boolean
;; produce true if every number in lon is positive
(check-expect (all-positive? empty) true)
(check-expect (all-positive? (list 1 -2 3)) false)
(check-expect (all-positive? (list 1 2 3)) true)

(define (all-positive? lon) (andmap2 positive? lon))

;; ListOfNumber -> Boolean
;; produce true if every number in lon is negative
(check-expect (all-negative? empty) true)
(check-expect (all-negative? (list 1 -2 3)) false)
(check-expect (all-negative? (list -1 -2 -3)) true)

(define (all-negative? lon) (andmap2 negative? lon))

;; (X -> Boolean) (list of X) -> Boolean
;;produce true if pred produces true for every element of the list
(check-expect (andmap2 positive? empty) true)
(check-expect (andmap2 positive? (list 1 -2 3)) false)
(check-expect (andmap2 positive? (list 1 2 3)) true)
(check-expect (andmap2 negative? (list -1 -2 -3)) true)

(define (andmap2 pred lst)
  (cond [(empty? lst) true]
        [else
         (and (pred (first lst))
              (andmap2 pred (rest lst)))]))
