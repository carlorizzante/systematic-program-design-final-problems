(require 2htdp/image)

;; ==========================
;; Data definitions
;; ==========================

;; CountDown is one of:
;; - false             Not started yet
;; - Natural [1, 10]   Counting, from 10 to 1
;; - true              Done!
;; Interpretation: the phases of a countdown

(define CD0  false) ; not started yet
(define CD3  3)     ; running
(define CD10 10)    ; running, close to the end
(define CD11 true)  ; done!

#;
(define (fn-for-count-down cd)
  (cond [(false? cd) (...)]
        [(and (number? cd) (> 10 cd)) (... cd)]  ; in most scenarios may be unneccesary to test for (> 10 cd)
        [else (...)]))


;; Template rules:
;; - one of 3 cases
;; -- Atomic Distinct    false
;; -- Atomic Distinct    true


;; ==========================
;; Functions
;; ==========================

;; CountDown -> Image
;; Returns an image based on the current status of the countdown
; (define (display cd) empty-image) ; stub

(check-expect (display CD0) empty-image)
(check-expect (display CD3) (text "3" 14 "teal"))
(check-expect (display CD11) (text "Done!" 14 "red"))

; template from CountDown

(define (display cd)
  (cond [(false? cd) empty-image]
        [(and (number? cd) (> 10 cd)) (text (number->string cd) 14 "teal")]  ; in most scenarios may be unneccesary to test for (> 10 cd)
        [else (text "Done!" 14 "red")]))
