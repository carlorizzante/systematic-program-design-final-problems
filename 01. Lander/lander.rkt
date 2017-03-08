(require 2htdp/image)
(require 2htdp/universe)

;
; A Moon Landing game (sort of), the player has to land a simplistic
; representation of a lunar lander to the bottom of the canvas.
;
; Keys:
; - spacebar > trusters, accelerate the ship upwards
; - r        > reset the game


;; =====================
;; Constants
;; =====================


(define WIDTH 400)                               ; screen width
(define HEIGHT 600)                              ; screen height
(define MTS (empty-scene WIDTH HEIGHT))          ; empty scene
(define X (/ WIDTH 2))                           ; initial x pos
(define Y (/ HEIGHT 4))                          ; initial y pos
(define DY -4)                                   ; initial dy
(define G 0.2)                                   ; gravity, affect acceleration on y-axis
(define T 4)                                     ; trusters, has to be higher that G
(define SW 40)                                   ; ship width
(define SH 10)                                   ; ship height
(define SHIP (rectangle SW SH "solid" "black"))  ; ship, visual representation


;; =====================
;; Data definitions
;; =====================


(define-struct ship (x y dy))
;; Ship is (make-ship (0, WIDTH) (0, HEIGHT) Integer)
;; - x is current x coordinate of the ship
;; - y is current y coordinate of the ship
;; - dy is acceleration on the y-axis of the ship

(define S1 (make-ship (/ WIDTH 2) 10 0))       ; ship at the middle-top of the screen, stationary
#;
(define (fn-for-ship s)
  (... (ship-x s)                              ; Integer [0, WIDTH]
       (ship-y s)                              ; Integer [0, HEIGHT]
       (ship-dy s)))                           ; Integer

;; Template rules used:
;; - compound data with 3 fields


;; =====================
;; Functions
;; =====================


;; Ship -> Ship
;; tracks the pos of a landing ship, and its vertical velocity
;; game ends when the ship land safely or crash on the bottom side of the screen
;; no tests for main function
(define (main s)
  (big-bang s
            (on-tick next-ship)                ; Ship -> Ship
            (on-draw render-scene)             ; Ship -> Image
            (on-key handle-keys)))             ; Ship KeyEvent -> Ship


;; start the universe with (run 1)
(define (run i)
  (main (make-ship X Y DY)))


;; Ship -> Ship
;; updates pos of ship and its vertical velocity
; (define (next-ship s) s) ; stub

; start game
(check-expect (next-ship (make-ship X Y DY)) (make-ship X (+ Y DY) (+ DY G)))
; middle game
(check-expect (next-ship (make-ship X 100 10)) (make-ship X (+ 100 10) (+ 10 G)))
; end game
(check-expect (next-ship (make-ship X (- HEIGHT (/ SH 2)) 0)) (make-ship X (- HEIGHT (/ SH 2)) 0))

;<template from Ship>

(define (next-ship s)
  (cond [(< (ship-y s) (- HEIGHT (/ SH 2))) (make-ship (ship-x s) (+ (ship-y s) (ship-dy s)) (+ (ship-dy s) G))]
        [else (make-ship (ship-x s) (- HEIGHT (/ SH 2)) 0)]))


;; Ship -> Image
;; render the scene, background and ship
; (define (render-scene s) MTS) ; stub

(check-expect (render-scene (make-ship X Y DY))
              (place-image SHIP X Y (overlay
                                     (ship-info (make-ship X Y DY))
                                     (rectangle WIDTH HEIGHT "solid" "teal") MTS)))

;<template from Ship>

(define (render-scene s)
 (place-image
  SHIP (ship-x s) (ship-y s)
  (overlay
   (ship-info s)
   (rectangle WIDTH HEIGHT "solid" "teal") MTS)))


;; Ship KeyEvent -> Ship
;; handles the controls for the ship
; (define (handle-keys s ke) s) ; stub

(check-expect (handle-keys (make-ship 50 100 10) " ") (make-ship 50 100 (- 10 T)))  ; trusters
(check-expect (handle-keys (make-ship 50 100 10) "r") (make-ship X Y DY))            ; reset game
(check-expect (handle-keys (make-ship 50 100 10) "a") (make-ship 50 100 10))        ; not implemented

;<template from Ship>

(define (handle-keys s ke)
  (cond [(key=? ke " ") (make-ship (ship-x s) (ship-y s) (- (ship-dy s) T))]
        [(key=? ke "r") (make-ship X Y DY)]
        [else (make-ship (ship-x s) (ship-y s) (ship-dy s))]))


;; Ship -> Image
;; display dy of the ship
; (define (ship-info s) (rectangle 20 20 "solid" "white")) ; stub

(check-expect (ship-info (make-ship X Y DY))
              (beside
               (rectangle 4 0 "solid" "teal")
               (overlay
                (text (number->string (* DY (/ 1 G))) 18 "white")
                (rectangle 40 40 "solid" "teal"))
               (rectangle (- WIDTH 44) 0 "solid" "teal")))

;<template from Ship>

(define (ship-info s)
  (beside
   (rectangle 4 0 "solid" "teal")
   (overlay
    (text (number->string (* (ship-dy s) (/ 1 G))) 18 "white")
    (rectangle 40 40 "solid" "teal"))
   (rectangle (- WIDTH 44) 0 "solid" "teal")))
