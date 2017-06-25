;; =============================
;; Data definitions
;; =============================

;; Player is String
;; interp.  the name of a tennis player.
(define P1 "Maria")
(define P2 "Serena")

#;
(define (fn-for-player p)
  (... p))


;; Roster is one of:
;; - empty
;; - (cons Player Roster)
;; interp.  a team roster, ordered from best player to worst.
(define R0 empty)
(define R1 (list "Eugenie" "Gabriela" "Sharon" "Aleksandra"))
(define R2 (list "Maria" "Nadia" "Elena" "Anastasia" "Svetlana"))

#;
(define (fn-for-roster r)
  (cond [(empty? r) (...)]
        [else
         (... (fn-for-player (first r))
              (fn-for-roster (rest r)))]))


(define-struct match (p1 p2))
;; Match is (make-match Player Player)
;; interp.  a match between player p1 and player p2, with same team rank
(define M1 (make-match "Eugenie" "Maria"))
(define M2 (make-match "Gabriela" "Nadia"))

#;
(define (fn-for-match m)
  (... (match-p1 m)
       (match-p2 m)))


;; ListOfMatch is one of:
;; - empty
;; - (cons Match ListOfMatch)
;; interp. a list of matches between one team and another.
(define LOM0 empty)
(define LOM1 (list (make-match "Eugenie" "Maria")
                   (make-match "Gabriela" "Nadia")))

#;
(define (fn-for-lom lom)
  (cond [(empty? lom) (...)]
        [else
         (... (fn-for-match (first lom))
              (fn-for-lom (rest lom)))]))


;; =============================
;; Functions
;; =============================

;; Roster Roster -> Boolean
;; Given two roster, returns true if they have equal number of players, false otherwise
; (define (equal-roster? r1 r2) false) ; stub

;; r1       /       r2 | empty | (cons Player Roster)
;; --------------------------------------------------------
;; empty               | true  | false
;; --------------------------------------------------------
;; (cons Player Roster | false | (... (rest r1) (rest r2))

(check-expect (equal-roster? empty empty) true)
(check-expect (equal-roster? (list "abc" "bcd") empty) false)
(check-expect (equal-roster? empty (list "abc" "bcd")) false)
(check-expect (equal-roster? (list "abc" "bcd") (list "ert" "wer" "ghj")) false)
(check-expect (equal-roster? (list "ert" "wer" "ghj") (list "abc" "bcd")) false)
(check-expect (equal-roster? (list "abc" "bcd" "rtb") (list "ert" "wer" "ghj")) true)

(define (equal-roster? r1 r2)
  (cond [(and (empty? r1) (empty? r2)) true]
        [(or (empty? r1) (empty? r2)) false]
        [else (equal-roster? (rest r1) (rest r2))]))


;; Roster Roster -> ListOfMatch
;; Given two equally numbered rosters, returns the list of corresponding matches
; (define (matches r1 r2) empty) ; stub

;; r1       /       r2 | empty | (cons Player Roster)
;; --------------------------------------------------------
;; empty               | true  | false
;; --------------------------------------------------------
;; (cons Player Roster | false | (... (rest r1) (rest r2))

(check-expect (matches empty empty) empty)
(check-expect (matches (list "a") empty) false)
(check-expect (matches empty (list "b")) false)
(check-expect (matches (list "a") (list "b")) (list (make-match "a" "b")))
(check-expect (matches (list "a" "b") (list "c" "d")) (list (make-match "a" "c")
                                                            (make-match "b" "d")))

(define (matches r1 r2)
  (cond [(and (empty? r1) (empty? r2)) empty]
        [(or (empty? r1) (empty? r2)) false]
        [else (cons (make-match (first r1) (first r2)) (matches (rest r1) (rest r2)))]))
