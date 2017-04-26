(require 2htdp/image)

;; ==========================
;; Function definitions
;; ==========================

;; Defines a function bulb that returns a circle with a given color
(define (bulb color)
  (circle 20 "solid" color))

(above (bulb "red")
       (bulb "yellow")
       (bulb "green"))


;; Defines a function that returns the longest side of a right triangle, given the other two sides
(define (pythag a b)
  (sqrt (+ (sqr a) (sqr b))))

(pythag 3 4) ; 5


;; ==========================
;; Booleans and conditions
;; ==========================
;; Booleans are true, or false
;; Conditions returns a boolean given two arguments to compare

(< 400 900) ; true
(> 400 900) ; false
(= 3 3)     ; true

(string=? "abc" "abc") ; true

(> (image-width (rectangle 20 40 "solid" "red"))
   (image-width (rectangle 30 20 "solid" "red"))) ; false

(> (image-height (rectangle 20 40 "solid" "red"))
   (image-width (rectangle 30 20 "solid" "red"))) ; true

(if (> 5 4)
    (text "5 is greater than 4" 14 "teal") ; "5 is greater than 4"
    (text "5 is less than 4" 14 "red"))

(if (= 5 4)
    (text "5 is equal to 4" 14 "red")
    (text "5 is not equal to 4" 14 "teal")) ; "5 is not equal to 4"

(and (> 5 4)
     (= 3 3)) ; true

(or (< 5 4)
    (= 3 3))  ; true

(not (= 5 4)) ; true
