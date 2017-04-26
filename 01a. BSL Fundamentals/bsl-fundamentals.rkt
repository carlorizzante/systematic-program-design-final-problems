;; =====================
;; Expressions
;; =====================

;; Additions
(+ 3 4)   ; 7
(+ 1 2 3) ; 6

;; Multiplications
(* 2 3)   ; 6
(* 2 3 4) ; 24

;; Subtractions
(- 3 2) ; 1
(- 2 3) ; -1

;; Divisions
(/ 10 2) ; 5

;; More complex examples
(* 2 (+ 3 4))      ; 14
(/ (+ 10 20 30) 3) ; 20

;; More advanced operators
(sqr 3)  ; 9
(sqrt 9) ; 3
(sqrt (sqr 4)) ; 4


;; =====================
;; Practicle examples
;; =====================

;; Find the longest side of a right triangle where the other sides have length of 3 and 4
;;   |\
;; 4 | \ ?
;;   |  \
;;   ----
;;     3

(sqrt (+ (sqr 3) (sqr 4))) ; 5


;; =====================
;; Strings
;; =====================

(string-length "Jon Snow") ; 8
(substring "Jon Snow" 1 5) ; "on S"


;; =====================
;; Constant definitions
;; =====================

(define WIDTH 600)
(define HEIGHT 400)

(* WIDTH HEIGHT) ; 240000
