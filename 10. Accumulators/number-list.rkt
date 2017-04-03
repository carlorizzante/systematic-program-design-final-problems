;; (listof String) -> (listof String)
;; append each string's position in the list to the front of the string to number the list
; (define (number-list los) los)   ;stub

(check-expect (number-list empty) empty)
(check-expect (number-list (list "first" "second" "third"))
              (list "1: first" "2: second" "3: third"))

#; ;; templating for function with accumulator
(define (fn-with-acc lox)
  ;; acc: ...
  (local [(define (sub _lox acc)
            (cond [(empty? _lox) (... acc)]
                  [else (... acc
                             (first _lox)
                             (sub (rest _lox) (... acc)))]))]
    (sub lox ...)))

(define (number-list lox)
  ;; acc: ...
  (local [(define (sub _lox acc)
            (cond [(empty? _lox) empty]
                  [else (cons (string-append (number->string acc) ": "
                                             (first _lox))
                                             (sub (rest _lox) (add1 acc)))]))]
    (sub lox 1)))
