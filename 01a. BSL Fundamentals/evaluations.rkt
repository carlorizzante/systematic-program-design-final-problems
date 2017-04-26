;; ==========================
;; Primitive call
;; ==========================
;; A primitive call is an expression that start with open parenthesis
;; followed by the name of a primitive operation.

(* (- 4 2) 3)
(- 4 2)


;; ==========================
;; Operators
;; ==========================
; +, -, *, /, sqr, ...


;; ==========================
;; Operands
;; ==========================
;; Operands are all expressions that follow the primitive operator.
;; In the example above:
; (- 4 2)
; 4
; 2
; 3




;; ==========================
;; Evaluation
;; ==========================
;; - from left to right
;; - from inside to outside

(+ 2 (* 3 4) (- (+ 1 2) 3))
(+ 2 12      (- (+ 1 2) 3))
(+ 2 12      (- 3       3))
(+ 2 12      0)
14
