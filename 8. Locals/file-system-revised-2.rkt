(require 2htdp/image)

;; Steps to encapsulation
;; - Group all functions to encapsulate
;; - Define a new, global function to be call instead
;; - Define a local environment within the global function
;; - Encapsulate all previous related functions within the local environment
;; - Within this local environment, add a call to the primary helper
;; - Edit signature, stubs, and tests accordingly


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

;; Element -> Integer
;; Given an element, returns the sum of all the file data in the tree
; (define (sum-data e) 0) ; stub

(check-expect (sum-data D0) 0)
(check-expect (sum-data F1) 1)
(check-expect (sum-data F2) 2)
(check-expect (sum-data D4) 3)
(check-expect (sum-data D6) 6)

(define (sum-data e)
  (local [
          (define (fn-for-element e)
            (if (zero? (el-data e))
                (fn-for-loe (el-subs e))
                (el-data e)
                ))

          (define (fn-for-loe loe)
            (cond [(empty? loe) 0]
                  [else
                   (+ (fn-for-element (first loe))
                      (fn-for-loe (rest loe))
                      )]))
          ]
    (fn-for-element e)))


;; Element -> ListOfStrings
;; Given an element, returns a list of all the names in the tree
; (define (all-names e) empty) ; stub

(check-expect (all-names F1) (list "F1"))
(check-expect (all-names F2) (list "F2"))
(check-expect (all-names D0) (list "D0"))
(check-expect (all-names D6) (list "D6" "D4" "F1" "F2" "D5" "F3"))

(define (all-names e)
  (local [
          (define (fn-for-element e)
            (cons (el-name e) (fn-for-loe (el-subs e))))

          (define (fn-for-loe loe)
            (cond [(empty? loe) empty]
                  [else
                   (append (fn-for-element (first loe))
                           (fn-for-loe (rest loe))
                           )]))
          ]
    (fn-for-element e)))


;; String Element -> Boolean
;; Given a string and an element, returns true if there is an element with that name in the tree, false otherwise
; (define (has-name? s e) false) ; stub

(check-expect (has-name? "nope" F1) false)
(check-expect (has-name? "F1" F1) true)
(check-expect (has-name? "F3" D4) false)
(check-expect (has-name? "F3" D6) true)

(define (has-name? s e)
  (local [
          (define (fn-for-element s e)
            (if (equal? s (el-name e))
                true
                (fn-for-loe s (el-subs e))
                ))

          (define (fn-for-loe s loe)
            (cond [(empty? loe) false]
                  [else
                   (or (fn-for-element s (first loe))
                       (fn-for-loe s (rest loe))
                       )]))
          ]
    (fn-for-element s e)))


;; String Element -> String
;; Search the tree for a given element by its name, returns the element's value if found, false otherwise
; (define (find s e) false) ; stub

(check-expect (find "nope" D6) false)
(check-expect (find "F1" D5) false)
(check-expect (find "F2" D4) 2)
(check-expect (find "F3" D6) 3)
(check-expect (find "D5" D5) 0)

(define (find s e)
  (local [
          (define (fn-for-element s e)
            (if (string=? s (el-name e))
                (el-data e)
                (fn-for-loe s (el-subs e))
                ))

          (define (fn-for-loe s loe)
            (cond [(empty? loe) false]
                  [else
                   (if (not? (false? (fn-for-element s (first loe))))
                       (fn-for-element s (first loe))
                       (fn-for-loe s (rest loe))
                       )]))
          ]
    (fn-for-element s e)))


;; Element -> Image
;; Given an element, it renders a tree of its data structure
; (define (render-tree e) empty-image) ; stub

(check-expect (render-tree D0) (render-e D0))
(check-expect (render-tree F1) (render-e F1))
(check-expect (render-tree D6) (above
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
(define (render-tree e)
  (local [
          (define (fn-for-element e)
            (above (render-e e)
                   (if (not? (empty? (el-subs e))) PAD empty-image)
                   (fn-for-loe (el-subs e))
                   ))

          (define (fn-for-loe loe)
            (cond [(empty? loe) empty-image]
                  [else
                   (beside/align "top"
                                 (fn-for-element (first loe))
                                 (if (not? (empty? (rest loe))) PAD empty-image)
                                 ;         (if (empty? (rest loe)) empty-image PAD) ; inverted solution for the line above
                                 (fn-for-loe (rest loe))
                                 )]))
          ]
    (fn-for-element e)))


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

(render-tree D6)
(all-names D6) ; (list "D6" "D4" "F1" "F2" "D5" "F3")
(find "F3" D6)  ; 3
