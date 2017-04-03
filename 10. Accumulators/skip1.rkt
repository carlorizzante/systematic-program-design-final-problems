(require 2htdp/image)

;; =============================
;; Constants
;; =============================

(define A (circle 3 "solid" "red"))
(define B (circle 3 "solid" "blue"))


;; =============================
;; Functions
;; =============================

;; (listof X) -> (listof X)
;; Returns the original list stripped of the elements in even position
; (define (skip1 lox) empty) ; stub

(check-expect (skip1 empty) empty)
(check-expect (skip1 (list "a" "b" "c" "d" "e" "f" "g")) (list "a" "c" "e" "g"))
(check-expect (skip1 (list 1 2 3 4 5 6 7)) (list 1 3 5 7))
(check-expect (skip1 (list A B A B A B)) (list A A A))

#; ;; templating for function with accumulator
(define (fn-with-acc lox)
  ;; acc: ...
  (local [(define (sub _lox acc)
            (cond [(empty? _lox) (... acc)]
                  [else (... acc
                             (first _lox)
                             (sub (rest _lox) (... acc)))]))]
    (sub lox ...)))


(define (skip1 lox)
  ;; acc is Number - progressive position of element in lox (initially 0)
  (local [(define (sub lox n)
            (cond [(empty? lox) empty]
                  [else (if (zero? (remainder n 2))
                            (cons (first lox) (sub (rest lox) (add1 n)))
                            (sub (rest lox) (add1 n)))]))]
    (sub lox 0)))
