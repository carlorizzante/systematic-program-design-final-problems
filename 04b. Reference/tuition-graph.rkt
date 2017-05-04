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

(define-struct school (name tuition))
;; School is (make-school String Natural)
;; A school completed with name and tuition cost in USD

(define S1 (make-school "School1" 25000))
(define S2 (make-school "School2" 32000))
(define S3 (make-school "School3" 28000))

;# See ListOfSchool for the template for School

;; Template rules used:
;; - Compound Data        School (make-school String Natural)


;; ListOfSchool is one of:
;; - empty
;; (cons School ListOfSchool)

(define L0 empty)
(define L1 (cons S1 empty))
(define L2 (cons S2 L1))
(define L3 (cons S3 L2))

#;
(define (fn-for-school s)
  (... (school-name s)        ; String
       (school-tuition s)))   ; Natural

#;
(define (fn-for-los los)
  (cond [(empty? los) (...)]
        [else (... (fn-for-school (first los))    ; School
                   (fn-for-los (rest los)))]))    ; ListOfSchool

;; Template rules used:
;; -- Atomic Distinct            empty
;; -- Compound Data              (cons School ListOfSchool)
;; -- Reference                  (first los) is School
;; -- Self-Reference             (rest los) is ListOfSchool


;; ==========================
;; Functions
;; ==========================

;; ListOfSchool -> Image
;; Returns a bar-graph of the schools in the list
; (define (graph los) empty-image) ; stub

(check-expect (graph L0) empty-image)
(check-expect (graph L1) (bar S1))
(check-expect (graph L2) (beside/align "bottom"
                                       (bar S1)
                                       (bar S2)))
(check-expect (graph L3) (beside/align "bottom"
                                       (bar S1)
                                       (bar S2)
                                       (bar S3)))

(define (graph los)
  (cond [(empty? los) empty-image]
        [else (beside/align "bottom"
                            (graph (rest los))
                            (bar (first los))
                            )]))


;; School -> image
;; Returns a bar of the school with height proportional of Tuition, and name
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

(graph L3)
