;; ==========================
;; Data definitions
;; ==========================

;; SeatNum is Natural[1, 32]
;; Interpretion: the number of a seat in a theatre, where 1 and 32 are aisle seats

(define SN1 1)    ; aisle
(define SN2 2)
(define SN17 17)
(define SN31 31)
(define SN32 32)  ; aisle

#;
(define (fn-for-seat-num sn)
  (... sn))

;; Template rules:
;; - Atomic Non-Distinct, Natural[1, 32]


;; =========================
;; Functions
;; =========================

;; SeatNum -> Boolean
;; Returns true if the given seat number is on the aisles
; (define (aisle? sn) false) ; stub

(check-expect (aisle? SN1) true);
(check-expect (aisle? SN2) false);
(check-expect (aisle? SN3) true);

;; Template from SeatNum

(define (aisle? sn)
  (or (= 1 sn) (= 32 sn))) 
