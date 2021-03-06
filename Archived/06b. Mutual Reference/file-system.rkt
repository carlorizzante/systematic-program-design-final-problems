(require 2htdp/image)

;; ========================
;; Constants
;; ========================

(define TEXT-SIZE 10)
(define TEXT-COLOR "teal")
(define PAD (rectangle 20 20 "solid" "white"))


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
(define (fn-for-elements e)
  (... (el-name e)              ; String
       (el-data e)              ; Integer
       (fn-for-loe (el-subs e)) ; ListOfElements
       ))

#;
(define (fn-for-loe loe)
  (cond [(empty? loe) (...)]
        [else
         (... (fn-for-el (first loe))  ; Element
              (fn-for-loe (rest loe))  ; ListOfElements
              )]))


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

;; Element -> Integer
;; ListOfElements -> Integer
;; Given an element, returns the sum of all the file data in the tree
; (define (sum-data--el e) 0) ; stub
; (define (sum-data--loe loe) loe) ; stub

(check-expect (sum-data--loe empty) 0)
(check-expect (sum-data--el D0) 0)
(check-expect (sum-data--el F1) 1)
(check-expect (sum-data--el F2) 2)
(check-expect (sum-data--el D4) 3)
(check-expect (sum-data--el D6) 6)

(define (sum-data--el e)
  (if (zero? (el-data e))
             (sum-data--loe (el-subs e))
             (el-data e)
             ))

(define (sum-data--loe loe)
  (cond [(empty? loe) 0]
        [else
         (+ (sum-data--el (first loe))
            (sum-data--loe (rest loe))
            )]))


;; Element -> ListOfStrings
;; ListOfElements -> ListOfStrings
;; Given an element, returns a list of all the names in the tree
; (define (all-names--el e) empty) ; stub
; (define (all-names-loe loe) empty) ; stub

(check-expect (all-names--loe empty) empty)
(check-expect (all-names--el F1) (list "F1"))
(check-expect (all-names--el F2) (list "F2"))
(check-expect (all-names--el D0) (list "D0"))
(check-expect (all-names--el D6) (list "D6" "D4" "F1" "F2" "D5" "F3"))

(define (all-names--el e)
  (cons (el-name e) (all-names--loe (el-subs e))))

(define (all-names--loe loe)
  (cond [(empty? loe) empty]
        [else
         (append (all-names--el (first loe))
                 (all-names--loe (rest loe))
                 )]))


;; String Element -> Boolean
;; ListOfString -> Boolean
;; Given a string and an element, returns true if there is an element with that name in the tree, false otherwise
; (define (has-name--el? s e) false) ; stub
; (define (has-name--loe? s loe) loe) ; stub

(check-expect (has-name--el? "nope" F1) false)
(check-expect (has-name--el? "F1" F1) true)
(check-expect (has-name--el? "F3" D4) false)
(check-expect (has-name--el? "F3" D6) true)

(define (has-name--el? s e)
  (if (equal? s (el-name e))
       true
       (has-name--loe? s (el-subs e))
       ))

(define (has-name--loe? s loe)
  (cond [(empty? loe) false]
        [else
         (or (has-name--el? s (first loe))
             (has-name--loe? s (rest loe))
             )]))


;; String Element -> String
;; ListOfString -> String
;; Search the tree for a given element by its name, returns the element's value if found, false otherwise
; (define (find--el s e) false) ; stub
; (define (find--loe s loe) loe) ; stub

(check-expect (find--el "nope" D6) false)
(check-expect (find--el "F1" D5) false)
(check-expect (find--el "F2" D4) 2)
(check-expect (find--el "F3" D6) 3)
(check-expect (find--el "D5" D5) 0)

(define (find--el s e)
  (if (string=? s (el-name e))
       (el-data e)
       (find--loe s (el-subs e))
       ))

(define (find--loe s loe)
  (cond [(empty? loe) false]
        [else
         (if (not? (false? (find--el s (first loe))))
             (find--el s (first loe))
             (find--loe s (rest loe))
             )]))


;; Element -> Image
;; ListOfString -> Image
;; Given an element, it renders a tree of its data structure
; (define (render-tree--el e) empty-image) ; stub
; (define (render-tree-loe loe) empty-image) ; stub

(check-expect (render-tree--loe empty) empty-image)
(check-expect (render-tree--el D0) (render-e D0))
(check-expect (render-tree--el F1) (render-e F1))
(check-expect (render-tree--el D6) (above
                                   (render-e D6)
                                   PAD
                                   (beside/align "top"
                                    (above
                                     (render-e D4)
                                     PAD
                                     (beside/align "top"
                                      (render-e F1)
                                      PAD
                                      (render-e F2)))
                                    PAD
                                    (above
                                     (render-e D5)
                                     PAD
                                     (render-e F3)))))

(define (render-tree--el e)
  (above (render-e e)
         (if (not? (empty? (el-subs e))) PAD empty-image)
         (render-tree--loe (el-subs e))
         ))

(define (render-tree--loe loe)
  (cond [(empty? loe) empty-image]
        [else
         (beside/align "top"
          (render-tree--el (first loe))
          (if (not? (empty? (rest loe))) PAD empty-image)
;         (if (empty? (rest loe)) empty-image PAD) ; inverted solution for the line above
          (render-tree--loe (rest loe))
          )]))


;; Boolean -> Boolean
;; Flips the boolean
; (define (not? b) false) ; stub

(check-expect (not? true) false)
(check-expect (not? false) true)

(define (not? b)
  (if b false true))


;; Element -> Image
;; Renders an element as image
; (define (render-e e) empty-image) ; stub

(check-expect (render-e F1) (text (el-name F1) TEXT-SIZE TEXT-COLOR))

(define (render-e e) (text (el-name e) TEXT-SIZE TEXT-COLOR))


;; ========================
;; Try out
;; ========================

(render-tree--el D6)
(all-names--el D6) ; (list "D6" "D4" "F1" "F2" "D5" "F3")
(find--el "F3" D6)  ; 3
