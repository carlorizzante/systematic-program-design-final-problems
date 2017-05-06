(require 2htdp/image)
(require 2htdp/universe)

;
; Rain falls down on a landscape moved by the wind.
;
; Keys:
; Spacebar > Adds drops of rain to the animation
;
; Mouse:
; Position (x-coordinate on the canvas) > determines the force of the wind


;; =========================
;; Constants
;; =========================

(define WIDTH 600)                          ; Canvas width
(define HEIGHT 400)                         ; Canvas height
(define SPEED 10)                           ; Vertical speed for rain drops
(define WIND 0)                             ; Wind component, added or subtracted depending by mouse x-coordinate on the canvas
(define DROP (circle 1 "solid" "blue"))     ; A drop of rain
(define REF (circle 0 "solid" "white"))     ; empty image, used as reference for offsets
(define MTS (rectangle WIDTH HEIGHT "solid" "lightblue")) ; Canvas


;; =========================
;; Data definition
;; =========================

(define-struct drop (x y))
;; Drop is (make-drop Integer Integer)
;; Interpr. A raindrop on the screen with its x, y coordinate

(define D1 (make-drop 10 30))
(define D2 (make-drop 20 50))

#;
(define (fn-for-drop d)
  (... (drop-x d)
       (drop-y d)))

;; Template rules used:
;; - compound data with 2 fields


;; ListOfDrops is one of:
;; - empty
;; - (cons Drop ListOfDrops)
;; Interpr. a list of drops

(define LOD0 empty)
(define LOD1 (cons D1 empty))
(define LOD2 (cons D2 (cons D1 empty)))

(define (fn-for-lod lod)
  (cond [(empty? lod) (...)]
        [else
         (... (fn-for-drop (first lod))
              (fn-for-lod (rest ldb)))]))

;; Template rules used:
;; - one of:
;; -- atomic distinct: empty
;; -- compound data: (cons Drop ListOfDrops)
;; - reference: (first lod) is Drop
;; - self-reference: (rest lod) is ListOfDrops


;; =========================
;; Functions
;; =========================

;; ListOfDrops -> ListOfDrops
;; Main functions, creates the animation within the canvas
(define (main lod)
  (big-bang lod
            (on-key   handle-keys)     ; ListOfDrops KeyEvent -> ListOfDrops
            ;            (on-mouse handle-mouse)    ; ListOfDrops MouseEvent -> ListOfDrops
            (on-tick  next-drops)      ; ListOfDrops -> ListOfDrops
            (on-draw  render-drops)))  ; ListOfDrops -> Image

;; Start with (run 1)
(define (run n) (main empty))


;; ListOfDrops KeyEvent -> ListOfDrops
;; Adds new random drops at the pressure of the spacebar on the keyboard
; (define (handle-keys los ke) los) ; stub

; No tests so far for random generation


(define (handle-keys los ke)
  (cond [(key=? ke " ")
         (cons (make-drop (random WIDTH) 0) los)]
        [else los]))


;; ListOfDrops MouseEvent -> ListOfDrops
;; Adds wind components depending by the x-coordinate of the mouse on the canvas
(define (handle-mouse los me) los) ; stub




;; ListOfDrops -> ListOfDrops
;; Recalculates drops position for the current tick
; (define (next-drops lod) lod) ; stub

(check-expect (next-drops empty) empty)
(check-expect (next-drops LOD1) (cons (make-drop (drop-x D1) (+ (drop-y D1) SPEED)) empty))
(check-expect (next-drops LOD2) (cons
                                 (make-drop (drop-x D2) (+ (drop-y D2) SPEED))
                                 (cons (make-drop (drop-x D1) (+ (drop-y D1) SPEED)) empty)))

(define (next-drops lod)
  (cond [(empty? lod) empty]
        [else
         (if (> (drop-y (first lod)) HEIGHT)
             (next-drops (rest lod))
             (cons (move-drop (first lod))
                   (next-drops (rest lod))))]))


;; Drop -> Drop
;; Moves a single drop on the screen and removes it when it goes over the bottom of the screen
; (define (move-drop d) d) ; stub

(check-expect (move-drop D1) (make-drop (drop-x D1) (+ (drop-y D1) SPEED)))

(define (move-drop d)
  (make-drop (drop-x d) (+ (drop-y d) SPEED)))


;; Drop -> Image
;; Renders a drop at its correct x, y coordinates
; (define (render-drop d) DROP) ; stub

(check-expect (render-drop D1) (overlay/offset
                                REF
                                (drop-x D1) (drop-y D1)
                                DROP))
(check-expect (render-drop D2) (overlay/offset
                                REF
                                (drop-x D2) (drop-y D2)
                                DROP))

(define (render-drop d)
  (overlay/offset
   REF
   (drop-x d)
   (drop-y d)
   DROP))


;; ListOfDrops -> Image
;; Renders drops on the canvas
; (define (render-drops lod) MTS) ; stub

(check-expect (render-drops empty) MTS)
(check-expect (render-drops LOD1) (overlay/align "left" "top"
                                                 (render-drop D1)
                                                 MTS))
(check-expect (render-drops LOD2) (overlay/align "left" "top"
                                                 (render-drop D2)
                                                 (render-drop D1)
                                                 MTS))

(define (render-drops lod)
  (cond [(empty? lod) MTS]
        [else
         (overlay/align "left" "top"
                        (render-drop (first lod))
                        (render-drops (rest lod)))]))
