;; ===============================
;; Data Definitions
;; ===============================

(define-struct person (name age children))
;; Person is (make-person String Natural ListOfPerson)
;; A person with name, age, and list of their children

;; ListOfPerson is one of:
;; - empty
;; - (cons Person ListOfPerson)
;; A list of persons

(define P1 (make-person "P1" 5 empty))
(define P2 (make-person "P2" 25 (list P1)))
(define P3 (make-person "P3" 15 empty))
(define P4 (make-person "P4" 45 (list P2 P3)))

#;
(define (fn-for-p p)
  (local [(define (fn-for-person p)
            (... (person-name p)                     ; String
                 (person-age p)                      ; Natural
                 (fn-for-lop (person-children p))))  ; ListOfPerson

          (define (fn-for-lop lop)
            (cond [(empty? lop) (...)]
                  [else (... (fn-for-person (first lop))  ; Person
                             (fn-for-lop (rest lop)))]))  ; ListOfPerson
          ]
    (fn-for-person p)))


;; ===============================
;; Functions
;; ===============================

;; Person -> ListOfString
;; Returns a list with the names of all persons within the provided age range

; (check-expect (younger-than--lop empty 20) empty)
(check-expect (younger-than P1 20) (list "P1"))
(check-expect (younger-than P2 20) (list "P1"))
(check-expect (younger-than P4 20) (list "P1" "P3"))

(define (younger-than p age)
  (local [(define (younger-than--elt p age)
            (if (< (person-age p) age)
                (cons (person-name p)
                      (younger-than--lop (person-children p) age))
                (younger-than--lop (person-children p) age)))

          (define (younger-than--lop lop age)
            (cond [(empty? lop) empty]
                  [else (append (younger-than--elt (first lop) age)
                                (younger-than--lop (rest lop) age))]))
          ]
    (younger-than--elt p age)))
