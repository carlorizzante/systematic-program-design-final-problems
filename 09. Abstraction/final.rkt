(require 2htdp/image)

;; ==================================
;; Fold function for (Listof Image)
;; ==================================

;; (X Y -> Y) Y (Listof X) -> Y
;; Fold function for Image
(define (arrange-all fn base loi) ; -> Y
  (cond [(empty? loi) base]
        [else
         (fn (first loi)
             (arrange-all fn base (rest loi)))]))

(check-expect (arrange-all above empty-image (list (square 10 "solid" "pink") (triangle 20 "solid" "red")))
              (above (square 10 "solid" "pink") (triangle 20 "solid" "red")))

(check-expect (arrange-all cons empty (list "a" "b" "c"))
              (cons "a" (cons "b" (cons "c" empty))))

(check-expect (arrange-all + 0 (list 1 2 3 4 5)) 15)


;; ================
;; Functions
;; ================

;; (listof Image) -> Image
;; combines a list of images into a single image, each image above the next one
(check-expect (above-all empty) empty-image)
(check-expect (above-all (list (rectangle 20 40 "solid" "red") (star 30 "solid" "yellow")))
              (above (rectangle 20 40 "solid" "red") (star 30 "solid" "yellow")))
(check-expect (above-all (list (circle 30 "outline" "black") (circle 50 "outline" "black") (circle 70 "outline" "black")))
              (above (circle 30 "outline" "black") (circle 50 "outline" "black") (circle 70 "outline" "black")))

;(define (above-all loi) empty-image)  ;stub
#;
(define (above-all loi)
  (cond [(empty? loi) empty-image]
        [else
         (above (first loi)
                (above-all (rest loi)))]))

(define (above-all loi)
  (arrange-all above empty-image loi))


;; (listof Image) -> Image
;; combines a list of images into a single image, each image beside the next one
(check-expect (beside-all empty) (rectangle 0 0 "solid" "white"))
(check-expect (beside-all (list (rectangle 50 40 "solid" "blue") (triangle 30 "solid" "pink")))
              (beside (rectangle 50 40 "solid" "blue") (triangle 30 "solid" "pink")))
(check-expect (beside-all (list (circle 10 "outline" "red") (circle 20 "outline" "blue") (circle 10 "outline" "yellow")))
              (beside (circle 10 "outline" "red") (circle 20 "outline" "blue") (circle 10 "outline" "yellow")))

;(define (beside-all loi) empty-image)  ;stub
#;
(define (beside-all loi)
  (cond [(empty? loi) (rectangle 0 0 "solid" "white")]
        [else
         (beside (first loi)
                 (beside-all (rest loi)))]))

(define (beside-all loi)
  (arrange-all beside empty-image loi))


;; =============
;; Function 1
;; =============

;; (listof String) -> (listof Natural)
;; produces a list of the lengths of each string in los
; (define (lengths lst) empty) ; stub

(check-expect (lengths empty) empty)
(check-expect (lengths (list "apple" "banana" "pear")) (list 5 6 4))

(define (lengths lst)
  (map string-length lst))


;; =============
;; Function 2
;; =============

;; (listof Natural) -> (listof Natural)
;; produces a list of just the odd elements of lon
; (define (odd-only lon) empty) ; stub

(check-expect (odd-only empty) empty)
(check-expect (odd-only (list 1 2 3 4 5)) (list 1 3 5))

(define (odd-only lon)
  (filter odd? lon))


;; =============
;; Function 3
;; =============

;; (listof Natural -> Boolean
;; produce true if all elements of the list are odd
; (define (all-odd? lon) empty) ; stub

(check-expect (all-odd? empty) true)
(check-expect (all-odd? (list 1 2 3 4 5)) false)
(check-expect (all-odd? (list 5 5 79 13)) true)

(define (all-odd? lon)
  (andmap odd? lon))


;; =============
;; Function 4
;; =============

;; (listof Natural) -> (listof Natural)
;; subtracts n from each element of the list
; (define (minus-n lon n) empty) ; stub

(check-expect (minus-n empty 5) empty)
(check-expect (minus-n (list 4 5 6) 1) (list 3 4 5))
(check-expect (minus-n (list 10 5 7) 4) (list 6 1 3))

(define (minus-n lon n)
  (local [(define (minus-n n_0) (- n_0 n))]
    (map minus-n lon)))


;; ==================================
;; Final problem
;; ==================================

(define-struct region (name type subregions))
;; Region is (make-region String Type (listof Region))
;; interp. a geographical region

;; Type is one of:
;; - "Continent"
;; - "Country"
;; - "Province"
;; - "State"
;; - "City"
;; interp. categories of geographical regions

(define VANCOUVER (make-region "Vancouver" "City" empty))
(define VICTORIA (make-region "Victoria" "City" empty))
(define BC (make-region "British Columbia" "Province" (list VANCOUVER VICTORIA)))
(define CALGARY (make-region "Calgary" "City" empty))
(define EDMONTON (make-region "Edmonton" "City" empty))
(define ALBERTA (make-region "Alberta" "Province" (list CALGARY EDMONTON)))
(define CANADA (make-region "Canada" "Country" (list BC ALBERTA)))

#;
(define (fn-for-region r)
  (local [(define (fn-for-region r)
            (... (region-name r)
                 (fn-for-type (region-type r))
                 (fn-for-lor (region-subregions r))))

          (define (fn-for-type t)
            (cond [(string=? t "Continent") (...)]
                  [(string=? t "Country") (...)]
                  [(string=? t "Province") (...)]
                  [(string=? t "State") (...)]
                  [(string=? t "City") (...)]))

          (define (fn-for-lor lor)
            (cond [(empty? lor) (...)]
                  [else
                   (... (fn-for-region (first lor))
                        (fn-for-lor (rest lor)))]))]
    (fn-for-region r)))


;; ============================
;; Fold function for Region
;; ============================

;; (String X Z -> Y) (Y Z -> Z) X X X X X Z Region -> Y
;; (String X (Listof R) -> R) (R (Listof R) -> (Listof R)) X X X X X (Listof R) Region -> R
;; Fold function for Region
(define (fold-region C1 C2 B1 B2 B3 B4 B5 Z r)
  (local [(define (fn-for-region r) ; -> R
            (C1 (region-name r)
                (fn-for-type (region-type r))
                (fn-for-lor (region-subregions r))))

          (define (fn-for-type t)   ; -> X
            (cond [(string=? t "Continent") B1]
                  [(string=? t "Country") B2]
                  [(string=? t "Province") B3]
                  [(string=? t "State") B4]
                  [(string=? t "City") B5]))

          (define (fn-for-lor lor)  ; -> (Listof R)
            (cond [(empty? lor) Z]
                  [else
                   (C2 (fn-for-region (first lor))
                       (fn-for-lor (rest lor)))]))]
    (fn-for-region r)))

(check-expect (fold-region make-region cons "Continent" "Country" "Province" "State" "City" empty CANADA) CANADA)


;; Region -> (Listof String)
;; Returns a list of all the region names in the tree
; (define (all-regions r) empty) ; stub

(check-expect (all-regions CANADA) (list "Canada" "British Columbia" "Vancouver" "Victoria" "Alberta" "Calgary" "Edmonton"))

(define (all-regions r)
  (local [(define (c1 n t r) (cons n r))]
    (fold-region c1 append "" "" "" "" "" empty r)))
