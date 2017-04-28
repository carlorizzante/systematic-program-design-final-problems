;; ======================
;; Data definition
;; ======================

;; TLColor is one of:
;;  - "red"
;;  - "yellow"
;;  - "green"
;; interp. "red" means red, "yellow" yellow, and "green" green

#;
(define (fn-for-tlcolor c)
  (cond [(= c "red") (...)]
        [(= c "yellow") (...)]
        [(= c "green") (...)]))


;; ======================
;; Functions
;; ======================

;; TLColor -> TLColor
;; Returns the next color of a traffic light
; (define (next-color c) "red") ; stub

(check-expect (next-color "red") "green")
(check-expect (next-color "yellow") "red")
(check-expect (next-color "green") "yellow")

; Template from TLColor

(define (next-color c)
  (cond [(string=? c "red")    "green"]
        [(string=? c "yellow") "red"]
        [(string=? c "green")  "yellow"]))
