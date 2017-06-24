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

(define (fn-for-elt e)
  (... (elt-name e)                   ; String
       (elt-data e)                   ; Integer
       (fn-for-loe (elt-subs e))))    ; ListOfElement

(define (fn-for-loe loe)
  (cond [(empty? loe) (...)]
        [else (... (fn-for-elt (first loe))       ; Element
                   (fn-for-loe (rest loe)))]))    ; ListOfElement


;; ================================
;; Functions
;; ================================

;; Element -> Integer
;; ListOfElement -> Integer
;; Returns the sum of the file data in the files within a tree
; (define (total--elt e) 0)   ; stub
; (define (total--loe loe) 0) ; stub

(check-expect (total--elt F1) 1)
(check-expect (total--elt F2) 2)

(check-expect (total--loe empty) 0)

(check-expect (total--elt D5) 3)
(check-expect (total--elt D4) 3)
(check-expect (total--elt D6) 6)

(define (total--elt e)
  (+ (elt-data e)                 ; Integer
     (total--loe (elt-subs e))))  ; ListOfElement

(define (total--loe loe)
  (cond [(empty? loe) 0]
        [else (+ (total--elt (first loe))     ; Element
                 (total--loe (rest loe)))]))  ; ListOfElement

;; Prof's version

(check-expect (total--elt2 F1) 1)
(check-expect (total--elt2 F2) 2)

(check-expect (total--loe2 empty) 0)

(check-expect (total--elt2 D5) 3)
(check-expect (total--elt2 D4) 3)
(check-expect (total--elt2 D6) 6)

(define (total--elt2 e)
  (if (zero? (elt-data e))
      (total--loe2 (elt-subs e))
      (elt-data e)))

(define (total--loe2 loe)
  (cond [(empty? loe) 0]
        [else (+ (total--elt2 (first loe))     ; Element
                 (total--loe2 (rest loe)))]))  ; ListOfElement


;; Element -> ListOfString
;; ListOfElement -> ListOfString
;; Returns a list of the names of all the elements in the tree
; (define (names--elt e) empty)   ; stub
; (define (names--loe loe) empty) ; stub

(check-expect (names--loe empty) empty)
(check-expect (names--elt F1) (list "F1"))
(check-expect (names--elt F2) (list "F2"))
(check-expect (names--elt F3) (list "F3"))
(check-expect (names--elt D4) (list "D4" "F1" "F2"))
(check-expect (names--loe (list D4 D5)) (append (list "D4" "F1" "F2") (list "D5" "F3")))
(check-expect (names--elt D6) (list "D6" "D4" "F1" "F2" "D5" "F3"))

(define (names--elt e)
  (cons (elt-name e)                   ; String
        (names--loe (elt-subs e))))    ; ListOfElement

(define (names--loe loe)
  (cond [(empty? loe) empty]
        [else (append (names--elt (first loe))       ; Element
                      (names--loe (rest loe)))]))    ; ListOfElement


;; String Element -> Boolean
;; String ListOfElement -> Boolean
;; Returns true if there is an element in the tree with a given name, false otherwise
; (define (is-element--elt? str elt) false) ; stub
; (define (is-element--loe? str loe) false) ; stub

(check-expect (is-element--loe? "abc" empty) false)
(check-expect (is-element--elt? "F1" F1) true)
(check-expect (is-element--elt? "D5" D5) true)
(check-expect (is-element--elt? "F2" D6) true)
(check-expect (is-element--elt? "D4" D6) true)
(check-expect (is-element--elt? "F3" D6) true)

(define (is-element--elt? str e)
  (or (string=? str (elt-name e))
      true
      (is-element--loe? str (elt-subs e))))

(define (is-element--loe? str loe)
  (cond [(empty? loe) false]
        [else (or (is-element--elt? str (first loe))
                  (is-element--loe? str (rest loe)))]))


;; ================================
;; Rendering
;; ================================

(define TEXT "white")
(define SIZE 14)

(define STYLE "solid")
(define BG "black")
(define WIDTH 40)
(define HEIGHT 20)
(define BOX (rectangle WIDTH HEIGHT STYLE BG))

(define PADDING 10)
(define PAD (rectangle PADDING PADDING "solid" "red"))


;; Element -> Image
;; ListOfElement -> Image
;; Given a starting Element, renders the tree within
; (define (render-tree--elt elt) empty-image) ; stub
; (define (render-tree--loe loe) empty-image) ; stub

(check-expect (render-tree--loe empty) empty-image)
(check-expect (render-tree--elt F1) (render-element F1))
(check-expect (render-tree--elt D5) (above (render-element D5)
                                           PAD
                                           (render-element F3)))
(check-expect (render-tree--elt D4) (above (render-element D4)
                                           PAD
                                           (beside (render-element F1)
                                                   PAD
                                                   (render-element F2))))
(check-expect (render-tree--elt D6) (above (render-element D6)
                                           PAD
                                           (beside
                                            (above (render-element D4)
                                                   PAD
                                                   (beside (render-element F1)
                                                           PAD
                                                           (render-element F2)))
                                            PAD
                                            (above (render-element D5)
                                                   PAD
                                                   (render-element F3)))))

(define (render-tree--elt e)
  (above (render-element e)
         (cond [(empty? (elt-subs e)) empty-image]
               [else PAD])
         (render-tree--loe (elt-subs e))))

(define (render-tree--loe loe)
  (cond [(empty? loe) empty-image]
        [else (beside (render-tree--elt (first loe))
                      (cond [(empty? (rest loe)) empty-image]
                            [else PAD])
                      (render-tree--loe (rest loe)))]))


;; Element -> Image
;; Renders a single element within a box
(define (render-element elt)
  (overlay (text "F1" SIZE TEXT)
           BOX))
