(require 2htdp/image)

;; ======================
;; Data definitions
;; ======================

(define-struct dir (name subs images))
;; Dir is (make-dir String ListOfDir ListOfImage)
;; interp. An directory in the organizer, with a name, a list
;;         of sub-dirs and a list of images.

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
(define D0 (make-dir "D0" empty empty))


;; ======================
;; Functions
;; ======================

;; (String Integer Y -> X) (X Y -> Y) Y Dir -> X
;; Abstract function for Dir - and (listof Dir) but consumes Dir
(check-expect (fold-dir make-dir cons cons empty empty D6) D6)
(check-expect (local [(define (c1 name rlod rloi) (+ rlod rloi))
                      (define (c2 rdir rlod)      (+ 1 rdir))
                      (define (c3 img rloi)       (+ 1 rloi))]
                (fold-dir c1 c2 c3 0 0 D6))
              3)

(define (fold-dir c1 c2 c3 base1 base2 dir)
  (local [(define (fn-for-dir dir)      ; Dir -> X
            (c1 (dir-name dir)  ; String
                (fn-for-lod (dir-subs dir))     ; (listof Dir)
                (fn-for-loi (dir-images dir))   ; (listof Image)
                ))

          (define (fn-for-lod lod)      ; (listof Dir) -> Y
            (cond [(empty? lod) base1]
                  [else
                   (c2 (fn-for-dir (first lod)) ; Mutual Natural Recursion
                       (fn-for-lod (rest lod)))]))

          (define (fn-for-loi loi)      ; (listof Dir) -> Z
            (cond [(empty? loi) base2]
                  [else
                   (c3 (first loi) ; NOT Mutual Natural Recursion
                       (fn-for-loi (rest loi)))]))]
    (fn-for-dir dir)))


;; Dit -> Natural
;; Returns the number of images contained into a Dir and its subs
; (define (count-images dir) 0) ; stub

(check-expect (count-images D0) 0)
(check-expect (count-images D4) 2)
(check-expect (count-images D5) 1)
(check-expect (count-images D6) 3)

(define (count-images dir)
  (local [(define (c1 name rlod rloi) (+ rlod rloi))
          (define (c2 rdir rlod)      (+ rdir rlod))
          (define (c3 img rloi)       (+ 1 rloi))]
    (fold-dir c1 c2 c3 0 0 dir)))


;; String Dir -> Boolean
;; Returns true if there is a Dir with the given name in the tree, otherwise false
; (define (contains? s dir) false) ; stub

(check-expect (contains? "D7" D6) false)
(check-expect (contains? "D5" D6) true)

(define (contains? name dir)
   (local [(define (c1 n rdirs rimgs)
            (or (string=? name n)
                rdirs
                rimgs))
          (define (c2 rdir rdirs)
            (or rdir rdirs))
          (define (c3 img rimgs)
            false)]
    (fold-dir c1 c2 c3 false false dir)))
