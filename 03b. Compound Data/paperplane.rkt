(require 2htdp/image)
(require 2htdp/universe)

;; ====================
;; Constants
;; ====================

(define WIDTH 600)
(define HEIGHT 400)
(define CTR-Y (/ HEIGHT 2))
(define MTS (empty-scene WIDTH HEIGHT))
(define SPEED 15)

(define RPP (rotate -90 (triangle 15 "solid" "teal")))
(define LPP (rotate  180 RPP))

(define LIMIT (/ (image-width RPP) 2))



;; ====================
;; Data definition
;; ====================

(define-struct pp (x dx))
;; PP is (make-pp Natural[0, WIDTH] Integer)
;; Interpretation: an animation of a paper plane with x-coordinate on screen, and vector velocity +/-
;; - x          current position of the paper plane on the x-axis (center of the sprite) in pixels
;; - dx         current speed/direction of the paper plane in pixelx per tick

(define PP1 (make-pp 0 SPEED))             ; Left edge of the screen
(define PP2 (make-pp (/ WIDTH 2) SPEED))   ; Center of the screen
(define PP3 (make-pp WIDTH SPEED))         ; Right edge of the screen
(define PP4 (make-pp 250 (* -1 SPEED)))    ; PP moving backwards (right to left)

#;
(define (fn-for-pp c)
  (... (pp-x c)     ;; Natural[0, WIDTH]
       (pp-dx c)    ;; Integer
       ))

;; Template rules used:
;; - Compound with 2 fields
;; -- Natural[0, WIDTH]     position on the x-axis
;; -- Integer               speed +/-


;; ====================
;; Functions
;; ====================

;; PP -> PP
;; Launch with (run 0)
(define (main pp)
  (big-bang pp                       ; PP
            (on-tick   tock)        ; PP -> PP
            (to-draw   render)      ; PP -> Image
            (on-key    handle-key)  ; PP KeyEvent -> PP
            ))

(define (run n)
  (main (make-pp LIMIT SPEED)))


;; PP -> PP
;; Updates the state, the pp should bounce once touches the edges
;; !!!
; (define (tock pp) pp) ; stub

(check-expect (tock PP2) (make-pp (+ (pp-x PP2) (pp-dx PP2)) (pp-dx PP2)))
(check-expect (tock PP4) (make-pp (+ (pp-x PP4) (pp-dx PP4)) (pp-dx PP4)))

(define (tock pp)
  (cond [(> (pp-x pp) (- WIDTH LIMIT)) (make-pp (- WIDTH LIMIT) (* SPEED -1))]
        [(< (pp-x pp) LIMIT) (make-pp LIMIT SPEED)]
        [else (make-pp (+ (pp-x pp) (pp-dx pp)) (pp-dx pp))]))


;; PP -> Image
;; Renders the paper plane on the scene depending on its direction of movement
;; !!!
; (define (render pp) empty-image) ; stub

(check-expect (render PP2) (place-image RPP (pp-x PP2) CTR-Y MTS))
(check-expect (render PP4) (place-image LPP (pp-x PP4) CTR-Y MTS))

(define (render pp)
  (if (> (pp-dx pp) 0)
      (place-image RPP (pp-x pp) CTR-Y MTS)
      (place-image LPP (pp-x pp) CTR-Y MTS)))


;; PP KeyEvent -> PP
;; Updates PP on specific key events
;; !!!
; (define (handle-key pp ke) c) ; stub

(check-expect (handle-key PP2 "a") PP2)
(check-expect (handle-key PP2 " ") (make-pp (pp-x PP2) (* (pp-dx PP2) -1)))
(check-expect (handle-key PP4 " ") (make-pp (pp-x PP4) (* (pp-dx PP4) -1)))

(define (handle-key pp ke)
  (cond [(string=? ke " ") (make-pp (pp-x pp) (* (pp-dx pp) -1))]
        [else (make-pp (pp-x pp) (pp-dx pp))]))
