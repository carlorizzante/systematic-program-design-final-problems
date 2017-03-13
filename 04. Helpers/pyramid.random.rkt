(require 2htdp/image)


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

;; Natural -> Image
;; Given n and s, returns a row on n images of size s
; (define (row n img) empty-image) ; stub

(check-expect (row 0 0) empty-image)
(check-expect (image-width (row 1 5)) 10)
(check-expect (image-width (row 3 7)) 42)

(define (row n s)
  (cond [(zero? n) empty-image]
        [else
         (beside (do-image s)
                 (row (sub1 n) s))]))


;; Natural Image -> Image
;; Given a natural n and a size s, returns a n-wide pyramid of s-sized images
; (define (pyramid n s) empty-image) ; stub

(check-expect (pyramid 0 0) empty-image)
(check-expect (image-width (pyramid 1 3)) 6)
(check-expect (image-height (pyramid 1 3)) 6)
(check-expect (image-width (pyramid 3 7)) 42)
(check-expect (image-height (pyramid 3 7)) 42)

(define (pyramid n s)
  (cond [(zero? n) empty-image]
        [else
         (above (pyramid (sub1 n) s)
                (row n s))]))


;; Natural Image -> Image
;; Given a natural n and a size s, returns an inverted n-wide pyramid of s-sized images
; (define (pyramid n s) empty-image) ; stub

(check-expect (inverted-pyramid 0 0) empty-image)
(check-expect (image-width (inverted-pyramid 1 3)) 6)
(check-expect (image-height (inverted-pyramid 1 3)) 6)
(check-expect (image-width (inverted-pyramid 3 7)) 42)
(check-expect (image-height (inverted-pyramid 3 7)) 42)

(define (inverted-pyramid n s)
  (cond [(zero? n) empty-image]
        [else
         (above (row n s)
                (inverted-pyramid (sub1 n) s))]))


;; Natural -> Image
;; Given a size s, returns a circle of size s, in random colors
; (define (do-image s) empty-image) ; stub

(check-expect (do-image 0) empty-image)
(check-expect (image-width (do-image 3)) 6)
(check-expect (image-width (do-image 9)) 18)

(define (do-image s)
  (circle s "solid" (make-color (random 255) (random 255) (random 255))))


;; =====================
;; Try out
;; =====================

(pyramid 3 5)
(pyramid 7 5)
(inverted-pyramid 5 5)

(beside
 (rotate 90 (above
             (pyramid 21 2)
             (inverted-pyramid 21 2)))
 (rotate 90 (above
             (pyramid 21 2)
             (inverted-pyramid 21 2)))
 (rotate 90 (above
             (pyramid 21 2)
             (inverted-pyramid 21 2)))
 (rotate 90 (above
             (pyramid 21 2)
             (inverted-pyramid 21 2))))
