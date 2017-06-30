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
; (define (skipn lox) empty) ; stub


(check-expect (skipn empty 0) empty)
(check-expect (skipn (list "a" "b" "c") 0) (list "a" "b" "c"))
(check-expect (skipn (list "a" "b" "c" "d" "e" "f" "g") 1) (list "a" "c" "e" "g"))
(check-expect (skipn (list 1 2 3 4 5 6 7) 1) (list 1 3 5 7))
(check-expect (skipn (list A B A B A B) 1) (list A A A))
(check-expect (skipn (list "a" "b" "c" "d" "e" "f" "g") 2) (list "a" "d" "g"))
(check-expect (skipn (list 1 2 3 4 5 6 7) 2) (list 1 4 7))
(check-expect (skipn (list A B A B A B A) 2) (list A B A))

#; ;; templating for function with accumulator
(define (fn-with-acc lox)
  ;; acc: ...
  (local [(define (sub _lox acc)
            (cond [(empty? _lox) (... acc)]
                  [else (... acc
                             (first _lox)
                             (sub (rest _lox) (... acc)))]))]
    (sub lox ...)))


(define (skipn lox n)
  ;; acc is Number - progressive position of element in lox (initially 0)
  (local [(define step (add1 n))
          (define (sub _lox acc)
            (cond [(empty? _lox) empty]
                  [else (if (zero? (remainder acc step))
                            (cons (first _lox) (sub (rest _lox) (add1 acc)))
                            (sub (rest _lox) (add1 acc)))]))]
    (sub lox 0)))
