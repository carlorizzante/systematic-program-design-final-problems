;; (listof Number) -> Number
;; Returns the average of all numbers in the list
; (define (average lon) 0) ; stub

(check-expect (average (list 0)) 0)
(check-expect (average (list 1)) 1)
(check-expect (average (list 1 2)) 1.5)
(check-expect (average (list 1 2 3)) 2)
(check-expect (average (list 4 6 8 10 12 14 16 18)) 11)

(define (average lon)
  (local [(define (sub _lon acc count)
            (cond [(empty? _lon) (/ acc count)]
                  [else
                   (sub (rest _lon)
                        (+ acc (first _lon))
                        (+ 1 count))]))]
    (sub lon 0 0)))
