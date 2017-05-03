(define-struct player (first last))
;; Player is (make-player String String)
;; Interpretation: (make-player first last) is a player
;; - first     is first name
;; - last      is last name

(define P1 (make-player "Jon" "Snow"))
(define P2 (make-player "Drake" "Johnson"))

#;
(define (fn-for-player p)
  (... (player-first p)     ; String
       (player-last p)      ; String
       ))

;; Template rules used:
;; - Compound with 2 fields
;; -- String    first name
;; -- String    last name
