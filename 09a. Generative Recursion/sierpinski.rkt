
(require 2htdp/image)

;; =======================
;; Constants
;; =======================

(define BASE 2)            ; Baseline size for Sierpinski images
(define STYLE "outline")   ; Default style for images
(define COLOR "teal")      ; Default color for images


;; ==================================
;; Functions for Sierpinsky Triangle
;; ==================================

;; Natural -> Image
;; Returns a triangle of a given size
; (define (tri s) empty-image) ; stub

(check-expect (tri 0) (triangle 0 STYLE COLOR))
(check-expect (tri 3) (triangle 3 STYLE COLOR))
(check-expect (tri 17) (triangle 17 STYLE COLOR))

(define (tri s) (triangle s STYLE COLOR))


;; Natural -> Image
;; Returns a Sierpinski Triangle of the given size
; (define (stri s) empty-image) ; stub

(check-expect (stri 0) (tri 0))
(check-expect (stri BASE) (tri BASE))
(check-expect (stri (* 2 BASE)) (overlay
                        (tri (* 2 BASE))
                        (above (tri BASE)
                               (beside (tri BASE) (tri BASE)))))

#; ;; <Template from Generative Recursion>
(define (genrec-fn d)
  (cond [(trivial? d) (trivial-answer d)]
        [else
         (... d
              (genrec-fn (next-problem d)))]))

;; Base case: (<= s BASE)
;; Reduction step: (/ s 2)
;; Argument: for BASE > 0, s will reach Base case
(define (stri s)
  (cond [(<= s BASE) (tri s)]
        [else
         (overlay (tri s)
                  (local [(define sub (stri (/ s 2)))]
                    (above sub
                           (beside sub sub))))]))


;; ==================================
;; Functions for Sierpinsky Carpet
;; ==================================

;; Natural -> Image
;; Returns a square of a given size
; (define (sq s) empty-image) ; stub

(check-expect (sq 0) (square 0 STYLE COLOR))
(check-expect (sq 3) (square 3 STYLE COLOR))
(check-expect (sq 17) (square 17 STYLE COLOR))

(define (sq s) (square s STYLE COLOR));


;; Natural -> Image
;; Returns an empty square of a given size
; (define (esq s) empty-image) ; stub

(check-expect (esq 0) (square 0 "solid" "white"))
(check-expect (esq 3) (square 3 "solid" "white"))
(check-expect (esq 17) (square 17 "solid" "white"))

(define (esq s) (square s "solid" "white"));


;; Natural -> Image
;; Returns a Sierpinski Square of a given size
; (define (ssq s) empty-image) ; stub

(check-expect (ssq 0) (sq 0))
(check-expect (ssq BASE) (sq BASE))
(check-expect (ssq (* BASE 3)) (overlay
                                (sq (* BASE 3))
                                (above
                                 (beside
                                  (sq BASE) (sq BASE) (sq BASE))
                                 (beside
                                  (sq BASE) (esq BASE) (sq BASE))
                                 (beside
                                  (sq BASE) (sq BASE) (sq BASE)))))

#; ;; <Template from Generative Recursion>
(define (genrec-fn d)
  (cond [(trivial? d) (trivial-answer d)]
        [else
         (... d
              (genrec-fn (next-problem d)))]))

;; Base case: (<= s BASE)
;; Reduction step: (/ s 3)
;; Argument: for BASE > 0, s will reach Base case
(define (ssq s)
  (cond [(<= s BASE) (sq s)]
        [else
         (overlay (sq s)
                  (local [(define sub (ssq (/ s 3)))]
                    (above
                     (beside sub sub sub)
                     (beside sub (esq (/ s 3)) sub)
                     (beside sub sub sub))))]))


;; =======================
;; Try out
;; =======================

(stri (* 3 3 3 3 BASE))
(ssq (* 3 3 3 3 BASE))
