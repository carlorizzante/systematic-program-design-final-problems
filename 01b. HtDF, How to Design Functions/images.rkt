(require 2htdp/image)

(define I1 (rectangle 20 30 "solid" "teal"))
(define I2 (rectangle 40 30 "solid" "teal"))
(define I3 (square 45 "solid" "teal"))
(define I4 (circle 17 "solid" "teal"))
(define I5 (ellipse 60 30 "solid" "red"))

;; =========================

;; Image -> Number
;; Given an image, returns its area
; (define (image-area img) 0) ; stub

(check-expect (image-area I1) (* 20 30))
(check-expect (image-area I2) (* 40 30))
(check-expect (image-area I3) (* 45 45))
(check-expect (image-area I4) (* (* 2 17) (* 2 17)))

#;
(define (image-area img)
  (... img))

(define (image-area img)
  (* (image-width img) (image-height img)))

;; =========================

;; Image -> Boolean
;; Given an image, returns true if the image is tall, false otherwise
; (define (tall? img) false) ; stub

(check-expect (tall? I1) true)
(check-expect (tall? I2) false)
(check-expect (tall? I3) false)
(check-expect (tall? I4) false)

#;
(define (tall? img)
  (... img))

(define (tall? img)
  (> (image-height img) (image-width img)))

;; =========================

;; Image -> Image
;; Returns a given image enclosed in a box (outlined rectangle)
; (define (boxify img) empty-image) ; stub

(check-expect (boxify I1) (overlay (rectangle (image-width I1) (image-height I1) "outline" "black")
                                   I1))
(check-expect (boxify I4) (overlay (rectangle (image-width I4) (image-height I4) "outline" "black")
                                   I4))
(check-expect (boxify I5) (overlay (rectangle (image-width I5) (image-height I5) "outline" "black")
                                   I5))

#; ; template
(define (boxify img)
  (... img))

(define (boxify img)
  (overlay (rectangle (image-width img) (image-height img) "outline" "black")
           img))
