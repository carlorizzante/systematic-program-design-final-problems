(require 2htdp/image)

;; =======================
;; Data definitions
;; =======================

;; At this point in the course, the type (listof X) means:

;; ListOfX is one of:
;; - empty
;; - (cons X ListOfX)
;; interp. a list of X

#;
(define (fn-for-lox lox)
  (cond [(empty? lox) (...)]
        [else
         (... (first lox)
              (fn-for-lox (rest lox)))]))


;; =======================
;; Functions
;; =======================

;; (X Y -> Y) Y (Listof X) -> Y
;; Abstract fold function for (Listof X)

(check-expect (fold + 0 (list 1 2 3)) (+ 1 2 3 0))

(define (fold fn base lox)
  (cond [(empty? lox) base]
        [else
         (fn (first lox)
             (fold fn base (rest lox)))]))


;; (listof Number) -> Number
;; Adds up all numbers in list
(check-expect (sum empty) 0)
(check-expect (sum (list 2 3 4)) 9)

; (define (sum lon) 0) ;stub

(define (sum lon)
  (fold + 0 lon))


;; (listof Image) -> Image
;; juxtapose all images beside each other
(check-expect (juxtapose empty) (square 0 "solid" "white"))
(check-expect (juxtapose (list (triangle 6 "solid" "yellow")
                               (square 10 "solid" "blue")))
              (beside (triangle 6 "solid" "yellow")
                      (square 10 "solid" "blue")
                      (square 0 "solid" "white")))

; (define (juxtapose loi) (square 0 "solid" "white")) ;stub

(define (juxtapose loi)
  (fold beside empty-image loi))


;; (listof X) -> (listof X)
;; produce copy of list
(check-expect (copy-list empty) empty)
(check-expect (copy-list (list 1 2 3)) (list 1 2 3))

; (define (copy-list lox) empty) ;stub

(define (copy-list lox)
  (fold cons empty lox))


;; =======================
;; Fold with BSTs
;; =======================

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

#;
(define (fn-for-element e)
  (local [(define (fn-for-element e)
            (... (elt-name e)    ; String
                 (elt-data e)    ; Integer
                 (fn-for-loe (elt-subs e))))

          (define (fn-for-loe loe)
            (cond [(empty? loe) (...)]
                  [else
                   (... (fn-for-element (first loe))
                        (fn-for-loe (rest loe)))]))]
    (fn-for-element e)))

(check-expect (local [(define (c1 name data los) (cons name los))]
                (fold-for-element c1 append empty D6)) (list "D6" "D4" "F1" "F2" "D5" "F3"))


;; (String Integer Y -> X) (X Y -> Y) Y Element -> X
;; The abstract fold fn for Element - and (Listof Element)
(define (fold-for-element c1 c2 base e)
  (local [(define (fn-for-element e) ; -> X
            (c1 (elt-name e)    ; String
                (elt-data e)    ; Integer
                (fn-for-loe (elt-subs e))))

          (define (fn-for-loe loe) ; -> Y
            (cond [(empty? loe) base]
                  [else
                   (c2 (fn-for-element (first loe))
                       (fn-for-loe (rest loe)))]))]
    (fn-for-element e)))


;; Element -> Integer
;; produce the sum of all the data in element (and its subs)
(check-expect (sum-data F1) 1)
(check-expect (sum-data D5) 3)
(check-expect (sum-data D4) (+ 1 2))
(check-expect (sum-data D6) (+ 1 2 3))

(define (sum-data e)
  (local [(define (c1 name data acc) (+ data acc))]
    (fold-for-element c1 + 0 e)))


;; Element       -> ListOfString
;; produce list of the names of all the elements in the tree
(check-expect (all-names F1) (list "F1"))
(check-expect (all-names D5) (list "D5" "F3"))
(check-expect (all-names D4) (list "D4" "F1" "F2"))
(check-expect (all-names D6) (list "D6" "D4" "F1" "F2" "D5" "F3"))

(define (all-names e)
  (local [(define (c1 name data loe) (cons name loe))]
    (fold-for-element c1 append empty e)))
