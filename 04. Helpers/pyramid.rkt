(require 2htdp/image)


;; =====================
;; Constants
;; =====================

(define IMAGE (circle 5 "solid" "teal"))


;; =====================
;; Data Definitions
;; =====================

;; Natural is one of:
;;  - 0
;;  - (add1 Natural)
;; interp. a natural number
(define N0 0)         ;0
(define N1 (add1 N0)) ;1
(define N2 (add1 N1)) ;2

#;
(define (fn-for-natural n)
  (cond [(zero? n) (...)]
        [else
         (... n   ; n is added because it's often useful
              (fn-for-natural (sub1 n)))]))

;; Template rules used:
;;  - one-of: two cases
;;  - atomic distinct: 0
;;  - compound: 2 fields
;;  - self-reference: (sub1 n) is Natural


;; =====================
;; Functions
;; =====================

;; Natural Image -> Image
;; Given a natural n and an image, returns a row on n images
; (define (row n img) empty-image) ; stub

(check-expect (row 0 IMAGE) empty-image)
(check-expect (row 1 IMAGE) IMAGE)
(check-expect (row 3 IMAGE) (beside IMAGE IMAGE IMAGE))

(define (row n img)
  (cond [(zero? n) empty-image]
        [else
         (beside img
                 (row (sub1 n) img))]))


;; Natural Image -> Image
;; Given a natural n and an image, returns a pyramid of n-wide images
; (define (pyramid n i) empty-image) ; stub

(check-expect (pyramid 0 IMAGE) empty-image)
(check-expect (pyramid 1 IMAGE) IMAGE)
(check-expect (pyramid 3 IMAGE)
              (above IMAGE
                     (beside IMAGE IMAGE)
                     (beside IMAGE IMAGE IMAGE)))

(define (pyramid n img)
  (cond [(zero? n) empty-image]
        [else
         (above (pyramid (sub1 n) img)
                (row n img))]))


;; Natural Image -> Image
;; Given a natural n and an image, returns a pyramid of n-wide images
; (define (pyramid n i) empty-image) ; stub

(check-expect (inverted-pyramid 0 IMAGE) empty-image)
(check-expect (inverted-pyramid 1 IMAGE) IMAGE)
(check-expect (inverted-pyramid 3 IMAGE)
              (above (beside IMAGE IMAGE IMAGE)
                     (beside IMAGE IMAGE)
                     IMAGE))

(define (inverted-pyramid n img)
  (cond [(zero? n) empty-image]
        [else
         (above (row n img)
                (inverted-pyramid (sub1 n) img))]))


;; =====================
;; Try out
;; =====================

(pyramid 3 IMAGE)
(pyramid 7 IMAGE)
(inverted-pyramid 5 IMAGE)
