;; ========================
;; Data definitions
;; ========================

(define-struct person (name age gender children))
;; Person is (make-person String Gender Natural ListOfPersons)
;; Interp. A person with a name, age, gender, and a list of their children

;; ListOfPersons is one of:
;; - empty
;; (cons Person ListOfPersons)
;; Interp. A list of Persons

;; Gender is one of:
;; - "M"
;; - "F"
;; Interp. The gender of a person, "M" for male, "F" for female

(define P1 (make-person "Jon" 21 "M" empty))
(define P2 (make-person "Jane" 19 "F" empty))
(define P3 (make-person "Donna" 46 "F" (list P1 P2)))
(define P4 (make-person "Bill" 75 "M" (list P3)))

#;
(define (fn-for-person p)
  (... (person-name p)                    ; String
       (person-age p)                     ; Natural
       (fn-for-gender (person-gender p))  ; Gender
       (fn-for-lop (person-children p))   ; ListOfPersons
       ))
#;
(define (fn-for-lop lop)
  (cond [(empty? lop) (...)]
        [else
         (... (fn-for-person (first lop))  ; Person
              (fn-for-lop (rest lop))      ; ListOfPersons
              )]))


;; ListOfStrings is one of:
;; - empty
;; - (cons String ListOfStrings)
;; Interp. A list of strings, like names

(define LOS0 empty)
(define LOS1 (cons "Jon" empty))
(define LOS2 (cons "Jane" LOS1))
(define LOS3 (cons "Donna" LOS2))

;; ========================
;; Functions
;; ========================

;; Person age -> ListOfStrings
;; ListOfPersons age -> ListOfStrings
;; Given age and a Person or ListOfPersons, returns a list of names of persons younger than "age"
; (define (select-by-age--person p age) empty) ; stub
; (define (select-by-age--lop lop age) empty) ; stub

(check-expect (select-by-age--lop empty 0) empty)
(check-expect (select-by-age--person P3 22) (list "Jon" "Jane"))
(check-expect (select-by-age--person P4 99) (list "Bill" "Donna" "Jon" "Jane"))

(define (select-by-age--person p age)
  (if (< (person-age p) age)
      (cons (person-name p)
            (select-by-age--lop (person-children p) age)
            )
      (select-by-age--lop (person-children p) age)
      ))

(define (select-by-age--lop lop age)
  (cond [(empty? lop) empty]
        [else
         (append (select-by-age--person (first lop) age)
                 (select-by-age--lop (rest lop) age)
                 )]))
