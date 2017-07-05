;; (Listof Number) -> Boolean
;; produce true if all numbers in lon are positive
(check-expect (all-positive? empty) true)
(check-expect (all-positive? (list 1 2)) true)
(check-expect (all-positive? (list 1 2 -3)) false)

;; No tail recursion
(define (all-positive? lon)
  (cond [(empty? lon) true]
        [else
         (and (positive? (first lon))
              (all-positive? (rest lon)))]))


;; Tail recursive
(check-expect (all-positive?2 empty) true)
(check-expect (all-positive?2 (list 1 2)) true)
(check-expect (all-positive?2 (list 1 2 -3)) false)

(define (all-positive?2 lon)
  (cond [(empty? lon) true]
        [else
         (if (negative? (first lon))
             false
             (all-positive?2 (rest lon)))]))
