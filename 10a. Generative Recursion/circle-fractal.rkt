(require 2htdp/image)

;; =================
;; Constants
;; =================

(define STEP (/ 2 5))
(define BASE 5)
(define STYLE "solid")
(define COLOR "blue")


;; =================
;; Functions
;; =================

;; Natural -> Image
;; Returns a circle of the given size n, with default style and color
(define (mcircle n) (circle n STYLE COLOR))

;; Natural -> Image
;; Returns a fractal based on the given initial size
; (define (fractal n) empty-image) ; stub

(check-expect (fractal BASE) (mcircle BASE))
(check-expect (fractal (* BASE (/ 5 2))) (above (mcircle BASE)
                                                (beside (mcircle BASE) (mcircle (* BASE (/ 5 2))) (mcircle BASE))
                                                (mcircle BASE)))
#;
(define (fractal n)
  (cond [(<= n BASE) (mcircle n)]
        [else (local [(define step (* n STEP))
                      (define top (fractal step))
                      (define left (fractal step))
                      (define center (mcircle n))
                      (define right (fractal step))
                      (define bottom (fractal step))]
                (above top
                       (beside left center right)
                       bottom))]))

(define (leaf n)
  (cond [(<= n BASE) (mcircle n)]
        [else (above (leaf (* n STEP))
                     (beside
                      (rotate 90 (leaf (* n STEP)))
                      (mcircle n)
                      (rotate -90 (leaf (* n STEP)))))]))
; (leaf (* 5 (/ 5 2) (/ 5 2)))

(define (fractal n)
  (cond [(<= n BASE) (mcircle n)]
        [else (above (leaf (* n STEP))
                     (beside
                      (rotate 90 (leaf (* n STEP)))
                      (mcircle n)
                      (rotate -90 (leaf (* n STEP))))
                     (rotate 180 (leaf (* n STEP))))]))


;; =================
;; Try out
;; =================

(fractal (* 5 (/ 5 2))) ; small
(fractal (* 5 (/ 5 2) (/ 5 2))) ; big
(fractal (* 5 (/ 5 2) (/ 5 2) (/ 5 2)))
; (fractal (* 5 (/ 5 2) (/ 5 2) (/ 5 2) (/ 5 2))) ; even bigger
