(require 2htdp/image)
(require 2htdp/universe)

;; ===========================
;; Constants
;; ===========================

(define WIDTH 600)
(define HEIGHT 400)
(define CTR-Y (/ HEIGHT 2))
(define MTS (empty-scene WIDTH HEIGHT))
(define IMG (rectangle 20 10 "solid" "teal"))


;; ===========================
;; Data definition
;; ===========================

;; WS is Number
;; Position of the slider in x coordinates

(define P1 0)              ; left edge of the screen
(define P2 (/ WIDTH 2))    ; middle of the screen
(define P3 WIDTH)          ; right edge of the screen

#;
(define (fn-for-ws ws)
  (... ws))

;; Template rules:
;; - Atomic Non-Distinct      Number

;; ===========================
;; Functions
;; ===========================

;; WS -> WS
;; Launch with (main 0)
(define (main ws)
  (big-bang ws                  ; WS
            (on-tick   ...)     ; WS -> WS
            (to-draw   ...)     ; WS -> Image
            (stop-when ...)     ; WS -> Boolean
            (on-mouse  ...)     ; WS Integer Integer MouseEvent -> WS
            (on-key    ...)     ; WS KeyEvent -> WS
            ))


;; WS -> WS
;; Updates state...
;; !!!
(define (tock ws)
  (... ws))


;; WS -> Image
;; Renders the scene...
;; !!!
(define (render ws)
  (... MTS))


;; WS KeyEvent -> WS
;; Updates WS depending on a Key Event
;; !!!
(define (handle-key ws key)
  (... ws))

;; WS Integer Integer MouseEvent -> WS
;; Updates WS on Mouse Event
;; !!!
(define (handle-mouse ws x y me)
  (... ws))
