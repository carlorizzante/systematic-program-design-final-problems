(require 2htdp/image)

;; =====================
;; Constants
;; =====================

(define BASE 2)
(define COLOR "red")
(define STYLE "outline")


;; =====================
;; Sierpinsky Triangle
;; =====================

;; Natural -> Image
;; Returns a triangle of a given size, with predefined style and color
(define (mtri s) (triangle s STYLE COLOR))

;; Natural -> Image
;; Returns a Sierpinski Triangle of the given size s
; (define (stri s) empty-image) ; stub

(check-expect (stri BASE) (mtri BASE))
(check-expect (stri (* BASE 2)) (overlay (mtri (* BASE 2))
                                         (above (mtri BASE)
                                                (beside (mtri BASE) (mtri BASE)))))

#;
(define (gen-recursion d)
  (if (trivial? d)
      (trivial d)
      (... d
           (gen-recursion (next d)))))

(define (stri s)
  (if (<= s BASE)
      (mtri s)
      (local [(define sub (stri (/ s 2)))]
        (overlay (mtri s)
                 (above sub
                        (beside sub sub))))))


;; =====================
;; Sierpinski Carpet
;; =====================

;; Natural -> Image
;; Returns a square of the given size s, and default style and color
(define (msquare s) (square s STYLE COLOR))


;; Natural -> Image
;; Returns a Sierpinski Carpet of the given size
; (define (scarpet s) empty-image) ; stub

(check-expect (scarpet BASE) (msquare BASE))
(check-expect (scarpet (* BASE 3))
              (above (beside (msquare BASE) (msquare BASE) (msquare BASE))
                     (beside (msquare BASE) (square BASE "solid" "white") (msquare BASE))
                     (beside (msquare BASE) (msquare BASE) (msquare BASE))))

#;
(define (gen-recursion d)
  (if (trivial? d)
      (trivial d)
      (... d
           (gen-recursion (next d)))))
#;
(define (scarpet s)
  (if (trivial? s)
      (trivial s)
      (... s
           (scarpet (next s)))))

(define (scarpet s)
  (if (<= s BASE)
      (msquare s)
      (local [(define sub (scarpet (/ s 3)))
              (define blk (square (/ s 3) "solid" "white"))]
        (above (beside sub sub sub)
               (beside sub blk sub)
               (beside sub sub sub)))))


;; =====================
;; Try out
;; =====================

(beside
 (stri 200)
 (scarpet 200))
