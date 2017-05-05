(require 2htdp/image)

;; decreasing-image-starter.rkt

;  PROBLEM:
;
;  Design a function called decreasing-image that consumes a Natural n and produces an image of all the numbers
;  from n to 0 side by side.
;
;  So (decreasing-image 3) should produce .



;; ===============================
;; Constants
;; ===============================

(define BOX-WIDTH 30)                  ; container width
(define BOX-HEIGHT 30)                 ; container height
(define BOX-STYLE "solid")             ; container style
(define BOX-COLOR "black")             ; container background color
(define FONT-SIZE 18)                  ; font size
(define FONT-COLOR "white")            ; font color


;; ===============================
;; Functions
;; ===============================

;; Natural -> Image
;; Return a number within a box as an image
; (define (n->box n) (rectangle 0 0 "solid" "white")) ; stub

(check-expect (n->box 0) (overlay
                            (text "0" FONT-SIZE FONT-COLOR)
                            (rectangle BOX-WIDTH BOX-HEIGHT BOX-STYLE BOX-COLOR)))
(check-expect (n->box 1) (overlay
                            (text "1" FONT-SIZE FONT-COLOR)
                            (rectangle BOX-WIDTH BOX-HEIGHT BOX-STYLE BOX-COLOR)))
(check-expect (n->box 7) (overlay
                            (text "7" FONT-SIZE FONT-COLOR)
                            (rectangle BOX-WIDTH BOX-HEIGHT BOX-STYLE BOX-COLOR)))

(define (n->box n) (overlay
                      (text (number->string n) FONT-SIZE FONT-COLOR)
                      (rectangle BOX-WIDTH BOX-HEIGHT BOX-STYLE BOX-COLOR)))


;; Natural -> Image
;; Given a natural n, returns an image with all naturals from n to 0 as images, side by side
; (define (decreasing-image n) (rectangle 0 0 "solid" "white")) ; stub

(check-expect (decreasing-image 0) (overlay
                                    (text "0" FONT-SIZE FONT-COLOR)
                                    (rectangle BOX-WIDTH BOX-HEIGHT BOX-STYLE BOX-COLOR)))
(check-expect (decreasing-image 3) (beside
                                    (overlay
                                     (text "3" FONT-SIZE FONT-COLOR)
                                     (rectangle BOX-WIDTH BOX-HEIGHT BOX-STYLE BOX-COLOR))
                                    (overlay
                                     (text "2" FONT-SIZE FONT-COLOR)
                                     (rectangle BOX-WIDTH BOX-HEIGHT BOX-STYLE BOX-COLOR))
                                    (overlay
                                     (text "1" FONT-SIZE FONT-COLOR)
                                     (rectangle BOX-WIDTH BOX-HEIGHT BOX-STYLE BOX-COLOR))
                                    (overlay
                                     (text "0" FONT-SIZE FONT-COLOR)
                                     (rectangle BOX-WIDTH BOX-HEIGHT BOX-STYLE BOX-COLOR))))

(define (decreasing-image n)
  (cond
    [(zero? n) (n->box n)]
    [else (beside
           (n->box n)
           (decreasing-image (- n 1)))]))


;; ===============================
;; Try out
;; ===============================

(decreasing-image 7)
(decreasing-image 18)
