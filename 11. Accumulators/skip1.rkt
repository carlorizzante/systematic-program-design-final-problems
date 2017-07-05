;; (Listof X) -> (Listof X)
;; Returns a new list of elements in odd position from the original list
; (define (skip1 lox) empty) ; stub

(check-expect (skip1 empty) empty)
(check-expect (skip1 (list 1 2 3 4 5 6)) (list 1 3 5))
(check-expect (skip1 (list "1" "2" "3")) (list "1" "3"))

#;
(define (skip1 lox)
  (cond [(empty? lox) ...]
        [else (... (first lox)
                   (skip1 (rest lox)))]))

#;
(define (skip1 lox acc)
  (cond [(empty? lox) ...]
        [else (... acc
                   (first lox)
                   (skip1 (rest lox) (... acc)))]))

#;
(define (skip1 lox)
  (local [(define (skip1 lox acc)
            (cond [(empty? lox) ...]
                  [else (... acc
                             (first lox)
                             (skip1 (rest lox) (... acc)))]))]
    (skip1 lox ...)))

#;
(define (skip1 lox)
  ;; acc: ...
  (local [(define (skip1 lox acc)
            (cond [(empty? lox) ...]
                  [else (... acc
                             (first lox)
                             (skip1 (rest lox) (... acc)))]))]
    (skip1 lox ...)))


(define (skip1 lox)
  ;; acc: Natural, indexing for current (first lox) in the given initial (Listof X)
  ;; acc starts at 1...
  (local [(define (skip1 lox acc)
            (cond [(empty? lox) empty]
                  [else (if (odd? acc)
                            (cons (first lox) (skip1 (rest lox) (add1 acc)))
                            (skip1 (rest lox) (add1 acc)))]))]
    (skip1 lox 1)))


;; ===============================
;; Accumulator as 1 or 0 - binary

(check-expect (skip1b empty) empty)
(check-expect (skip1b (list 1 2 3 4 5 6)) (list 1 3 5))
(check-expect (skip1b (list "1" "2" "3")) (list "1" "3"))

(define (skip1b lox)
  ;; acc: binary 1 or 0
  ;; acc starts as 1
  (local [(define (skip1 lox acc)
            (cond [(empty? lox) empty]
                  [else (if (odd? acc)
                            (cons (first lox) (skip1 (rest lox) 0))
                            (skip1 (rest lox) 1))]))]
    (skip1 lox 1)))
