;; (Listof Number) -> Number
;; Returns the product of all numbers in the list
; (define (product lon) empty) ; stub

(check-expect (product empty) 1)
(check-expect (product (list 1 2 3)) 6)
(check-expect (product (list 2.5 1 -4)) -10)

#;
(define (product lon)
  (cond [(empty? lon) 1]
        [else
         (* (first lon)
            (product (rest lon)))]))

#;
(define (product lon acc)
  (cond [(empty? lon) ... acc]
        [else (... acc (first lon)
                   (product (rest lon)))]))

#;
(define (product lon0)
  (local [(define (product lon acc)
  (cond [(empty? lon) ... acc]
        [else (... acc (first lon)
                   (product (rest lon)))]))]
    (product lon0 ...)))


(define (product lon0)
  ;; acc is product of all number parsed so far, starts at 1
  (local [(define (product lon acc)
  (cond [(empty? lon) acc]
        [else (product (rest lon) (* acc (first lon)))]))]
    (product lon0 1)))
