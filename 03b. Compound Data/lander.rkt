(require 2htdp/image)
(require 2htdp/universe)

;; =================
;; Constants:

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
(define F 20)                                    ; liquid fuel available the ship


;; =================
;; Data definitions:

(define-struct ship (x y dy f))
;; Ship is (make-ship (0, WIDTH) (0, HEIGHT) Integer)
;; - x is current x coordinate of the ship
;; - y is current y coordinate of the ship
;; - dy is acceleration on the y-axis of the ship
;; - f is fuel on the ship

(define S1 (make-ship (/ WIDTH 2) 10 0 F))       ; ship at the middle-top of the screen, stationary
#;
(define (fn-for-ship s)
  (... (ship-x s)                              ; Integer [0, WIDTH]
       (ship-y s)                              ; Integer [0, HEIGHT]
       (ship-dy s)                             ; Integer
       (ship-f s)))                            ; Integer [0, ...)

;; Template rules used:
;; - compound data with 4 fields


;; =================
;; Functions:

;; Ship -> Ship
;; tracks the pos of a landing ship, and its vertical velocity
;; game ends when the ship land safely or crash on the bottom side of the screen
;; no tests for main function
(define (main s)
  (big-bang s
            (on-tick next-ship)                ; Ship -> Ship
            (on-draw render-scene)             ; Ship -> Image
            (on-key handle-keys)))             ; Ship KeyEvent -> Ship


;; start the universe with (run 0)
(define (run i)
  (main (make-ship X Y DY F)))


;; Ship -> Ship
;; updates pos of ship and its vertical velocity
; (define (next-ship s) s f) ; stub

; start game, ship starts to fall towards the bottom
(check-expect (next-ship (make-ship X Y DY F)) (make-ship X (+ Y DY) (+ DY G) F))
; middle game, ship accelerates towards the bottom
(check-expect (next-ship (make-ship X 100 10 10)) (make-ship X (+ 100 10) (+ 10 G) 10))
; end game, ship is stationary on the bottom
(check-expect (next-ship (make-ship X (- HEIGHT (/ SH 2)) 0 20)) (make-ship X (- HEIGHT (/ SH 2)) 0 20))
; ship run out of liquid fuel (control is in handle-keys fn)
(check-expect (next-ship (make-ship X 100 10 0)) (make-ship X (+ 100 10) (+ 10 G) 0))

;<template from Ship>

(define (next-ship s)
  (cond [(< (ship-y s) (- HEIGHT (/ SH 2))) (make-ship (ship-x s) (+ (ship-y s) (ship-dy s)) (+ (ship-dy s) G) (ship-f s))]
        [else (make-ship (ship-x s) (- HEIGHT (/ SH 2)) 0 (ship-f s))]))


;; Ship -> Image
;; render the scene, background and ship
; (define (render-scene s) MTS) ; stub

(check-expect (render-scene (make-ship X Y DY F))
              (place-image SHIP X Y (overlay
                                     (ship-info (make-ship X Y DY F))
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

(check-expect (handle-keys (make-ship 50 100 10 20) " ") (make-ship 50 100 (- 10 T) 19))  ; trusters
(check-expect (handle-keys (make-ship 50 100 10 0) " ") (make-ship 50 100 10 0))          ; no liquid fuel
(check-expect (handle-keys (make-ship 50 100 10 20) "r") (make-ship X Y DY F))            ; reset game
(check-expect (handle-keys (make-ship 50 100 10 20) "a") (make-ship 50 100 10 20))        ; invalid key

;<template from Ship>

(define (handle-keys s ke)
  (cond [(key=? ke " ")
         (if (> (ship-f s) 0)
             (make-ship (ship-x s) (ship-y s) (- (ship-dy s) T) (- (ship-f s) 1))
             (make-ship (ship-x s) (ship-y s) (ship-dy s) (ship-f s)))]
        [(key=? ke "r") (make-ship X Y DY F)]
        [else (make-ship (ship-x s) (ship-y s) (ship-dy s) (ship-f s))]))


;; Ship -> Image
;; display dy of the ship
; (define (ship-info s) (rectangle 20 20 "solid" "white")) ; stub

(check-expect (ship-info (make-ship X Y DY F))
              (beside
               (rectangle 4 0 "solid" "teal")
               (overlay
                (above
                 (text (format "dy ~a" (* DY (/ 1 G))) 18 "white")
                 (rectangle 0 4 "solid" "teal")
                 (text (format "lf ~a" F) 18 "white"))
                (rectangle 80 40 "solid" "teal"))
               (rectangle (- WIDTH 84) 0 "solid" "teal")))

;<template from Ship>

(define (ship-info s)
  (beside
   (rectangle 4 0 "solid" "teal")
   (overlay
    (above
     (text (format "dy ~a" (* (ship-dy s) (/ 1 G))) 18 "white")
     (rectangle 0 4 "solid" "teal")
     (text (format "lf ~a" (ship-f s)) 18 "white"))
    (rectangle 80 40 "solid" "teal"))
   (rectangle (- WIDTH 84) 0 "solid" "teal")))
