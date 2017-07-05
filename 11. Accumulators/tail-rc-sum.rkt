;; ====================
;; No Tail Recursion
;; ====================

;; (Listof Number) -> Number
;; produce sum of all elements of lon

(check-expect (sum empty) 0)
(check-expect (sum (list 2 4 5)) 11)

(define (sum lon)
  (cond [(empty? lon) 0]
        [else
         (+ (first lon)
            (sum (rest lon)))]))


;; ====================
;; Tail Recursive
;; ====================

;; (List of Number) -> Number
;; Returns the sum of all numbers in the list

(check-expect (sum-tr empty) 0)
(check-expect (sum-tr (list 2 4 5)) 11)

(define (sum-tr lon)
  (local [(define (sum lon acc)
            (cond [(empty? lon) acc]
                  [else (sum (rest lon) (+ acc (first lon)))]))]
    (sum lon 0)))


;; ====================
;; Templating for tail recursion with acc
;; ====================

#;
(define (sum lon)
  (cond [(empty? lon) ...]
        [else (... (first lon)
                   (sum (rest lon)))]))

#;
(define (sum lon acc)
  (cond [(empty? lon) (... acc)]
        [else (... acc
                   (first lon)
                   (sum (rest lon) (... acc)))]))

#;
(define (sum lon0)
  (local [(define (sum lon acc)
            (cond [(empty? lon) (... acc)]
                  [else (... acc           ; we gotta remove this two
                             (first lon)   ; lines from the recursive call
                             (sum (rest lon) (... acc)))]))]
    (sum lon0 ...)))

#;
(define (sum lon0)
  ;; acc is the sum of numbers seen so far in the ongoing list
  (local [(define (sum lon acc)
            (cond [(empty? lon) acc]
                  [else (sum (rest lon) (+ acc (first lon)))]))]
    (sum lon0 0)))
  
