(require 2htdp/image)

(define I1 (rectangle 10 20 "solid" "red"))
(define I2 (rectangle 20 20 "solid" "red"))
(define I3 (rectangle 20 10 "solid" "red"))

;; Image -> String
;; Returns the ratio of an image, "tall", "wide", or "square"
; (define (aspect-ratio img) "") ; stub

(check-expect (aspect-ratio I1) "tall")
(check-expect (aspect-ratio I2) "square")
(check-expect (aspect-ratio I3) "wide")

#; ; template
(define (aspect-ratio img)
  (... img))

#; ; previous version using nested "if" statement
(define (aspect-ratio img)
  (if (> (image-height img) (image-width img))
      "tall"
      (if (= (image-height img) (image-width img))
          "square"
          "wide")))

; Final version using a conditional expression
(define (aspect-ratio img)
  (cond [(> (image-height img) (image-width img)) "tall"]
        [(< (image-height img) (image-width img)) "wide"]
        [else "square"]))

;; ========================

;; Number -> Number
;; Returns the absolute value of a given number

(check-expect (absval 0) 0)
(check-expect (absval 3) 3)
(check-expect (absval -2) 2)

(define (absval n)
  (cond [(> n 0) n]
        [(< n 0) (* -1 n)]
        [else 0]))

;; ========================

;; Step by step for (absval -3)

; 1
(absval -3)

; 2
(cond [(> -3 0) -3]
      [(< -3 0) (* -1 -3)]
      [else 0])

; 3
(cond [false -3]
      [(< -3 0) (* -1 -3)]
      [else 0])

; 4
(cond [(< -3 0) (* -1 -3)]
      [else 0])

; 5
(cond [true (* -1 -3)]
      [else 0])

; 6
(cond [true 3]
      [else 0])

; 7
3

;; ========================

;; Number -> String
;; Given a number n, assesses if n is positive, negative, or zero
; (define (pos? n) "") ; stub

(check-expect (pos? 0) "zero")
(check-expect (pos? 2.2) "positive")
(check-expect (pos? -3) "negative")

#; ; template
(define (pos? n)
  (cond [(... n) ...]
        [else (... n)]))

(define (pos? n)
  (cond [(> n 0) "positive"]
        [(< n 0) "negative"]
        [else "zero"]))
