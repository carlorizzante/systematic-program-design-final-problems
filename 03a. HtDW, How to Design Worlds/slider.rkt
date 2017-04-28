(require 2htdp/image)
(require 2htdp/universe)

;; ===========================
;; Constants
;; ===========================

(define WIDTH 600)
(define HEIGHT 400)
(define CTR-Y (/ HEIGHT 2)) ; height of slider on the y-axis
(define MTS (empty-scene WIDTH HEIGHT))
(define SLIDER (rectangle 20 10 "solid" "teal"))
(define SPEED 3) ; rate of change on the x-axis


;; ===========================
;; Data definition
;; ===========================

;; Pos is Number
;; Position of the slider in x coordinates

(define P1 0)              ; left edge of the screen
(define P2 (/ WIDTH 2))    ; middle of the screen
(define P3 WIDTH)          ; right edge of the screen

#;
(define (fn-for-pos pos)
  (... pos))

;; Template rules:
;; - Atomic Non-Distinct      Number

;; ===========================
;; Functions
;; ===========================

;; Pos -> Pos
;; Launch with (main 0)
(define (main pos)
  (big-bang pos                      ; Pos
            (on-tick   tock)         ; Pos -> Pos
            (to-draw   render)       ; Pos -> Image
            (on-key    handle-key)   ; Pos KeyEvent -> Pos
            (on-mouse  handle-mouse) ; Pos X Y ME -> Pos
            ))


;; Pos -> Pos
;; Updates the state, x coordinates of SLIDER, by SPEED pixel(s)
; (define (tock pos) 0) ; stub

(check-expect (tock 0) (+ 0 SPEED))
(check-expect (tock 20) (+ 20 SPEED))

; Template from Pos

(define (tock pos)
  (+ pos SPEED))


;; Pos -> Image
;; Renders the scene...
; (define (render pos) MTS) ; stub

(check-expect (render 0) (place-image SLIDER 0 CTR-Y MTS))
(check-expect (render 100) (place-image SLIDER 100 CTR-Y MTS))

; Template from Pos

(define (render pos)
  (place-image SLIDER pos CTR-Y MTS))


;; Pos KeyEvent -> Pos
;; Handles Key Events, resets Pos to 0
; (define (handle-key pos key) 0) ; stub

(check-expect (handle-key 0 " ") 0)
(check-expect (handle-key 100 " ") 0)
(check-expect (handle-key 100 "a") 100)
(check-expect (handle-key 270 "k") 270)

; Template from Key Events

(define (handle-key pos key)
  (cond [(key=? key " ") 0]
        [else pos]))


;; Pos X Y ME -> Pos
;; Handles Mouse Events, set Pos to X
; (define (handle-mouse pos x y me) 0) ; stub

(check-expect (handle-mouse 100 10 20 "button-down") 10)
(check-expect (handle-mouse 310 234 124 "button-down") 234)
(check-expect (handle-mouse 310 234 124 "button-up") 310)

; Template from Mouse Events

(define (handle-mouse pos x y me)
  (cond [(mouse=? me "button-down") x]
        [else pos]))
