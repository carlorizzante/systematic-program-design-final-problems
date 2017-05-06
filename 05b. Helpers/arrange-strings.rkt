(require 2htdp/image)

;; ==========================
;; Constants
;; ==========================

(define SIZE 14)
(define COLOR "teal")


;; ==========================
;; Data Definition
;; ==========================

;; ListOfString is one of:
;; - empty
;; - (cons String ListOfString)
;; A list of strings

(define L0 empty)
(define L1 (cons "abc" empty))
(define L2 (cons "bde" L1))
(define L3 (cons "aac" L2))

#;
(define (fn-for-los los)
  (cond [(empty? los) (...)]
        [else (... (first los)
                   (fn-for-los (rest los)))]))

;; Template rules used;
;; - Atomic Distinct             empty
;; - Compound Data               (cons String ListOfString)
;; - Self-Reference              ListOfString


;; ==========================
;; Functions
;; ==========================

;; ListOfString -> Image
;; Renders all strings in the list vertically, in alphabetical order
; (define (arrange-strings los) empty-image) ; stub

(check-expect (arrange-strings empty) empty-image)
(check-expect (arrange-strings L3) (above/align "left"
                                                (text "aac" SIZE COLOR)
                                                (text "abc" SIZE COLOR)
                                                (text "bde" SIZE COLOR)))

(define (arrange-strings los)
  (render-list (sort-list los)))


;; ListOfString -> ListOfString
;; Sort a list of string in alphabetical order
; (define (sort-list los) los) ; stub

(check-expect (sort-list empty) empty)
(check-expect (sort-list (cons "bde" (cons "abc" (cons "bad" empty))))
              (cons "abc" (cons "bad" (cons "bde" empty))))

(define (sort-list los)
  (cond [(empty? los) empty]
        [else (insert-string (first los) (sort-list (rest los)))]))


;; String ListOfString -> ListOfString
;; Inserts a string into a list in alphabetical order
;; Assumes list is already alphabetically ordered
; (define (insert-string s los) los) ; stub

(check-expect (insert-string "abc" empty) (cons "abc" empty))
(check-expect (insert-string "bad" (cons "abc" empty)) (cons "abc" (cons "bad" empty)))
(check-expect (insert-string "bad" (cons "abc" (cons "dde" empty)))
              (cons "abc" (cons "bad" (cons "dde" empty))))
(check-expect (insert-string "dde" (cons "abc" (cons "bad" empty)))
              (cons "abc" (cons "bad" (cons "dde" empty))))

(define (insert-string s los)
  (cond [(empty? los) (cons s empty)]
        [else (if (string<? s (first los))
                  (cons s los)
                  (cons (first los) (insert-string s (rest los))))]))


;; ListOfString -> Image
;; Renders a list of string into an image (all string aligned vertically)
; (define (render-list los) empty-image) ; stub

(check-expect (render-list L0) empty-image)
(check-expect (render-list L1) (text "abc" SIZE COLOR))
(check-expect (render-list L3) (above/align "left"
                                            (text "aac" SIZE COLOR)
                                            (text "bde" SIZE COLOR)
                                            (text "abc" SIZE COLOR)))

(define (render-list los)
  (cond [(empty? los) empty-image]
        [else (above/align "left"
                           (text (first los) SIZE COLOR)
                           (render-list (rest los)))]))


;; ==========================
;; Try out
;; ==========================

(arrange-strings L3)
