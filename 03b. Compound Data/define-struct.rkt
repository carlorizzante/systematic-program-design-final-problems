(define-struct pos (x y))

;; Constructor
(define P1 (make-pos 3 6))

P1          ; (make-pos 3 6)

;; Selectors
(pos-x P1)  ; 3
(pos-y P1)  ; 6

;; Predicate
(pos? P1)  ; true
(pos? "a") ; false
