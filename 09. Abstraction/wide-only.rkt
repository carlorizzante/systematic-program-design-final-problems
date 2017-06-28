(require 2htdp/image)

;; =======================
;; Constants
;; =======================

(define I1 (rectangle 30 20 "solid" "blue"))
(define I2 (rectangle 30 40 "solid" "blue"))
(define I3 (rectangle 50 40 "solid" "blue"))
(define I4 (rectangle 50 60 "solid" "blue"))
(define I5 (rectangle 70 60 "solid" "blue"))
(define I6 (rectangle 70 80 "solid" "blue"))

(define LOI1 (list I1 I2 I3 I4 I5 I6))

;; =======================
;; Functions
;; =======================

;; (Listof Image) -> (Listof Image)
;; Returns a subset of the original list where images are wider than taller
; (define (wide-only loi) empty) ; stub

(check-expect (wide-only empty) empty)
(check-expect (wide-only LOI1) (list I1 I3 I5))

(define (wide-only loi)
  (local [(define (wide? i)
            (> (image-width i) (image-height i)))]
    (filter wide? loi)))
