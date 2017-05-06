(require 2htdp/image)

;
; PROBLEM:
;
; In this problem imagine you have a bunch of pictures that you would like to
; store as data and present in different ways. We'll do a simple version of that
; here, and set the stage for a more elaborate version later.
;
; (A) Design a data definition to represent an arbitrary number of images.
;
; (B) Design a function called arrange-images that consumes an arbitrary number
;     of images and lays them out left-to-right in increasing order of size.
;


;; ==========================
;; Data Definition
;; ==========================

;; ListOfImage is one of:
;; - empty
;; (cons Image ListOfImage)
;; A list of images

(define I1 (square 12 "solid" "red"))
(define I2 (rectangle 14 20 "solid" "teal"))
(define I3 (square 8 "solid" "blue"))

(define L0 empty)
(define L1 (cons I1 empty))
(define L2 (cons I2 L1))
(define L3 (cons I3 L2))

#;
(define (fn-for-loi loi)
  (cond [(empty? loi) (...)]
        [else (... (first loi)
                   (fn-for-loi (rest loi)))]))

;; Template rules used:
;; - Atomic Distinct       empty
;; - Compound Data         (cons Image ListOfImage)
;; - Self-Reference        ListOfImage


;; ==========================
;; Function
;; ==========================

;; ListOfImage -> Image
;; Arranges all images in a list of image in increasing order of size
; (define (graph loi) empty-image) ; stub

(check-expect (graph L0) empty-image)
(check-expect (graph L3) (beside/align "bottom" I3 I1 I2))

(define (graph loi)
  (cond [(empty? loi) empty-image]
        [else (render-images (sort-images loi))]))


;; ListOfImages -> Image
;; Renders images in a list side by side
; (define (render-images loi) empty-image) ; stub

(check-expect (render-images L0) empty-image)
(check-expect (render-images L3) (beside/align "bottom" I3 I2 I1))

(define (render-images loi)
  (cond [(empty? loi) empty-image]
        [else (beside/align "bottom"
                            (first loi)
                            (render-images (rest loi)))]))


;; Image Image -> Boolean
;; Given two images i1 and i2, returns true if i1 >= i2, false otherwise
; (define (greater? i1 i2) false) ; stub

(check-expect (greater? I1 empty) true)
(check-expect (greater? I1 empty-image) true)
(check-expect (greater? I1 I2) false)
(check-expect (greater? I2 I3) true)
(check-expect (greater? I1 I3) true)

(define (greater? i1 i2)
  (cond [(empty? i2) true]
        [else (> (* (image-width i1) (image-height i1))
                 (* (image-width i2) (image-height i2)))]))


;; ListOfImage -> ListOfImage
;; Sort a given list of images by size
; (define (sort-images loi) loi) ; stub

(check-expect (sort-images empty) empty)
(check-expect (sort-images L3) (cons I3 (cons I1 (cons I2 empty))))

(define (sort-images loi)
  (cond [(empty? loi) empty]
        [else (insert-image (first loi) (sort-images (rest loi)))]))


;; Image ListOfImage -> ListOfImage
;; Insert a new image into a ListOfImage in increasing order
; (define (insert-image i loi) loi) ; stub

(check-expect (insert-image I1 empty) (cons I1 empty))
(check-expect (insert-image I2 L1) (cons I1 (cons I2 empty)))
(check-expect (insert-image I3 (cons I1 (cons I2 empty))) (cons I3 (cons I1 (cons I2 empty))))
(check-expect (insert-image I2 (cons I3 (cons I1 empty))) (cons I3 (cons I1 (cons I2 empty))))
(check-expect (insert-image I1 (cons I3 (cons I2 empty))) (cons I3 (cons I1 (cons I2 empty))))

(define (insert-image i loi)
  (cond [(empty? loi) (cons i empty)]
        [else (if (greater? i (first loi))
                  (cons (first loi) (insert-image i (rest loi)))
                  (cons i loi))]))


;; ==========================
;; Try out
;; ==========================

(graph L3)
