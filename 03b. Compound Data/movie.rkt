;; ====================
;; Data definition
;; ====================

(define-struct movie (title budget release))
;; Movie is (make-movie String Natural Natural)
;; Interpretation: (make-movie title budget release) is a movie
;; - title       is the title of the movie
;; - budget      is the budget of the movie
;; - release     is the release date of the movie

(define M1 (make-movie "Snatch" 1000000 1981))
(define M2 (make-movie "Iron Sky" 2000000 2006))
(define M3 (make-movie "Alpha Dog" 3000000 1998))

#;
(define (fn-for-movie m)
  (... (movie-title m)       ; String
       (movie-budget m)      ; Natural
       (movie-release m)     ; Natural
       ))

;; Template rules used:
;; - Compound with 3 fields:
;; -- String          title
;; -- Natural         budget
;; -- Natural         release date


;; ====================
;; Functions
;; ====================

;; Movie Movie -> Movie
;; Given two movies, returns the title of the most recent of the two
; (define (most-recent? m1 m2) m1) ; stub

(check-expect (most-recent? M1 M2) (movie-title M2))
(check-expect (most-recent? M2 M3) (movie-title M2))
(check-expect (most-recent? M3 M1) (movie-title M3))

(define (most-recent? m1 m2)
  (if (> (movie-release m1) (movie-release m2))
      (movie-title m1)
      (movie-title m2)))
