(require 2htdp/image)
(require 2htdp/universe)

;
; Playing with Lists, Compound Data, and Reference/Self-reference.
;
; Once the program is launched, pressing the spacebar causes a series of bubbles
; of various random sizes and colors to pop on screen, and quickly fade away.
;
; Keys:
; - " " > pops up a new random bubble


;; ============================
;; Constants
;; ============================

(define WIDTH 900)                                   ; screen width
(define HEIGHT 600)                                  ; screen height
(define MTS (empty-scene WIDTH HEIGHT))              ; empty scene
(define BG (rectangle WIDTH HEIGHT "solid" "white")) ; background
(define REF (rectangle 0 0 "outline" "white"))       ; block used to position each Bubble via offset
(define CX 0.9)                                      ; coefficient for resizing bubbles over time
(define PAD 100)                                     ; padding for positioning bubbles more towards the center of the screen
(define BASE 20)                                     ; min size for new bubbles
(define BX 10)                                       ; coefficient for max size for new bubbles (* BASE BX)


;; ============================
;; Data Definition
;; ============================

(define-struct bubble (x y size style color))
;; Bubble is (make-bubble Natural Natural Natural String String)
;; - x is x coordinate of a Bubble
;; - y is y coordinate of the Bubble
;; - size is the current size of the Bubble
;; - style is the style of the Bubble ("outline" or "solid")
;; - color is the color of the Bubble

(define B1 (make-bubble 100 150 20 "outline" "red"))
(define B2 (make-bubble 250 350 14 "outline" "green"))
(define B3 (make-bubble 370 120 24 "outline" "lightblue"))
(define B4 (make-bubble 400 400 40 "solid" "black"))

#;
(define (fn-for-bubble bbl)
  (... (bubble-x bbl)
       (bubble-y bbl)
       (bubble-size bbl)
       (bubble-style bbl)
       (bubble-color bbl)))


;; ListOfBubble is one of:
;; - empty
;; - (cons Bubble ListOfBubble)
;; Interpr. A list of Bubbles of different positions, sizes, and colors

(define LOB0 empty)
(define LOB1 (cons B1 empty))
(define LOB2 (cons B2 (cons B1 empty)))
(define LOB3 (cons B3 (cons B2 (cons B1 empty))))
(define LOBx (cons (make-bubble 100 150 1 "outline" "red") empty))

#;
(define (fn-for-lob lob)
  (cond [(empty? lob) (...)]
        [else
         (... (fn-for-bubble (first lob))
              (fn-for-lob (rest lob)))]))

;; Template rules used:
;; - one of 2 cases:
;; -- atomic distinct: empty
;; -- compound data: (cons Circle ListOfCircle)
;; - reference: (first loc)
;; - self-reference: (rest loc) is ListOfCircle


;; ============================
;; Functions
;; ============================

;; ListOfBubble -> ListOfBubble
;; Animate the scene, random Bubbles pop up as spacebar is pressed
;; no test for main function
(define (main lob)
  (big-bang lob
            (on-tick next-lob)           ; ListOfBubble -> ListOfBubble
            (on-draw render-scene)       ; ListOfBubble -> Image
            (on-key handle-keys)))       ; ListOfBubble KeyEvent -> ListOfBubble

;; start the universe with (run 1)
(define (run i)
  (main empty))


;; ListOfBubble -> ListOfBubble
;; Manipulate the Bubbles so that they animate
; (define (next-lob lob) lob) ; stub

(check-expect (next-lob empty) empty)
(check-expect (next-lob LOB1) (cons (make-bubble 100 150 (* (bubble-size B1) CX) "outline" "red") empty))
(check-expect (next-lob LOB2) (cons (make-bubble 250 350 (* (bubble-size B2) CX) "outline" "green")
                                   (cons (make-bubble 100 150 (* (bubble-size B1) CX) "outline" "red") empty)))
(check-expect (next-lob LOB3) (cons (make-bubble 370 120 (* (bubble-size B3) CX) "outline" "lightblue")
                                   (cons (make-bubble 250 350 (* (bubble-size B2) CX) "outline" "green")
                                         (cons (make-bubble 100 150 (* (bubble-size B1) CX) "outline" "red") empty))))
