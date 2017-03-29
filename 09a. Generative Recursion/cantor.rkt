(require 2htdp/image)
(require 2htdp/universe)


;; =========================
;; Contants
;; =========================

(define BASE 3)
(define HEIGHT 9)
(define STYLE "solid")
(define COLOR "teal")

(define B0 0)
(define B1 BASE)
(define B2 (* BASE 3))
(define B3 (* BASE 3 3))


;; =========================
;; Functions 1
;; =========================

;; Natural -> Image
;; Returns a Cantor Set image of a given size
; (define (cantor s) empty-image) ; stub

(check-expect (cantor 0) (rectangle 0 HEIGHT STYLE COLOR))
(check-expect (cantor B1) (rectangle BASE HEIGHT STYLE COLOR))
(check-expect (cantor B2) (above
                           (rectangle B2 HEIGHT STYLE COLOR)
                           (rectangle B2 HEIGHT STYLE "white")
                           (beside
                            (rectangle B1 HEIGHT STYLE COLOR)
                            (rectangle B1 HEIGHT STYLE "white")
                            (rectangle B1 HEIGHT STYLE COLOR))))
(check-expect (cantor B3) (above
                           (rectangle B3 HEIGHT STYLE COLOR)
                           (rectangle B3 HEIGHT STYLE "white")
                           (beside

                            (above
                             (rectangle B2 HEIGHT STYLE COLOR)
                             (rectangle B2 HEIGHT STYLE "white")
                             (beside
                              (rectangle B1 HEIGHT STYLE COLOR)
                              (rectangle B1 HEIGHT STYLE "white")
                              (rectangle B1 HEIGHT STYLE COLOR)))

                            (rectangle B2 HEIGHT STYLE "white")

                            (above
                             (rectangle B2 HEIGHT STYLE COLOR)
                             (rectangle B2 HEIGHT STYLE "white")
                             (beside
                              (rectangle B1 HEIGHT STYLE COLOR)
                              (rectangle B1 HEIGHT STYLE "white")
                              (rectangle B1 HEIGHT STYLE COLOR))))))


#; ;; <Template from Generative Recursion>
(define (genrec-fn d)
  (cond [(trivial? d) (trivial-answer d)]
        [else
         (... d
              (genrec-fn (next-problem d)))]))

(define (cantor s)
  (cond [(<= s BASE) (rect s)]
        [else
         (local [(define sub (cantor (/ s BASE)))]
         (above (rect s)
                (rectangle s HEIGHT STYLE "white")
                (beside
                 sub (rectangle (/ s BASE) HEIGHT STYLE "white") sub)))]))

;; Natural -> Image
;; Returns a rectangle of given size
(define (rect s) (rectangle s HEIGHT STYLE COLOR))

(check-expect (rect 0) (rectangle 0 HEIGHT STYLE COLOR))
(check-expect (rect BASE) (rectangle BASE HEIGHT STYLE COLOR))


;; =========================
;; Functions 2
;; =========================

;; Natural -> Image
;; Returns a Cantor Set image of a given size and the white space in percentage (use a fraction)

(define (cantor2 s ws)
  (cond [(<= s BASE) (rect s)]
        [else
         (local [(define sub (cantor2 (/ (- s (* s ws)) 2) ws))]
         (above (rect s)
                (rectangle s HEIGHT STYLE "white")
                (beside
                 sub (rectangle (* s ws) HEIGHT STYLE "white") sub)))]))

;; =========================
;; Try out
;; =========================

(cantor 200)
(cantor2 200 1/7)
