(require 2htdp/image)
(require 2htdp/universe)

;; A water balloon, falling and bouncing until it goes off screen
;; the balloon rotates while falling and bouncing
;; pressing the space bar repositions the balloon at the top left of the screen


;; ===================
;; Constants
;; ===================

(define WIDTH 600)                            ; screen width
(define HEIGHT 400)                           ; screen height
(define MTS (empty-scene WIDTH HEIGHT))       ; empty scene
(define START-X 0)                            ; starting point x coordinate
(define START-Y 0)                            ; starting point y coordinate
(define DX (+ (random 10) 7))                 ; initial delta x (speed on x-axis)
(define DY 0)                                 ; initial delta y (speed on y-axis)
(define DR (+ (random 3) 1))                  ; delta r (rotation speed)
(define G (+ (random 2) 1))                   ; gravity, affect acceleration on y-axis
(define EN 5)                                 ; entropy, loss of energy on bouncing
(define BALLOON .)              ; the image of a wonderful balloon


;; ===================
;; Data definitions
;; ===================

(define-struct balloon (x y dx dy r))
;; Balloon is (make-balloon (0, WIDTH) (0, HEIGHT) Integer Integer (0, 360])
;; - x is current x coordinate of balloon
;; - y is current y coordinate of balloon
;; - dx is next step speed/distance on the x axis of balloon
;; - dy is next step speed/distance on the y axis of balloon
;; - r is current rotation of the balloon

(define B1 (make-balloon 10 20 3 5 120))    ; Balloon at 10,20 moving right,down 3,5 rotated 120 degree
(define B2 (make-balloon 50 90 3 -5 180))   ; Balloon at 50,90 moving right,up 3,-5 rotated 180 degree
#;
(define (fn-for-balloon b)
  (... (balloon-x b)                        ; Integer [0, WIDTH]
       (balloon-y b)                        ; Integer [0, WIDTH]
       (balloon-dx b)                       ; Integer [0, ...)
       (balloon-dy b)                       ; Integer [0, ...)
       (balloon-r b)))                      ; Integer [0, 360)

;; Template rules used:
;; - compount data with 5 fields


;; ===================
;; Functions
;; ===================

;; Balloon -> Balloon
;; change the x,y coordinate of a tossed balloon across the screen
;; space bar reset the universe (balloon reposition at initial x,y)
;; no tests for main function
(define (main b)
  (big-bang b
            (on-tick next-balloon)         ; Balloon -> Balloon
            (on-draw render-balloon)       ; Balloon -> Image
            (on-key handle-key)))          ; Balloon KeyElement -> Balloon

;; start the universe with (run 1)
(define (run i)
  (main (make-balloon START-X START-Y DX DY 0)))


;; Balloon -> Balloon
;; move the balloon across the screen
;; dx,dy are added to x,y coordinate
;; r is increased by dr per tick
;; balloon bounces against walls
;; when bounces, all |speed| decreases by 1, until 0
; (define (next-balloon b) b) ; stub

; normal cases, moving across the screen, up or falling
(check-expect (next-balloon (make-balloon 10 20 3 3 0)) (make-balloon 13 23 3 (+ 3 G) (* -3 DR)))
(check-expect (next-balloon (make-balloon 10 20 -3 -3 0)) (make-balloon 7 17 -3 (+ -3 G) (* 3 DR)))

; balloon should be able to touch borders
(check-expect (next-balloon (make-balloon (- WIDTH 3) 100 3 3 0)) (make-balloon WIDTH 103 3 (+ 3 G) (* -3 DR)))
(check-expect (next-balloon (make-balloon 3 100 -3 3 0)) (make-balloon 0 103 -3 (+ 3 G) (* 3 DR)))
(check-expect (next-balloon (make-balloon 100 (- HEIGHT 3) 3 3 0)) (make-balloon 103 HEIGHT 3 (+ 3 G) (* -3 DR)))
(check-expect (next-balloon (make-balloon 100 3 3 -3 0)) (make-balloon 103 0 3 (+ -3 G) (* -3 DR)))

