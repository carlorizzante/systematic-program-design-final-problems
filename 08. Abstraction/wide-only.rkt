(require 2htdp/image)

;; ==============================
;; Constants
;; ==============================

(define R1 (rectangle 10 20 "solid" "teal"))
(define R2 (rectangle 20 10 "solid" "teal"))
(define R3 (rectangle 20 30 "solid" "teal"))
(define R4 (rectangle 30 20 "solid" "teal"))
(define R5 (rectangle 30 40 "solid" "teal"))
(define R6 (rectangle 40 30 "solid" "teal"))
(define R8 (rectangle 40 40 "solid" "teal"))

(define R (list R1 R2 R3 R4 R5 R6))


;; ==============================
;; Functions
;; ==============================

;; (listof Image) -> (listof Image)
;; Given a list of Image, returns a sub list where all images are wider than tall
; (define (wide-only loi) empty) ; stub

(check-expect (wide-only empty) empty)
(check-expect (wide-only R) (list R2 R4 R6))

(define (wide-only loi)
  (filter wide? loi))


;; Image -> Boolean
;; Returns true if the image is wider than tall, false otherwise
; (define (wide? i) false) ; stub

(check-expect (wide? R1) false)
(check-expect (wide? R8) false)
(check-expect (wide? R2) true)

(define (wide? i) (> (image-width i) (image-height i)))
