;; Recursion may affect performances in programming languages with a low level of compiling
;; optimization. In the current case, the find-slow function recompute the entire tree at each
;; iteration, while find-fast save the result of the computation into a local, with great
;; benefit performance-wise. See results after running.


;; ========================
;; Data definitions
;; ========================

(define-struct el (name data subs))
;; Element is (make-elt String Integer ListOfElements)
;; interp. An element in the file system, with name, and EITHER data or subs.
;;         If data is 0, then subs is considered to be list of sub elements.
;;         If data is not 0, then subs is ignored.

;; ListOfElements is one of:
;;  - empty
;;  - (cons Element ListOfElements)
;; interp. A list of file system Elements

(define F1 (make-el "F1" 1 empty))        ; simple file, contains 1 as data
(define F2 (make-el "F2" 2 empty))
(define F3 (make-el "F3" 3 empty))
(define D4 (make-el "D4" 0 (list F1 F2))) ; directory with two files
(define D5 (make-el "D5" 0 (list F3)))
(define D6 (make-el "D6" 0 (list D4 D5))) ; directory with sub directories
(define D0 (make-el "D0" 0 empty))        ; empty directory

#;
(define (fn-for-el e)
  (local [
          (define (fn-for-element e)
            (... (el-name e)              ; String
                 (el-data e)              ; Integer
                 (fn-for-loe (el-subs e)) ; ListOfElements
                 ))

          (define (fn-for-loe loe)
            (cond [(empty? loe) (...)]
                  [else
                   (... (fn-for-el (first loe))  ; Element
                        (fn-for-loe (rest loe))  ; ListOfElements
                        )]))
          ]
    (fn-for-element e)))


;; ListOfStrings is one of:
;; - empty
;; - (cons String ListOfStrings)
;; Interp. A list of strings, like names

(define LOS0 empty)
(define LOS1 (cons "F1" empty))
(define LOS2 (cons "F2" LOS1))
(define LOS3 (cons "F3" LOS2))


;; ========================
;; Functions
;; ========================

;; String Element -> String
;; Search the tree for a given element by its name, returns the element's value if found, false otherwise
; (define (find s e) false) ; stub

(check-expect (find-slow "nope" D6) false)
(check-expect (find-slow "F1" D5) false)
(check-expect (find-slow "F2" D4) 2)
(check-expect (find-slow "F3" D6) 3)
(check-expect (find-slow "D5" D5) 0)

(define (find-slow s e)
  (local [
          (define (fn-for-element s e)
            (if (string=? s (el-name e))
                (el-data e)
                (fn-for-loe s (el-subs e))
                ))

          (define (fn-for-loe s loe)
            (cond [(empty? loe) false]
                  [else
                   (if (not (false? (fn-for-element s (first loe))))
                       (fn-for-element s (first loe))
                       (fn-for-loe s (rest loe))
                       )]))
          ]
    (fn-for-element s e)))

(define (find-fast s e)
  (local [
          (define (fn-for-element s e)
            (if (string=? s (el-name e))
                (el-data e)
                (fn-for-loe s (el-subs e))
                ))

          (define (fn-for-loe s loe)
            (cond [(empty? loe) false]
                  [else
                   (local [(define try (fn-for-element s (first loe)))]
                     (if (not (false? try))
                         try
                         (fn-for-loe s (rest loe))
                         )
                     )]))
          ]
    (fn-for-element s e)))


;; Natural -> Element
;; Returns an element n levels deep, all levels are "D" as directories, final level is "F" as file
; (define (make-deep n) empty) ; stub

(check-expect (make-deep 0) (make-el "F" 1 empty))
(check-expect (make-deep 2) (make-el "D" 0 (list (make-el "D" 0 (list (make-el "F" 1 empty))))))

(define (make-deep n)
  (cond [(zero? n) (make-el "F" 1 empty)]
        [else (make-el "D" 0 (list (make-deep (sub1 n))))]))


;; ========================
;; Performances
;; ========================

"-----------------"
"find-slow"
(time (find-slow "F" (make-deep 15)))
(time (find-slow "F" (make-deep 16)))
(time (find-slow "F" (make-deep 17)))
(time (find-slow "F" (make-deep 18)))
(time (find-slow "F" (make-deep 19)))
"-----------------"
"find-fast"
(time (find-fast "F" (make-deep 15)))
(time (find-fast "F" (make-deep 16)))
(time (find-fast "F" (make-deep 17)))
(time (find-fast "F" (make-deep 18)))
(time (find-fast "F" (make-deep 19)))
