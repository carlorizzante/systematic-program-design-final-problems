;; ======================
;; Sum
;; ======================

;; (listof Number) -> Number
;; Returns the sum of all numbers in the (listof Number)

(check-expect (sum empty) 0)
(check-expect (sum (list 2 4 5)) 11)

#; ;; This function build up a calculation dept (no tail recursion)
;; (+ 1 (+ 2 (+ 3 (+ 4 (+ 5 ... 0)))))
(define (sum lon)
  (cond [(empty? lon) 0]
        [else
         (+ (first lon)
            (sum (rest lon)))]))

#; ;; templating for recursion with accumulator
(define (sum lon)
  (local [(define (sub _lon acc)
            (cond [(empty? _lon) (... acc)]
                  [else
                   (... acc
                        (first _lon)
                        (sub (rest _lon) (... acc)))]))]
    (sub lon ...)))

#; ;; templating with clean tail recursion
(define (sum lon)
  (local [(define (sub _lon acc)
            (cond [(empty? _lon) (... acc)]
                  [else
                   (sub (rest _lon) (... acc (first _lon)))]))]
    (sub lon ...)))

(define (sum lon)
  (local [(define (sub _lon acc)
            (cond [(empty? _lon) acc]
                  [else
                   (sub (rest _lon) (+ acc (first _lon)))]))]
    (sub lon 0)))


;; ======================
;; Product
;; ======================

;; (listof Number) -> Number
;; Returns the product of all numbers in the (listof Number)

(check-expect (product (list 1 2 3)) 6)
(check-expect (product (list 2 4 8)) 64)

(define (product lon)
  (local [(define (sub _lon acc)
            (cond [(empty? _lon) acc]
                  [else
                   (sub (rest _lon) (* acc (first _lon)))]))]
    (sub lon 1)))


;; ======================
;; Average
;; ======================

;; (listof Number) -> Number
;; Returns the average of all numbers in the (listof Number)

(check-expect (average (list 1 2 3)) 2)
(check-expect (average (list 2 4 8 16 32 64)) 21)

(define (average lon)
  (local [(define (sub _lon acc1 acc2)
            (cond [(empty? _lon) (/ acc1 acc2)]
                  [else
                   (sub (rest _lon) (+ acc1 (first _lon)) (+ acc2 1))]))]
    (sub lon 0 0)))
