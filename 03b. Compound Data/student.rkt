;; ====================
;; Data definition
;; ====================

(define-struct student (name grade allergies))
;; Student is (make-student String Natural[1,12] Boolean)
;; Interpretation: (make-student name grade allergies) is a student
;; - name          is the name of the student
;; - grade         is the grade of the student
;; - allergies     is true if the student has allergies, false otherwise

(define S1 (make-student "Jon" 11 false))
(define S2 (make-student "Grace" 12 true))
(define S3 (make-student "Billy" 4 true))
(define S4 (make-student "Anne" 6 false))

#;
(define (fn-for-student s)
  (... (student-name s)           ; String
       (student-grade s)          ; Natural[0,12]
       (student-allergies s)      ; Boolean
       ))

;; Template rules used:
;; - Compound data with 3 fields:
;; -- String             Name of the student
;; -- Natural[0,12]      Grade of the student
;; -- Boolean            True if the student has allergies, false otherwise


;; ====================
;; Data definition
;; ====================

;; Student -> Boolean
;; Returns true if the student is in grade 6 or below, false otherwise
; (define (six-grade? s) false) ; stub

(check-expect (six-grade? S1) false)
(check-expect (six-grade? S3) true)
(check-expect (six-grade? S4) true)

(define (six-grade? s)
  (<= (student-grade s) 6))


;; Student -> Boolean
;; Returns true if the student has allergies, false otherwise
; (define (has-allergies? s) false) ; stub

(check-expect (has-allergies? S1) false)
(check-expect (has-allergies? S2) true)

(define (has-allergies? s)
  (student-allergies s))


;; Student -> Boolean
;; Returns true if the student has to be kept track on, false otherwise
; (define (add-to-list? s) false) ; stub

(check-expect (add-to-list? S1) false)
(check-expect (add-to-list? S3) true)
(check-expect (add-to-list? S4) false)

(define (add-to-list? s)
  (and (six-grade? s) (has-allergies? s)))
