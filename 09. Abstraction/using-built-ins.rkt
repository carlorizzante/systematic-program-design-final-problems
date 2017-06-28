(require 2htdp/image)

;; ==========================
;; Constants
;; ==========================

;; Some setup data and functions to enable more interesting examples
;; below

(define I1 (rectangle 10 20 "solid" "red"))
(define I2 (rectangle 30 20 "solid" "yellow"))
(define I3 (rectangle 40 50 "solid" "green"))
(define I4 (rectangle 60 50 "solid" "blue"))
(define I5 (rectangle 90 90 "solid" "orange"))

(define LOI1 (list I1 I2 I3 I4 I5))


;; ==========================
;; Helpers
;; ==========================

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


;; ==========================
;; Functions operating on helpers
;; ==========================

(check-expect (map positive? (list 1 -2 3 -4)) (list true false true false))

(check-expect (filter negative? (list 1 -2 3 -4)) (list -2 -4))

(check-expect (foldr + 0 (list 1 2 3)) (+ 1 2 3 0))   ;foldr is abstraction
(check-expect (foldr * 1 (list 1 2 3)) (* 1 2 3 1))   ;of sum and product


(check-expect (build-list 6 identity) (list 0 1 2 3 4 5))

(check-expect (build-list 4 sqr) (list 0 1 4 9))


;; Returns a cumulative product of all elements in the given list by the predicate
(check-expect (foldr2 + 0 (list 1 2 3)) (+ 1 2 3 0))
(check-expect (foldr2 * 1 (list 1 2 3)) (* 1 2 3 1))

(define (foldr2 pred base lst)
  (cond [(empty? lst) base]
        [else (pred (first lst)
                   (foldr2 pred base (rest lst)))]))


;; (listof Image) -> (listof Image)
;; produce list of only those images that are wide?
(check-expect (wide-only (list I1 I2 I3 I4 I5)) (list I2 I4))

; (define (wide-only loi) empty) ;stub

#; ;; template
(define (wide-only loi)
  (filter ... loi))

(define (wide-only loi)
  (filter wide? loi))

(define (tall-only loi)
  (filter tall? loi))


;; (listof Image) -> Boolean
;; are all the images in loi tall?
(check-expect (all-tall? LOI1) false)
(check-expect (all-tall? (tall-only LOI1)) true)

; (define (all-tall? loi) false) ;stub

#; ;; template
(define (all-tall? loi)
  (andmap ... loi))

(define (all-tall? loi)
  (andmap tall? loi))


;; (listof Number) -> Number
;; sum the elements of a list
(check-expect (sum (list 1 2 3 4)) 10)

; (define (sum lon) 0) ;stub

#;
(define (sum lon)
  (foldr ... ... lon))

(define (sum lon)
  (foldr + 0 lon))


;; Natural -> Natural
;; produce the sum of the first n natural numbers
(check-expect (sum-to 3) (+ 0 1 2))

; (define (sum-to n) 0) ;stub

#;
(define (sum-to n)
  (foldr ... ... (build-list n ...)))

(define (sum-to n)
  (foldr + 0 (build-list n identity)))
