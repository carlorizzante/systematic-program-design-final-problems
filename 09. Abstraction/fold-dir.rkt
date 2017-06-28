(require 2htdp/image)

;; ===================
;; Data definitions
;; ===================

(define-struct dir (name subs images))
;; Dir is (make-dir String ListOfDir ListOfImage)
;; interp. An directory in the organizer, with a name, a list
;;         of subs (sub dirs) and a list of images.

;; ListOfDir is one of:
;;  - empty
;;  - (cons Dir ListOfDir)
;; interp. A list of directories, this represents the sub-directories of
;;         a directory.

;; ListOfImage is one of:
;;  - empty
;;  - (cons Image ListOfImage)
;; interp. a list of images, this represents the sub-images of a directory.
;; NOTE: Image is a primitive type, but ListOfImage is not.

(define I1 (square 10 "solid" "red"))
(define I2 (square 12 "solid" "green"))
(define I3 (rectangle 13 14 "solid" "blue"))
(define D4 (make-dir "D4" empty (list I1 I2)))
(define D5 (make-dir "D5" empty (list I3)))
(define D6 (make-dir "D6" (list D4 D5) empty))

#;
(define (fn-for-dir dir)
  (... (dir-name dir)
       (fn-for-lod (dir-subs dir))
       (fn-for-loi (dir-images dir))))

#;
(define (fn-for-lod lod)
  (cond [(empty? lod) ...]
        (else (... (fn-for-dir (first lod))
                   (fn-for-lod (rest lod))))))

#;
(define (fn-for-loi loi)
  (cond [(empty? loi) ...]
        [else (... (first loi)
                   (fn-for-loi (rest loi)))]))

#;
(define (fn-for-dir c1 c2 c3 base2 base3 dir)
  (local [(define (define (fn-for-dir dir)
                    (c1 (dir-name dir)
                        (fn-for-lod (dir-subs dir))
                        (fn-for-loi (dir-images dir)))))
          (define (fn-for-lod lod)
            (cond [(empty? lod) base2]
                  (else (c2 (first lod)
                            (fn-for-lod (rest lod))))))
          (define (fn-for-loi loi)
            (cond [(empty? loi) base3]
                  [else (c3 (first loi)
                            (fn-for-loi (rest loi)))]))]
    (fn-for-dir dir)))


;; ===================
;; Functions
;; ===================

;; (String Y Z -> X) (X Y -> Y) (Image Z -> Z) Y Z Dir -> X
;; Abstract fold function for dir

(check-expect (fold-dir make-dir cons cons empty empty D6) D6)
(check-expect  (local [(define (c1 n rlod rloi) (+ rlod rloi))
                       (define (c2 rdir rlod)   (+ 1 rdir))
                       (define (c3 img rloi)    (+ 1 rloi))]
                 (fold-dir c1 c2 c3 0 0 D6))
               3)

(define (fold-dir c1 c2 c3 base2 base3 dir)
  (local [(define (fn-for-dir dir)         ; Dir -> X
            (c1 (dir-name dir)
                (fn-for-lod (dir-subs dir))
                (fn-for-loi (dir-images dir))))
          (define (fn-for-lod lod)         ; (ListOf Dir) -> Y
            (cond [(empty? lod) base2]
                  (else (c2 (fn-for-dir (first lod))
                            (fn-for-lod (rest lod))))))
          (define (fn-for-loi loi)         ; (ListOf Image) -> Z
            (cond [(empty? loi) base3]
                  [else (c3 (first loi)
                            (fn-for-loi (rest loi)))]))]
    (fn-for-dir dir)))


;; Dir -> Natural
;; Returns the number of images contained in a Dir and its subs
; (define (count-images dir) 0) ; stub

(check-expect (count-images D5) 1)
(check-expect (count-images D4) 2)
(check-expect (count-images D6) 3)

(define (count-images dir)
  (local [(define (c1 name rlod rloi)
            (+ rlod rloi))
          (define (c2 rdir rlod)
            (+ rdir rlod))
          (define (c3 image rloi)
            (+ 1 rloi))
          (define base2 0)
          (define base3 0)]
    (fold-dir c1 c2 c3 base2 base3 dir)))


;; Dir String -> Boolean
;; Returns true if the given name for a dir is present in the dir tree, false otherwise
; (define (find str dir) false) ; stub

(check-expect (find "D3" D6) false)
(check-expect (find "D4" D4) true)
(check-expect (find "D5" D6) true)

(define (find str dir)
  (local [(define (c1 name rlod rloi)
            (or (string=? str name)
                rlod
                rloi))
          (define (c2 rdir rlod)
            (or rdir rlod))
          (define (c3 image rloi) false)
          (define base2 false)
          (define base3 false)]
    (fold-dir c1 c2 c3 base2 base3 dir)))