(check-expect (next-lob LOBx) empty)

(define (next-lob lob)
  (cond [(empty? lob) empty]
        [else
         (if (> (bubble-size (first lob)) 1)
             (cons (make-bubble
                    (bubble-x (first lob))
                    (bubble-y (first lob))
                    (* (bubble-size (first lob)) CX)
                    (bubble-style (first lob))
                    (bubble-color (first lob)))
                   (next-lob (rest lob)))
             (next-lob (rest lob)))]))


;; ListOfBubble -> Image
;; Render the scene
; (define (render-scene lob) MTS) ; stub

(check-expect (render-scene empty) (place-image
                                    (place-bubbles LOB0) 0 0
                                    (overlay REF MTS)))
(check-expect (render-scene LOB1) (place-image
                                   (place-bubbles LOB1) 0 0
                                   (overlay REF MTS)))
(check-expect (render-scene LOB2) (place-image
                                   (place-bubbles LOB2) 0 0
                                   (overlay REF MTS)))
(check-expect (render-scene LOB3) (place-image
                                   (place-bubbles LOB3) 0 0
                                   (overlay REF MTS)))

(define (render-scene lob)
  (place-image
   (place-bubbles lob) 0 0
   (overlay REF MTS)))


;; ListOfBubble KeyEvent -> ListOfBubble
;; Add a new random Bubble at the pressure of the spacebar
;(define (handle-keys lob ke) lob) ; stub

(define (handle-keys lob ke)
  (cond [(key=? ke " ") (cons (make-bubble
                               (+ (random (- WIDTH PAD)) (/ PAD 2))
                               (+ (random (- HEIGHT PAD)) (/ PAD 2))
                               (* (random BASE) BX) ; BASE is min size, (* BASE BX) is max size
                               "outline"
                               ;"lightblue")
                               (make-color (random 255) (random 255) (random 255)))
                              lob)]
        [else lob]))


;; Bubble -> Image
;; Converts a Bubble into its corresponding image
; (define (pop-bubble bbl) (circle 10 "outline" "teal")) ; stub

(check-expect (pop-bubble B1) (overlay/xy
                           REF
                           (* 2 (bubble-x B1)) (* 2 (bubble-y B1))
                           (circle 20 "outline" "red")))
(check-expect (pop-bubble B2) (overlay/xy
                           REF
                           (* 2 (bubble-x B2)) (* 2 (bubble-y B2))
                           (circle 14 "outline" "green")))
(check-expect (pop-bubble B3) (overlay/xy
                           REF
                           (* 2 (bubble-x B3)) (* 2 (bubble-y B3))
                           (circle 24 "outline" "lightblue")))
(check-expect (pop-bubble B4) (overlay/xy
                           REF
                           (* 2 (bubble-x B4)) (* 2 (bubble-y B4))
                           (circle 40 "solid" "black")))

;<template from Bubble>
(define (pop-bubble bbl) (overlay/xy
                           REF
                           (* 2 (bubble-x bbl)) (* 2 (bubble-y bbl))
                           (circle (bubble-size bbl) (bubble-style bbl) (bubble-color bbl))))


;; ListOfBubble -> Image
;; Overlay all Bubbles in a ListOfBubble in one single scene
; (define (place-bubble lob) MTS) ; stub

(check-expect (place-bubbles LOB0) REF)
(check-expect (place-bubbles LOB1) (overlay
                               (pop-bubble B1)
                               REF))
(check-expect (place-bubbles LOB2) (overlay
                               (pop-bubble B2)
                               (pop-bubble B1)
                               REF))
(check-expect (place-bubbles LOB3) (overlay
                               (pop-bubble B3)
                               (pop-bubble B2)
                               (pop-bubble B1)
                               REF))

;<template from ListOfBubble

(define (place-bubbles lob)
  (cond [(empty? lob) REF]
        [else
         (overlay (pop-bubble (first lob))
                  (place-bubbles (rest lob)))]))
