(require 2htdp/image)
(require 2htdp/universe)

;; =======================
;; Constants
;; =======================

(define BASE 2)
(define STEP (/ 1 3))
(define HEIGHT 17)
(define STYLE "solid")
(define COLOR "blue")
(define VPAD (rectangle 0 7 "solid" "white"))


;; =======================
;; Cantor 1
;; =======================

;; Natural -> Image
;; Renders a rectangle of the given width w and default HEIGHT, STYLE, and COLOR
(define (bar w) (rectangle w HEIGHT STYLE COLOR))

(check-expect (bar 3) (rectangle 3 HEIGHT STYLE COLOR))


;; Natural -> Image
;; Renders a rectangle of the given width w and default HEIGHT, STYLE, and COLOR
(define (hpad w) (rectangle (abs w) 0 "solid" "white"))

(check-expect (hpad 3) (rectangle 3 0 "solid" "white"))


;; Natural -> Image
;; Returns a cantor fractal starting from the given size n
; (define (cantor n) empty-image) ; stub

(check-expect (cantor BASE) (bar BASE))
(check-expect (cantor (* BASE 3)) (above (bar (* BASE 3))
                                         VPAD
                                         (beside (bar BASE) (hpad BASE) (bar BASE))))

(define (cantor n)
  (cond [(<= n BASE) (bar n)]
        [else (above (bar n)
                     VPAD
                     (beside (cantor (* n STEP))
                             (hpad (* n STEP))
                             (cantor (* n STEP))))]))


;; =======================
;; Cantor 2
;; =======================

;; Natural -> Image
;; Returns a cantor fractal starting from the given size n, and variable spacing s
; (define (cantor2 n s) empty-image) ; stub

(check-expect (cantor2 BASE (/ 1 3)) (bar BASE))
(check-expect (cantor2 (* BASE 3) (/ 1 3)) (above (bar (* BASE 3))
                                                  VPAD
                                                  (beside (bar BASE) (hpad BASE) (bar BASE))))
(check-expect (cantor2 (* BASE 3) (/ 1 5)) (above (bar (* BASE 3))
                                                  VPAD
                                                  (local [(define wbar (* 3 BASE (/ 1 5)))
                                                          (define wpad (- (* 3 BASE) (* wbar 2)))]
                                                    (beside (bar wbar)
                                                            (hpad wpad)
                                                            (bar wbar)))))


(define (cantor2 n s)
  (cond [(<= n BASE) (bar n)]
        [else (above (bar n)
                     VPAD
                     (local [(define wbar (* n s))
                             (define wpad (- n (* wbar 2)))]
                       (beside (cantor2 wbar s)
                               (hpad wpad)
                               (cantor2 wbar s))))]))


;; =======================
;; Try out
;; =======================

(cantor (* BASE 3 3 3 3))
(cantor2 (* BASE 3 3 3 3) (/ 1 2))
(cantor2 (* BASE 3 3 3 3) (/ 1 4))


;; =======================
;; Cantor Universe
;; =======================

(define WSCENE 400)
(define HSCENE 240)
(define SPAD 40)
(define WCANTOR (- WSCENE SPAD))
(define MTS (overlay (rectangle WSCENE HSCENE "solid" "white")
                     (empty-scene WSCENE HSCENE)))

;; Ratio -> Ratio
;; Launch with (run 0)

(define (run x)
  (main (/ 1 3)))

(define (main ratio)
  (big-bang ratio                     ; Ratio
            (on-tick   tock)          ; Ratio -> Ratio
            (on-mouse  handle-mouse)  ; Ratio -> Integer Integer MouseEvent -> Ratio
            (to-draw   render)        ; Ratio -> Image
            ))


;; Ratio -> Ratio
;; Updates the ratio

(define (tock ratio) ratio)


;; Ratio -> Image
;; Renders the Image

; (check-expect (render empty) MTS)
(check-expect (render (/ 1 3)) (place-image
                                (cantor2 WCANTOR (/ 1 3))
                                (/ WSCENE 2) (/ HSCENE 2)
                                MTS))

(define (render ratio) (place-image
                        (cantor2 WCANTOR ratio)
                        ; (text (number->string ratio) 14 "black")
                        (/ WSCENE 2) (/ HSCENE 2)
                        MTS))


;; WS Integer Integer MouseEvent -> WS
;; Updates WS on Mouse Event
(define (handle-mouse ratio x y me)
  (local [(define div (+ 2 (* 2 (/ x WSCENE))))
          (define nratio (/ 1 div))]
    (cond [(> nratio (/ 1 2)) (/ 1 2)]
          [(< nratio (/ 1 4)) (/ 1 4)]
          [else (abs nratio)])))
