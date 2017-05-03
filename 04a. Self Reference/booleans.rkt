;; ============================
;; Data Definition
;; ============================

;; ListOfBoolean is one of:
;; - empty
;; (cons Boolean ListOfBoolean)

(define L0 empty)
(define L1 (cons true empty))
(define L2 (cons false (cons true empty)))
(define L3 (cons true (cons false (cons true empty))))

#;
(define (fn-for-lob lob)
  (cond [(empty? lob) (...)]
        [else (... (first lob)
                   (fn-for-lon (rest lob)))]))

;; Template rules used:
;; - One of:
;; -- Atomic Distinct    false
;; -- Compound Data      (cons Boolean ListOfBoolean)
;; -- Self Reference     (rest lob) is ListOfBoolean


;; ============================
;; Functions
;; ============================

;; ListOfBoolean -> Boolean
;; Returns true if all elements in the list are truthy, false otherwise
; (define (all-true? lob) false) ; stub

(check-expect (all-true? L0) true)
(check-expect (all-true? L1) true)
(check-expect (all-true? L2) false)
(check-expect (all-true? L3) false)

(define (all-true? lob)
  (cond [(empty? lob) true]
        [else (and (first lob)
                   (all-true? (rest lob)))]))
