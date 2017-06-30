;; ======================
;; Functions
;; ======================

;; Integer[>=1] -> (listof Integer[>=1])
;; produce hailstone sequence for n
(check-expect (hailstones 1) (list 1))
(check-expect (hailstones 2) (list 2 1))
(check-expect (hailstones 4) (list 4 2 1))
(check-expect (hailstones 5) (list 5 16 8 4 2 1))

(define (hailstones n)
  (cond [(= n 1) (list n)]
        [else (if (even? n)
                  (cons n (hailstones (/ n 2)))
                  (cons n (hailstones (+ 1 (* n 3)))))]))
#;
(define (hailstones n)
  (if (= n 1)
      (list 1)
      (cons n
            (if (even? n)
                (hailstones (/ n 2))
                (hailstones (add1 (* n 3)))))))


;; ======================
;; Problem 1
;; ======================

;; Base case: (<= s BASE)
;; Reduction step: (/ s 2)
;; Argument: BASE > 0 and (s >=0) -> 0
#;
(define (stri s)
  (if (<= s BASE)
      (mtri s)
      (local [(define sub (stri (/ s 2)))]
        (overlay (mtri s)
                 (above sub
                        (beside sub sub))))))


;; ======================
;; Problem 2
;; ======================

;; Base case: (<= s BASE)
;; Reduction step: (/ s 3)
;; Argument: BASE > 0 and (s >=0) -> 0
#;
(define (scarpet s)
  (if (<= s BASE)
      (msquare s)
      (local [(define sub (scarpet (/ s 3)))
              (define blk (square (/ s 3) "solid" "white"))]
        (above (beside sub sub sub)
               (beside sub blk sub)
               (beside sub sub sub)))))


;; ======================
;; Problem 3
;; ======================

;; Base case: (= n 1)
;; Reduction step:  if n even  (/ n 2)
;;                  if n odd   (+ 1 (* n 3))
;; Argument:
#;
(define (hailstones n)
  (cond [(= n 1) (list n)]
        [else (if (even? n)
                  (cons n (hailstones (/ n 2)))
                  (cons n (hailstones (+ 1 (* n 3)))))]))
