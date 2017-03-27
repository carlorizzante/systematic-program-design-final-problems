(require 2htdp/image)

;
; A small set of methods to support a sorting function operating on a list of
; images of various sizes.


;; ==========================
;; Constants
;; ==========================

(define BLANK (circle 0 "solid" "white")) ; visual representation of empty, nothing to say so to speak

(define I1 (circle 7 "solid" "lightblue"))
(define I2 (circle 10 "solid" "teal"))
(define I3 (circle 15 "solid" "red"))
(define I4 (circle 20 "solid" "green"))


;; ==========================
;; Data definition
;; ==========================

;; ListOfImage is one of
;; - empty
;; - (cons Image ListOfImage)
;; Interpr. An arbitrary list of Images

(define LOI0 empty)
(define LOI1 (cons I2 empty))
(define LOI2 (cons I3 (cons I2 empty)))
(define LOI3 (cons I2 (cons I3 (cons I1 empty))))
(define LOI4 (cons I4 (cons I2 (cons I1 (cons I3 empty)))))

#;
(define (fn-for-loi loi)
  (cond
    [(empty? loi) (...)]
    [else
     (... (first loi)
          (fn-for-loi (rest loi)))]))


;; ==========================
;; Functions
;; ==========================

;; ListOfImage -> ListOfImage
;; Sorts a list of images by size (area, smaller first)
; (define (sort-images loi) empty) ; stub

(check-expect (sort-images LOI0) empty)
(check-expect (sort-images LOI1) (cons I2 empty))
(check-expect (sort-images LOI2) (cons I2 (cons I3 empty)))
(check-expect (sort-images LOI3) (cons I1 (cons I2 (cons I3 empty))))

(define (sort-images loi)
  (cond
    [(empty? loi) empty]
    [else
     (insert-image (first loi)
                   (sort-images (rest loi)))]))


;; Image ListOfImage -> ListOfImage
;; Given a list of image and an new image, return the list of image with the new image
;; positioned by its size (increasing order)
; (define (insert-image img loi) (cons img loi)) ; stub

(check-expect (insert-image I1 empty) (cons I1 empty))
(check-expect (insert-image I1 (cons I2 (cons I3 empty))) (cons I1 (cons I2 (cons I3 empty))))
(check-expect (insert-image I2 (cons I1 (cons I3 empty))) (cons I1 (cons I2 (cons I3 empty))))
(check-expect (insert-image I3 (cons I1 (cons I2 empty))) (cons I1 (cons I2 (cons I3 empty))))

(define (insert-image img loi)
  (cond
    [(empty? loi) (cons img empty)]
    [else
     (if (larger? img (first loi))
         (cons (first loi) (insert-image img (rest loi)))
         (cons img (insert-image (first loi) (rest loi))))]))


;; Image Image -> Boolean
;; Given two images, returns true if the former is larger than the latter, false otherwise
; (define (larger? img1 img2) false) ; stub

(check-expect (larger? I1 I2) false)
(check-expect (larger? I2 I1) true)
(check-expect (larger? I2 I2) false)

(define (larger? img1 img2)
  (> (* (image-width img1) (image-height img1)) (* (image-width img2) (image-height img2))))


;; ListOfImage -> Image
;; Agnostically displays an arbitrary set of images (from a list of images)
; (define (layout-images loi) empty) ; stub

(check-expect (layout-images LOI0) BLANK)
(check-expect (layout-images LOI1) (beside I2 BLANK))
(check-expect (layout-images LOI2) (beside I3 I2 BLANK))
(check-expect (layout-images LOI3) (beside I2 I3 I1 BLANK))

(define (layout-images loi)
  (cond
    [(empty? loi) BLANK]
    [else
     (beside (first loi)
          (layout-images (rest loi)))]))


;; ListOfImage -> Image
;; Given an arbitrary number of images (in a list), returns all images,
;; side by side, left to right, in increasing order of size (area)
; (define (arrange-images loi) empty) ; stub

(check-expect (arrange-images LOI0) BLANK)
(check-expect (arrange-images LOI1) (beside I2 BLANK))
(check-expect (arrange-images LOI2) (beside I2 I3 BLANK))
(check-expect (arrange-images LOI3) (beside I1 I2 I3 BLANK))

(define (arrange-images loi)
  (layout-images (sort-images loi)))


;; ==========================
;; Try out
;; ==========================

(arrange-images LOI2)
(arrange-images LOI3)
(arrange-images LOI4)
