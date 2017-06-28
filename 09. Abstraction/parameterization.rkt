;; ============================
;; Basic Abstraction
;; ============================

(* pi (sqr 4)) ;area of circle radius 4
(* pi (sqr 6)) ;area of circle radius 6

(define (area r)
  (* pi (sqr r)))

(area 4)
(area 6)


;; ============================
;; ListOfString
;; ============================

;; ListOfString -> Boolean
;; produce true if los includes "UBC"
(check-expect (contains-ubc? empty) false)
(check-expect (contains-ubc? (cons "McGill" empty)) false)
(check-expect (contains-ubc? (cons "UBC" empty)) true)
(check-expect (contains-ubc? (cons "McGill" (cons "UBC" empty))) true)

(define (contains-ubc? los)
  (contains? "UBC" los))

;; ListOfString -> Boolean
;; produce true if los includes "McGill"
(check-expect (contains-mcgill? empty) false)
(check-expect (contains-mcgill? (cons "UBC" empty)) false)
(check-expect (contains-mcgill? (cons "McGill" empty)) true)
(check-expect (contains-mcgill? (cons "UBC" (cons "McGill" empty))) true)

(define (contains-mcgill? los)
  (contains? "McGill" los))

;; String (Listof String) -> Boolean
;; Returns true if the list contains the given string, false otherwise

(check-expect (contains? "UBC" empty) false)
(check-expect (contains? "UBC" (cons "McGill" empty)) false)
(check-expect (contains? "UBC" (cons "UBC" empty)) true)
(check-expect (contains? "McGill" (cons "McGill" empty)) true)
(check-expect (contains? "McGill" (cons "UBC" (cons "McGill" empty))) true)
(check-expect (contains? "Toronto" (cons "UBC" (cons "McGill" empty))) false)

(define (contains? s los)
  (cond [(empty? los) false]
        [else
         (if (string=? (first los) s)
             true
             (contains? s (rest los)))]))


;; ============================
;; Mapping with First Class Functions
;; ============================

;; ListOfNumber -> ListOfNumber
;; produce list of sqr of every number in lon
(check-expect (squares empty) empty)
(check-expect (squares (list 3 4)) (list 9 16))

(define (squares lon)
  (map2 sqr lon))


;; ListOfNumber -> ListOfNumber
;; produce list of sqrt of every number in lon
(check-expect (square-roots empty) empty)
(check-expect (square-roots (list 9 16)) (list 3 4))

(define (square-roots lon)
  (map2 sqrt lon))


;; (X -> Y) (Listof X) -> (Listof Y)
;; Given fn and (list n0 n1 ...) returns (list (fn n0) (fn n1) ...)

(check-expect (map2 sqr empty) empty)
(check-expect (map2 sqr (list 3 4)) (list 9 16))
(check-expect (map2 sqrt (list 9 16)) (list 3 4))
(check-expect (map2 string-length (list "a" "abc" "ws" "sdkfsdk")) (list 1 3 2 7))

(define (map2 fn lon)
  (cond [(empty? lon) empty]
        [else
         (cons (fn (first lon))
               (map2 fn (rest lon)))]))


;; ============================
;; Filtering with First Class Function
;; ============================

;; ListOfNumber -> ListOfNumber
;; produce list with only positive? elements of lon
(check-expect (positive-only empty) empty)
(check-expect (positive-only (list 1 -2 3 -4)) (list 1 3))

(define (positive-only lon)
  (filter2 positive? lon))


;; ListOfNumber -> ListOfNumber
;; produce list with only negative? elements of lon
(check-expect (negative-only empty) empty)
(check-expect (negative-only (list 1 -2 3 -4)) (list -2 -4))

(define (negative-only lon)
  (filter2 negative? lon))


;; (X -> Boolean) (Listof X) -> (Listof X)
;; Given a list, returns a new list of only the elements that satisfy the predicate p

(check-expect (filter2 positive? empty) empty)
(check-expect (filter2 positive? (list 1 -2 3 -4)) (list 1 3))
(check-expect (filter2 negative? (list 1 -2 3 -4)) (list -2 -4))

(define (filter2 fn lon)
  (cond [(empty? lon) empty]
        [else
         (if (fn (first lon))
             (cons (first lon)
                   (filter2 fn (rest lon)))
             (filter2 fn (rest lon)))]))


;; ============================
;; Map and Reduce
;; ============================

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


;; (X -> Boolean) (Listof X) -> Boolean
;; produce true if pred produces true for every element of the list
(check-expect (andmap2 positive? empty) true)
(check-expect (andmap2 positive? (list 1 -2 3)) false)
(check-expect (andmap2 positive? (list 1 2 3)) true)
(check-expect (andmap2 negative? (list -1 -2 -3)) true)

(define (andmap2 pred lst)
  (cond [(empty? lst) true]
        [else
         (and (pred (first lst))
              (andmap2 pred (rest lst)))]))
