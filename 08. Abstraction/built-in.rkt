(require 2htdp/image)

;; ============================
;; Constants
;; ============================

(define I1 (rectangle 10 20 "solid" "red"))
(define I2 (rectangle 30 20 "solid" "yellow"))
(define I3 (rectangle 40 50 "solid" "green"))
(define I4 (rectangle 60 50 "solid" "blue"))
(define I5 (rectangle 90 90 "solid" "orange"))

(define LOI1 (list I1 I2 I3 I4 I5))  ; mixed variety of rectangles
(define LOIw (list I2 I4))           ; only wide rectangles
(define LOIt (list I1 I3))           ; only tall rectangles


;; ============================
;; Helpers
;; ============================

;; Image -> Boolean
;; produce true if image is wide/tall/square
(check-expect (wide? I1) false)
(check-expect (wide? I2) true)
(check-expect (tall? I3) true)
(check-expect (tall? I4) false)
(check-expect (square? I1) false)
(check-expect (square? I2) false)
(check-expect (square? I5) true)

(define (wide?   img) (> (image-width img) (image-height img)))
(define (tall?   img) (< (image-width img) (image-height img)))
(define (square? img) (= (image-width img) (image-height img)))


;; Image -> Number
;; produce area of image
(check-expect (area I1) 200)
(check-expect (area I2) 600)

(define (area img)
  (* (image-width img)
     (image-height img)))


;; ============================
;; Abstract functions
;; ============================

;; Built-in abstract functions. Most programming languages have a set of those functions.
(check-expect (map positive? (list 1 -2 3 -4)) (list true false true false))
(check-expect (filter negative? (list 1 -2 3 -4)) (list -2 -4))
(check-expect (foldr + 0 (list 1 2 3)) (+ 1 2 3 0))
(check-expect (foldr * 1 (list 1 2 3)) (* 1 2 3 1))
(check-expect (build-list 6 identity) (list 0 1 2 3 4 5))
(check-expect (build-list 4 sqr) (list 0 1 4 9))


;; ============================
;; Functions using abstract functions and helpers
;; ============================

;; (listof Image) -> (listof Image)
;; produce list of only those images that are wide?
; (define (wide-only loi) empty) ;stub

(check-expect (wide-only (list I1 I2 I3 I4 I5)) (list I2 I4))

#;
(define (fn-for-filter lox)  ; template for wide-only using filter
  (filter ... lox))

(define (wide-only loi)
  (filter wide? loi))


;; (listof Image) -> Boolean
;; are all the images in loi tall?
; (define (all-tall? loi) false) ;stub

(check-expect (all-tall? LOI1) false)
(check-expect (all-tall? LOIw) false)
(check-expect (all-tall? LOIt) true)

(define (all-tall? loi)
  (andmap tall? loi))


;; (listof Number) -> Number
;; sum the elements of a list
; (define (sum lon) 0) ;stub

(check-expect (sum (list 1 2 3 4)) (+ 1 2 3 4))
(check-expect (sum (list 1 2 3 4 5 6 7 8 9 10)) (+ 1 2 3 4 5 6 7 8 9 10))

#;
(define (fn-for-foldr lon)  ; template for sum using foldr
  (foldr ... ... lon))

(define (sum lon)
  (foldr + 0 lon))


;; Natural -> Natural
;; produce the sum of the first n natural numbers
; (define (sum-to n) 0) ;stub

(check-expect (sum-to 0) 0)
(check-expect (sum-to 3) (+ 0 1 2))
(check-expect (sum-to 10) (+ 0 1 2 3 4 5 6 7 8 9))

#;
(define (fn-for-foldr-and-build-list n)  ; template for sum-to using foldr and built-list
  (foldr ... ... (build-list n ...)))

(define (sum-to n)
  (foldr + 0 (build-list n identity)))


;; ============================
;; Built-In Abstract Functions
;; ============================

;; Signatures for built-in functions

;; Natural (Natural -> X) -> (listof X)
;; produces (list (f 0) ... (f (- n 1)))
; (define (build-list n f) ...)

;; (X -> boolean) (listof X) -> (listof X)
;; produce a list from all those items on lox for which p holds
; (define (filter p lox) ...)

;; (X -> Y) (listof X) -> (listof Y)
;; produce a list by applying f to each item on lox
;; that is, (map f (list x-1 ... x-n)) = (list (f x-1) ... (f x-n))
; (define (map f lox) ...)

;; (X -> boolean) (listof X) -> boolean
;; produce true if p produces true for every element of lox
; (define (andmap p lox) ...)

;; (X -> boolean) (listof X) -> boolean
;; produce true if p produces true for some element of lox
; (define (ormap p lox) ...)

;; (X Y -> Y) Y (listof X) -> Y
;; (foldr f base (list x-1 ... x-n)) = (f x-1 ... (f x-n base))
; (define (foldr f base lox) ...)

;; (X Y -> Y) Y (listof X) -> Y
;; (foldl f base (list x-1 ... x-n)) = (f x-n ... (f x-1 base))
; (define (foldl f base lox) ...)
