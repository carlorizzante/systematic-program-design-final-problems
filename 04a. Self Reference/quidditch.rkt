;; ============================
;; Data Definition
;; ============================

;; Information          Data
;; -----------------------------------
;; McGill               "McGill"
;; UBC                  "UBC"
;; Todd's               "Todd's"

;; ListOfString is one of:
;; - empty
;; (cons String ListOfString)

(define L0 empty)
(define L1 (cons "McGill" empty))
(define L2 (cons "UBC" (cons "McGill" empty)))
(define L3 (cons "Todd's" (cons "UBC" (cons "McGill" empty))))

#;
(define (fn-for-los los)
  (cond [(empty? los) (...)]
        [else (... (first los)                  ; String
                   (fn-for-los (rest los)))]))  ; ListOfString

;; Template rules used
;; - One of:
;; -- Atomic Distinct      empty
;; -- Compound Data        (cons String ListOfString)
;; -- Self-Reference       (rest los) is ListOfString


;; ============================
;; Functions
;; ============================

;; ListOfString -> Boolean
;; Returns true if the given list contains "UBC", false otherwise
; (define (contains-ubc? los) false) ; stub

(check-expect (contains-ubc? empty) false)
(check-expect (contains-ubc? L1) false)
(check-expect (contains-ubc? L2) true)
(check-expect (contains-ubc? L3) true)

;; Template from ListOfString

(define (contains-ubc? los)
  (cond [(empty? los) false]
        [else (if (string=? "UBC" (first los))
                  true
                  (contains-ubc? (rest los)))]))
