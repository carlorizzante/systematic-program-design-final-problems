(require 2htdp/image)

(define I1 (rectangle 20 30 "solid" "red"))
(define I2 (rectangle 30 20 "solid" "red"))
(define I3 (rectangle 30 50 "solid" "red"))

;; image Image -> Boolean
;; Returns true if the first of two images is larger than the second, false otherwise
; (define (larger? img1 img2) false) ; stub

(check-expect (larger? I1 I2) false)
(check-expect (larger? I2 I1) true)
(check-expect (larger? I2 I3) false)

#; ; template
(define (larger? img1 img2)
  (... img1 img2))

(define (larger? img1 img2)
  (> (image-width img1) (image-width img2)))
