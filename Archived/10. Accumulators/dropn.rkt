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
;; Returns the original list minus the nth items in the list
; (define (dropn lox n) empty) ; stub

(check-expect (dropn empty 0) empty)
; (check-expect (dropn (list "A" "B" "C") 0) (list "A" "B" "C"))
(check-expect (dropn (list "A" "B" "C" "D" "E") 1) (list "A" "C" "E"))
(check-expect (dropn (list "A" "B" "C" "D" "E" "F" "G") 2) (list "A" "B" "D" "E" "G"))
(check-expect (dropn (list A B A B A B) 1) (list A A A))
(check-expect (dropn (list 1 2 3 4 5 6 7 8 9) 3) (list 1 2 3 5 6 7 9))

(define (dropn lox n)
  ;; acc is Number - progressive position of element in lox (initially 0)
  (local [ ; (define step (add1 n))
          (define (sub _lox acc)
            (cond [(empty? _lox) empty]
                  [else (if (zero? (remainder acc (+ 1 n)))
                            (sub (rest _lox) (add1 acc))
                            (cons (first _lox) (sub (rest _lox) (add1 acc)))
                            )]))]
    (sub lox 1)))
