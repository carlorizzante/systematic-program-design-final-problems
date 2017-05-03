(require 2htdp/image)

;; ============================
;; Data Definition
;; ============================

;; ListOfImages is one of:
;; - empty
;; (cons Image ListOfImages)

(define L0 empty)
(define L1 (cons (square 10 "solid" "red") empty))
(define L2 (cons (rectangle 20 30 "solid" "red") L1))
(define L3 (cons (rectangle 26 32 "solid" "red") L2))

#;
(define (fn-for-loi loi)
  (cond [(empty? loi) (...)]
        [else (... (first loi)
                   (fn-for-loi (rest loi)))]))

;; Template rules used:
;; - One of:
;; -- Atomic Distinct        empty
;; -- Compound Data          ListOfImage
;; -- Self-Reference         (rest loi) is ListOfImages


;; ============================
;; Data Definition
;; ============================

;; ListOfImage -> Natural
;; Returns the cumulative area of all images in a ListOfImages
; (define (total-area loi) 0) ; stub

(check-expect (total-area L0) 0)
(check-expect (total-area L1) 100)
(check-expect (total-area L2) (+ 100 600))
(check-expect (total-area L3) (+ 100 600 832))

(define (total-area loi)
  (cond [(empty? loi) 0]
        [else (+ (* (image-width (first loi)) (image-height (first loi)))
                 (total-area (rest loi)))]))
