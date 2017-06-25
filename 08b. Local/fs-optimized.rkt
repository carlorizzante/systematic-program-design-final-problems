(require 2htdp/image)

;; ================================
;; Data definitions
;; ================================

(define-struct elt (name data subs))
;; Element is (make-elt String Integer ListOfElement)
;; interp. An element in the file system, with name, and EITHER data or subs.
;;         If data is 0, then subs is considered to be list of sub elements.
;;         If data is not 0, then subs is ignored.

;; ListOfElement is one of:
;;  - empty
;;  - (cons Element ListOfElement)
;; interp. A list of file system Elements

(define F1 (make-elt "F1" 1 empty))
(define F2 (make-elt "F2" 2 empty))
(define F3 (make-elt "F3" 3 empty))
(define D4 (make-elt "D4" 0 (list F1 F2)))
(define D5 (make-elt "D5" 0 (list F3)))
(define D6 (make-elt "D6" 0 (list D4 D5)))

#; ; Template with master/outer function and encapsulation
(define (fn-for-element e)
  (local [(define (fn-for-elt e)
            (... (elt-name e)                   ; String
                 (elt-data e)                   ; Integer
                 (fn-for-loe (elt-subs e))))    ; ListOfElement

          (define (fn-for-loe loe)
            (cond [(empty? loe) (...)]
                  [else (... (fn-for-elt (first loe))       ; Element
                             (fn-for-loe (rest loe)))]))    ; ListOfElement
          ]
    (fn-for-elt e)))


;; ================================
;; Functions
;; ================================

;; String Element -> Integer or Boolean
;; Returns data if there is an element in the tree with a given name, false otherwise

; (check-expect (find--loe "abc" empty) false)
(check-expect (find "F1" F1) 1)
(check-expect (find "D5" D5) 0)
(check-expect (find "F2" D6) 2)
(check-expect (find "D4" D6) 0)
(check-expect (find "F3" D6) 3)

(define (find str e)
  (local [(define (find--elt str e)
            (if (string=? str (elt-name e))
                (elt-data e)
                (find--loe str (elt-subs e))))

          (define (find--loe str loe)
            (cond [(empty? loe) false]
                  [else (if (not (false? (find--elt str (first loe))))
                            (find--elt str (first loe))
                            (find--loe str (rest loe)))]))
          ]
    (find--elt str e)))


;; Natural -> Element
;; Returns a linear branch of a tree n+1 deep, all element has name "X" except the last which is "Y"
; (define (make-skinny n) empty) ; stub

(check-expect (make-skinny 0) (make-elt "Y" 1 empty))
(check-expect (make-skinny 2) (make-elt "X" 0 (list (make-elt "X" 0 (list (make-elt "Y" 1 empty))))))

(define (make-skinny n)
  (cond [(zero? n) (make-elt "Y" 1 empty)]
        [else (make-elt "X" 0 (list (make-skinny (- n 1))))]))


;; ================================
;; Benchmark
;; ================================

(time (find "Y" (make-skinny 10)))
(time (find "Y" (make-skinny 11)))
(time (find "Y" (make-skinny 12)))
(time (find "Y" (make-skinny 13)))
(time (find "Y" (make-skinny 14)))
(time (find "Y" (make-skinny 15)))
(time (find "Y" (make-skinny 16)))
(time (find "Y" (make-skinny 17)))
(time (find "Y" (make-skinny 18)))
(time (find "Y" (make-skinny 19)))
(time (find "Y" (make-skinny 20)))
