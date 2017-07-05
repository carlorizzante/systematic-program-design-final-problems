;; (Listof X) -> (Listof X)
;; Returns a new list with only elements at nth index
; (define (skipn n lox) empty) ; stub

(check-expect (skipn 1 empty) empty)
(check-expect (skipn 1 (list 1 2 3 4 5 6)) (list 1 3 5))
(check-expect (skipn 2 (list "a" "b" "c" "d" "e" "f" "g")) (list "a" "d" "g"))
(check-expect (skipn 3 (list 1 2 3 4 5 6 7 8 9 10)) (list 1 5 9))


#;
(define (skipn n lox)
  (cond [(empty? lox) ...]
        [else (... (first lox)
                   (skipn (...n) (rest lox)))]))

#;
(define (skipn n lox)
  (cond [(empty? lox) ...]
        [else (... index
                   (first lox)
                   (skipn (...n) (rest lox)))]))

#;
(define (skipn n lox index)
  (cond [(empty? lox) ...]
        [else (... index
                   (first lox)
                   (skipn (...n) (rest lox) (... index)))]))

#;
(define (skipn n lox index)
  ;; Index is Natural[1, ...] - increments by 1
  (cond [(empty? lox) empty]
        [else (if (... index n)
                  (cons (first lox) (skipn n (rest lox) (add1 index)))
                  (skipn n (rest lox) (add1 index)))]))

#;
(define (skipn n lox)
  (local [(define (skipn n lox index)
            ;; Index is Natural[1, ...] - increments by 1
            (cond [(empty? lox) empty]
                  [else (if (... index n)
                            (cons (first lox) (skipn n (rest lox) (add1 index)))
                            (skipn n (rest lox) (add1 index)))]))]
    (skipn n lox ...)))

;; Final
(define (skipn n lox)
  (local [(define (skipn n lox index)
            ;; Index is Natural[0, ...] - increments by 1, starts at 0
            (cond [(empty? lox) empty]
                  [else (if (= (remainder index (+ n 1)) 0)
                            (cons (first lox) (skipn n (rest lox) (add1 index)))
                            (skipn n (rest lox) (add1 index)))]))]
    (skipn n lox 0)))

;; Alternative with accumulator as countdown

(check-expect (skipn2 1 empty) empty)
(check-expect (skipn2 1 (list 1 2 3 4 5 6)) (list 1 3 5))
(check-expect (skipn2 2 (list "a" "b" "c" "d" "e" "f" "g")) (list "a" "d" "g"))
(check-expect (skipn2 3 (list 1 2 3 4 5 6 7 8 9 10)) (list 1 5 9))

(define (skipn2 n lox)
  (local [(define (skipn n lox countdown)
            ;; Index is Natural[0, n] - countdown from n to 0
            (cond [(empty? lox) empty]
                  [else (if (zero? countdown)
                            (cons (first lox) (skipn n (rest lox) n))
                            (skipn n (rest lox) (sub1 countdown)))]))]
    (skipn n lox 0)))
