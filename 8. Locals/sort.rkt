;; =============================
;; Data definition
;; =============================

;; ListOfNumbers is one of:
;; - empty
;; - (cons Number ListOfNumbers)
;; Interp. A list of numbers

(define LN0 empty)
(define LN1 (list 1 2 3))
(define LN2 (list 3 4 5))
(define LN3 (list 2 5 7))

#;
(define (fn-for-ln ln)
  (cond [(empty? ln) (...)]
        [else
         (... (first ln)
              (fn-for-ln (rest ln)))]))


;; =============================
;; Functions
;; =============================

;; ListOfNumbers String -> ListOfNumbers
;; Returns a list with its elements sorted in increasing or decreasing order
;; - "I" stands for increasing order, from the smallest to the greatest
;; - "D" stands for decreasing order, from the greates to the smallest
; (define (sort-list lon mode) empty) ; stub

(check-expect (sort-list empty "I") empty)
(check-expect (sort-list empty "D") empty)
(check-expect (sort-list (list 1) "I") (list 1))
(check-expect (sort-list (list 1) "D") (list 1))
(check-expect (sort-list (list 1 2 3) "I") (list 1 2 3))
(check-expect (sort-list (list 1 2 3) "D") (list 3 2 1))
(check-expect (sort-list (list 3 2 1) "I") (list 1 2 3))
(check-expect (sort-list (list 3 2 1) "D") (list 3 2 1))
(check-expect (sort-list (list 1 3 2) "I") (list 1 2 3))
(check-expect (sort-list (list 1 3 2) "D") (list 3 2 1))

(define (sort-list lon mode)
  (local [
          (define (sort-lon lon)
            (cond [(empty? lon) empty]
                  [else
                   (insert (first lon)
                           (sort-lon (rest lon)))]))

          (define (insert n lon)
            (cond [(empty? lon) (cons n empty)]
                  [(string=? "I" mode)
                   (if (> (first lon) n)
                       (cons n lon)
                       (cons (first lon) (insert n (rest lon))))]
                  [(string=? "D" mode)
                   (if (< (first lon) n)
                       (cons n lon)
                       (cons (first lon) (insert n (rest lon))))]))
          ]
    (sort-lon lon)))


;; =============================
;; Try out
;; =============================

(sort-list (list 47 -3 1 -10 3 -76 23 7 -2) "I")
(sort-list (list 47 -3 1 -10 3 -76 23 7 -2) "D")
