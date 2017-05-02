(require 2htdp/image)
(require 2htdp/universe)

;; ===========================
;; Constants
;; ===========================

(define WIDTH 300)
(define HEIGHT 200)
(define CTR-X (/ WIDTH 2))
(define CTR-Y (/ HEIGHT 2))
(define MTS (empty-scene WIDTH HEIGHT))
(define SIZE 24)
(define COLOR "teal")
(define TIMING 1)


;; ===========================
;; Data Definition
;; ===========================

;; CountDown is one of:
;; - false              CountDown is reset
;; - Natural[0, 10]     CountDown is running
;; - true               CountDown is over
;; Interpretation: the phases of a countdown, from stopped, to 10, to 0, to done

(define CD0 false)   ; CountDown is yet to start
(define CD3 3)       ; CountDown is running, -3 sec to complete
(define CD true)     ; CountDown is done!

#;
(define (fn-for-cd cd)
  (cond [(false? cd) (...)]
        [(and (number? cd) (> 10 cd)) (... cd)]
        [else (...)]))

;; Template rules, one of three:
;; - Atomic Distinc        false
;; - Atomic Non-Distinc    Natural[0,10]
;; - Atomic Distinc        true


;; ===========================
;; Functions
;; ===========================

;; CD -> CD
;; Launch with (main 10)
(define (main cd)
  (big-bang cd                       ; CD
            (on-tick   tock TIMING)  ; CD -> cd
            (to-draw   render)       ; CD -> Image
            (on-key    handle-key)   ; CD KeyEvent -> CD
            ))


;; CD -> CD
;; Updates state...
; (define (tock cd) cd) ; stub

(check-expect (tock false) false)
(check-expect (tock 10) 9)
(check-expect (tock 3) 2)
(check-expect (tock true) true)

(define (tock cd)
  (cond [(false? cd) cd]
        [(and (number? cd) (> cd 0)) (- cd 1)]
        [else true]))


;; CD -> Image
;; Renders the scene...
;; !!!
(define (render cd)
  (place-image (display cd) CTR-X CTR-Y MTS))

(check-expect (render false) (place-image (text "10" SIZE COLOR) CTR-X CTR-Y MTS))
(check-expect (render 7) (place-image (text "7" SIZE COLOR) CTR-X CTR-Y MTS))
(check-expect (render 0) (place-image (text "0" SIZE COLOR) CTR-X CTR-Y MTS))
(check-expect (render true) (place-image (text "Done!" SIZE COLOR) CTR-X CTR-Y MTS))


;; CD -> Image
;; Renders the countdown depending on its status
;; !!!
; (define (display cd) empty-image) ; stub

(check-expect (display false) (text "10" SIZE COLOR))
(check-expect (display 3) (text "3" SIZE COLOR))
(check-expect (display 0) (text "0" SIZE COLOR))
(check-expect (display true) (text "Done!" SIZE COLOR))

(define (display cd)
  (cond [(false? cd) (text "10" SIZE COLOR)]
        [(number? cd) (text (number->string cd) SIZE COLOR)]
        [else (text "Done!" SIZE COLOR)]))



;; CD KeyEvent -> CD
;; Updates CD depending on a Key Event
; (define (handle-key cd key) cd) ; stub

(check-expect (handle-key false " ") 10)
(check-expect (handle-key false "q") false)
(check-expect (handle-key 3 " ") 10)

(define (handle-key cd key)
  (cond [(string=? " " key) 10]
        [else cd]))