; balloon should bounce against edges on the x-axis and reverse dx
(check-expect (next-balloon (make-balloon (- WIDTH 1) 100 3 3 0)) (make-balloon WIDTH 103 -3 (+ 3 G) (* -3 DR)))
(check-expect (next-balloon (make-balloon 1 100 -3 3 0)) (make-balloon 0 103 3 (+ 3 G) (* 3 DR)))

; balloon should bounce against edges on the y-axis and reverse dy
; dx should reduce accordingly (for positive and negative values of dx)
(check-expect (next-balloon (make-balloon 100 (- HEIGHT 1) 3 3 0)) (make-balloon 103 HEIGHT 2 (- (- 3 EN)) (* -3 DR)))
(check-expect (next-balloon (make-balloon 100 (- HEIGHT 1) -3 3 0)) (make-balloon 97 HEIGHT -2 (- (- 3 EN)) (* 3 DR)))
(check-expect (next-balloon (make-balloon 100 1 -3 -3 0)) (make-balloon 97 0 -3 3 (* 3 DR)))

; dx should stay at 0 once reaches 0
(check-expect (next-balloon (make-balloon 100 100 0 3 0)) (make-balloon 100 103 0 (+ 3 G) 0))

(define (next-balloon b)
  (make-balloon
   ; bounce against x-axis
   (cond [(> (+ (balloon-x b) (balloon-dx b)) WIDTH) WIDTH]
         [(< (+ (balloon-x b) (balloon-dx b)) 0) 0]
         [else (+ (balloon-x b) (balloon-dx b))])
   ; bounce against y-axis
   (cond [(> (+ (balloon-y b) (balloon-dy b)) HEIGHT) HEIGHT]
         [(< (+ (balloon-y b) (balloon-dy b)) 0) 0]
         [else (+ (balloon-y b) (balloon-dy b))])
   ; calc dx
   (cond [(= (balloon-dx b) 0) 0] ; keep dx at 0 when it's done
         [(> (+ (balloon-y b) (balloon-dy b)) HEIGHT) ; decrease |dx| when bouncing on bottom side
          (if (> (balloon-dx b) 0) (- (balloon-dx b) 1) (+ (balloon-dx b) 1))]
         [(> (+ (balloon-x b) (balloon-dx b)) WIDTH) (- (balloon-dx b))]
         [(< (+ (balloon-x b) (balloon-dx b)) 0) (- (balloon-dx b))]
         [else (balloon-dx b)])
   ; calc dy
   (cond [(> (+ (balloon-y b) (balloon-dy b)) HEIGHT) (- (- (balloon-dy b) EN))]
         [(< (+ (balloon-y b) (balloon-dy b)) 0) (- (balloon-dy b))]
         [else (+ (balloon-dy b) G)])
   ; calc rotation
   (- (balloon-r b) (* DR (balloon-dx b)))))


;; Balloon -> Image
;; render ballon on screen with proper rotation

#;
(define (render-balloon b)
  (place-image (circle 10 "solid" "red") 100 100 MTS)) ; stub

(check-expect (render-balloon (make-balloon 10 20 3 3 0))
              (place-image BALLOON 10 20 MTS))

(define (render-balloon b)
  (place-image (rotate (balloon-r b) BALLOON) (balloon-x b) (balloon-y b) MTS)) ; stub


;; Balloon KeyEvent -> Balloon
;; reset position and speed of balloon to initial state
; (define (handle-key b ke) b) ; stub

(check-expect (handle-key (make-balloon 100 100 3 3 0) " ") (make-balloon 0 0 DX DY 0))
(check-expect (handle-key (make-balloon 100 100 3 3 0) "a") (make-balloon 100 100 3 3 0))

(define (handle-key b ke)
  (cond [(key=? ke " ") (make-balloon START-X START-Y DX DY 0)]
        [else (make-balloon (balloon-x b) (balloon-y b) (balloon-dx b) (balloon-dy b) (balloon-r b))]))
