
(require 2htdp/image)

;; ==========================
;; Constants
;; ==========================

(define COLOR "black")          ; Text color
(define TEXT 10)                ; Text size
(define PADDING 6)              ; Padding for text

(define BCOLOR "lightblue")     ; Bar background color
(define BORDER "white")         ; Bar border color
(define WIDTH 20)               ; Bar width
(define SCALE 0.005)            ; Scaling factor


;; ==========================
;; Data Definition
;; ==========================

(define-struct school (name tuition next))
;; School is one of:
;; - false
;; - (make-school String Natural School)
;; An arbitrary number of schools, where for each school we have its name and its tuition in USD

;; Problem A
;; The Data definition has a base case and a self-reference case, so we can conclude that's well formed.

;; School is (make-school String Natural School)

(define S0 false)
(define S1 (make-school "S1" 25000 S0))
(define S2 (make-school "S2" 32000 S1))
(define S3 (make-school "S3" 28000 S2))

#;
(define (fn-for-school s)
  (cond [(false? s) (...)]
        [else (... (school-name s)                        ; String
                   (school-tuition s)                     ; Natural
                   (fn-for-school (school-next s)))]))    ; School

;; Template rules:
;; - Atomic Distinct            false
;; - Compound Data              (make-school String Natural School)
;; -- Atomic Non-Distinct       (school-name) String
;; -- Atomic Non-Distinct       (school-tuition) Natural
;; -- Self-Reference            (school-next) School


;; ==========================
;; Functions
;; ==========================

;; School -> Image
;; Renders the graph the consumed School(s)
; (define (graph s) empty-image) ; stub

(check-expect (graph S0) empty-image)
(check-expect (graph S1) (bar S1))
(check-expect (graph S2) (beside/align "bottom"
                                       (bar S1)
                                       (bar S2)))
(check-expect (graph S3) (beside/align "bottom"
                                       (bar S1)
                                       (bar S2)
                                       (bar S3)))

(define (graph s)
  (cond [(false? s) empty-image]
        [else (beside/align "bottom"
                            (graph (school-next s))
                            (bar s))]))


;; School -> Image
;; Renders a single bar of a given school
; (define (bar s) empty-image) ; stub

(check-expect (bar S1) (overlay/align "center" "bottom"
                                      (rotate 90 (beside
                                                  (square PADDING "solid" BCOLOR)
                                                  (text (school-name S1) TEXT COLOR)))
                                      (rectangle WIDTH (* (school-tuition S1) SCALE) "outline" BORDER)
                                      (rectangle WIDTH (* (school-tuition S1) SCALE) "solid" BCOLOR)))
(check-expect (bar S2) (overlay/align "center" "bottom"
                                      (rotate 90 (beside
                                                  (square PADDING "solid" BCOLOR)
                                                  (text (school-name S2) TEXT COLOR)))
                                      (rectangle WIDTH (* (school-tuition S2) SCALE) "outline" BORDER)
                                      (rectangle WIDTH (* (school-tuition S2) SCALE) "solid" BCOLOR)))

(define (bar s)
  (overlay/align "center" "bottom"
                 (rotate 90 (beside
                             (square PADDING "solid" BCOLOR)
                             (text (school-name s) TEXT COLOR)))
                 (rectangle WIDTH (* (school-tuition s) SCALE) "outline" BORDER)
                 (rectangle WIDTH (* (school-tuition s) SCALE) "solid" BCOLOR)))


;; ==========================
;; Try out
;; ==========================

(graph S3)
