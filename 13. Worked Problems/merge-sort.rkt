;; (Listof Number) -> (Listof Number)
;; Returns a sorted list of numbers
; (define (merge-sort lon) empty) ; stub

(check-expect (merge-sort empty) empty)
(check-expect (merge-sort (list 1)) (list 1))
(check-expect (merge-sort (list 1 2 3)) (list 1 2 3))
(check-expect (merge-sort (list 6 5 3 1 8 7 2 4)) (list 1 2 3 4 5 6 7 8))
(check-expect (merge-sort (list 2 1 5 3 7 6 4 9 8)) (list 1 2 3 4 5 6 7 8 9))

#;; Template for Generative recursion
(define (merge-sort lon)
  (cond [(trivial? lon) (trivial lon)]
        [else (... lon
                   (merge-sort (next lon)))]))
#;
(define (merge-sort lon)
  (cond [(empty? lon) empty]      ; empty -> empty
        [(empty? (rest lon)) lon] ; 1 elm -> 1 elm
        [else (merge (merge-sort (... first-half lon))
                     (merge-sort (... second-half lon)))]))

(define (merge-sort lon)
  (cond [(empty? lon) empty]      ; empty -> empty
        [(empty? (rest lon)) lon] ; 1 elm -> 1 elm
        [else (merge (merge-sort (take lon  (quotient (length lon) 2))) ; first-half
                     (merge-sort (drop lon (quotient (length lon) 2)))  ; second-half
                     )]))


;; (Listof Number) (Listof Number) -> (Listof Number)
;; Merges two lists in ascending order
;; Assume the two lists are already sorted
; (define (merge l1 l2) empty) ; stub

(check-expect (merge empty empty) empty)
(check-expect (merge empty (list 1 2 3)) (list 1 2 3))
(check-expect (merge (list 1 5) empty) (list 1 5))
(check-expect (merge (list 3 5) (list 1 2 4)) (list 1 2 3 4 5))
(check-expect (merge (list 1 2 5) (list 3 4 6 9)) (list 1 2 3 4 5 6 9))

;; l1     /     l2 |  empty  | (listof Number)
;; -----------------------------------------
;;           empty |  l1  | l2
;; -----------------------------------------
;; (listof Number) |  l1     | ...l1 ...l2

(define (merge l1 l2)
  (cond [(empty? l1) l2]
        [(empty? l2) l1]
        [else (if (< (first l1) (first l2))
                  (cons (first l1) (merge (rest l1) l2))
                  (cons (first l2) (merge l1 (rest l2))))]))


;; (Listof X) Natural -> (Listof X)
;; Returns a subset of a list, from 0 to Natural
; (define (take lon n) empty) ; stub

(check-expect (take empty 3) empty)
(check-expect (take (list 1 2 3) 3) (list 1 2 3))
(check-expect (take (list 1 2 3) 1) (list 1))
(check-expect (take (list 1 2 3) 2) (list 1 2))
(check-expect (take (list 1 2 3) 5) (list 1 2 3))
(check-expect (take (list 1 2 3 4 5 6 7) (quotient (length (list 1 2 3 4 5 6 7)) 2)) (list 1 2 3))

(define (take lon n)
  (cond [(empty? lon) empty]
        [(< (length lon) n) lon]
        [(< n 1) empty]
        [else (cons (first lon) (take (rest lon) (sub1 n)))]))


;; (Listof X) Natural -> (Listof X)
;; Returns a subset of a list, from Natural to the rest of the list
; (define (drop lon n) empty) ; stub

(check-expect (drop empty 3) empty)
(check-expect (drop (list 1 2 3) 3) empty)
(check-expect (drop (list 1 2 3) 1) (list 2 3))
(check-expect (drop (list 1 2 3) 2) (list 3))
(check-expect (drop (list 1 2 3) 3) empty)
(check-expect (drop (list 1 2 3 4 5 6 7) (quotient (length (list 1 2 3 4 5 6 7)) 2)) (list 4 5 6 7))

(define (drop lon n)
  (cond [(empty? lon) empty]
        [(<= n 0) lon]
        [else (drop (rest lon) (sub1 n))]))
