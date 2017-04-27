;; Natural -> Natural
;; Given a size of a square, returns its area
; (define (sqrarea n) 0) ; stub

(check-expect (sqrarea 0) 0)
(check-expect (sqrarea 3) 9)
(check-expect (sqrarea 12) 144)

#; ; template
(define (sqrarea n)
  (... n))

(define (sqrarea n)
  (* n n))
