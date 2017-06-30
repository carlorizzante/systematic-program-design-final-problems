(require 2htdp/image)

;; =================
;; Constants
;; =================

(define STEP (/ 2 5))
(define BASE 5)
(define B1 5)
(define B2 (/ BASE STEP))
(define B3 (/ BASE STEP STEP))

(define STYLE "solid")
(define COLOR "teal")

(define (crl s) (circle s STYLE COLOR))


;; =================
;; Functions
;; =================

;; Natural -> Image
;; Returns a circle fractal of a given size
; (define (circle-fractal s) empty-image) ; stub

(check-expect (circle-fractal 0) empty-image)
(check-expect (circle-fractal BASE) (crl BASE))
(check-expect (circle-fractal B2) (above
                                     (crl BASE)
                                     (beside
                                      (crl BASE) (crl B2) (crl BASE))
                                     (crl BASE)))

#; ;; <Template from Generative Recursion>
(define (genrec-fn d)
  (cond [(trivial? d) (trivial-answer d)]
        [else
         (... d
              (genrec-fn (next-problem d)))]))

(define (circle-fractal s)
  (cond [(<= s BASE) (crl s)]
        [else
         (above
          (leaf (* s STEP))
          (beside
           (rotate 90 (leaf (* s STEP)))
           (crl s)
           (rotate -90 (leaf (* s STEP))))
          (rotate 180 (leaf (* s STEP))))]))


;; Number -> Image
;; Render one side of the fractal image, this is where the real recursion takes place
; (define (leaf s) empty-image) ; stub

(check-expect (leaf 0) empty-image)
(check-expect (leaf BASE) (crl BASE))
(check-expect (leaf B2) (above
                         (crl B1)
                         (beside
                          (crl B1) (crl B2) (crl B1))))

(define (leaf s)
  (cond [(<= s BASE) (crl s)]
        [else
         (local [(define sub (leaf (* s STEP)))]
           (above
            sub
            (beside
             (rotate 90 sub) (crl s) (rotate -90 sub))))]))


;; =================
;; Try out
;; =================

(circle-fractal 35)
(circle-fractal 17)
