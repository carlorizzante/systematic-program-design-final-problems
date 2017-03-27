(require 2htdp/image)

;; ============================
;; Constants
;; ============================

(define FS 10)                                ; Font size for text rendering
(define FC "black")                           ; Font color for text rendering
(define PAD (rectangle 6 7 "solid" "white"))  ; Padding between nodes for bst rendering
(define EMPTY (beside PAD (rectangle 20 7 "outline" "white") PAD))  ; Empty node for bst rendering


;; ============================
;; Data definition
;; ============================

(define-struct node (key val l r))
;; A BST (Binary Search Tree) is one of:
;;  - false
;;  - (make-node Natural String BST BST)
;; interp. false means no BST, or empty BST
;;         key is the node key
;;         val is the node val
;;         l and r are left and right subtrees
;; INVARIANT: for a given node:
;;     key is > all keys in its l(eft)  child
;;     key is < all keys in its r(ight) child
;;     the same key never appears twice in the tree


;; Single nodes with their dependencies
(define N0 false)
(define N1 (make-node 1 "Jon" false false))
(define N7 (make-node 7 "Kai" false false))
(define N4 (make-node 4 "Pia" false N7))
(define N3 (make-node 3 "Gin" N1 N4))
(define N14 (make-node 14 "Mia" false false))
(define N27 (make-node 27 "Lea" N14 false))
(define N42 (make-node 42 "Tim" N27 false))
(define N10 (make-node 10 "Pao" N3 N42))

;; Binary Search Trees starting from the nodes above
(define BST0 false)
(define BST1 N1)
(define BST4 N4)
(define BST3 N3)
(define BST42 N42)
(define BST10 N10)

#;
(define (fn-for-bst t)
  (cond [(false? t) (...)]
        [else
         (... (node-key t)                  ; Natural
              (node-val t)                  ; String
              (fn-for-bst (node-l t))       ; BST
              (fn-for-bst (node-r t)))]))   ; BST

;; Template rules used:
;;  - one of: 2 cases
;;  - atomic-distinct: false
;;  - compound: (make-node Natural String BST BST)
;;  - self reference: (node-l t) has type BST
;;  - self reference: (node-r t) has type BST


;; ============================
;; Functions
;; ============================

;; BST -> Integer
;; Returns the balance factor of a BST list
; (define (balance-factor? BST) 0) ; stub

(check-expect (balance-factor N0) 0)
(check-expect (balance-factor N1) 0)
(check-expect (balance-factor N4) -1)
(check-expect (balance-factor N3) -1)
(check-expect (balance-factor N42) 2)
(check-expect (balance-factor N10) 0)

(define (balance-factor t)
  (cond [(false? t) 0]
        [else
         (- (bst-height (node-l t)) (bst-height (node-r t)))]))


;; BST -> Natural
;; Returns the height of a BST node
; (define (bst-height t) 0) ; stub

(check-expect (bst-height N0) 0)
(check-expect (bst-height N1) 1)
(check-expect (bst-height N4) 2)
(check-expect (bst-height N3) 3)
(check-expect (bst-height N42) 3)
(check-expect (bst-height N10) 4)

(define (bst-height t)
  (cond [(false? t) 0]
        [else (+ 1 (max (bst-height (node-l t))
                        (bst-height (node-r t))))]))


;; Natural String BST -> BST
;; Insert a new node into a BST
; (define (insert i s t) t) ; stub

(check-expect (insert 10 "Jon" false) (make-node 10 "Jon" false false))
(check-expect (insert 9 "Tim" (make-node 10 "Jon" false false))
              (make-node 10 "Jon" (make-node 9 "Tim" false false) false))
(check-expect (insert 12 "Mia" (make-node 10 "Pao" (make-node 9 "Lea" false false) false))
              (make-node 10 "Pao" (make-node 9 "Lea" false false) (make-node 12 "Mia" false false)))

(define (insert i s t)
  (cond [(false? t) (make-node i s false false)]
        [else
         (if (< i (node-key t))
             (make-node (node-key t) (node-val t) (insert i s (node-l t)) (node-r t))
             (make-node (node-key t) (node-val t) (node-l t) (insert i s (node-r t))))]))


;; Natural BST -> String or false
;; Given a key k to loop up within a BST, returns the corrispondent value if found, otherwise false
; (define (lookup k t) false) ; stub

(check-expect (lookup 10 N0)  false)   ; fail for empty bst
(check-expect (lookup 12 N10) false)  ; fail for right branch
(check-expect (lookup 5  N42) false)   ; fail for left branch
(check-expect (lookup 7  N10) "Kai")   ; success for left/right branch
(check-expect (lookup 14 N10) "Mia")  ; success for right/left branch

(define (lookup k t)
  (cond [(false? t) false]
        [(equal? k (node-key t)) (node-val t)]
        [else
         (if (< k (node-key t))
             (lookup k (node-l t))
             (lookup k (node-r t)))]))


;; Natural BST -> String
;; Returns the path followed during the lookup of a key within a BST
; (define (path k t) "false") ; stub

(check-expect (path 10  N0) (list "false"))
(check-expect (path 12 N10) (list "R" "L" "L" "L" "false"))
(check-expect (path 5  N10) (list "L" "R" "R" "L" "false"))
(check-expect (path 7  N10) (list "L" "R" "R" "found"))
(check-expect (path 14 N10) (list "R" "L" "L" "found"))

(define (path k t)
  (cond [(false? t) (list "false")]
        [(equal? k (node-key t)) (list "found")]
        [else
         (if (< k (node-key t))
             (cons "L" (path k (node-l t)))
             (cons "R" (path k (node-r t))))]))


;; Node -> Image
;; Renders a single node visually, with its key and value as string
;; It does not render sub-nodes or sub-bst for the node
; (define (render-node n) empty-image) ; stub

(check-expect (render-node N0) empty-image)
(check-expect (render-node N1) (beside PAD (text (string-append (number->string (node-key N1)) ":" (node-val N1)) FS FC) PAD))
(check-expect (render-node N7) (beside PAD (text (string-append (number->string (node-key N7)) ":" (node-val N7)) FS FC) PAD))
(check-expect (render-node N10) (beside PAD (text (string-append (number->string (node-key N10)) ":" (node-val N10)) FS FC) PAD))

(define (render-node n)
  (cond [(false? n) empty-image]
        [else
         (beside
          PAD
          (text (string-append (number->string (node-key n)) ":" (node-val n)) FS FC)
          PAD)]))


;; BST -> Image
;; Given a BST, renders its visual representation
; (define (render-bst t) empty-image) ; stub

(check-expect (render-bst N0) EMPTY)
(check-expect (render-bst N1) (above PAD
                                     (render-node N1)
                                     (beside EMPTY EMPTY)))
(check-expect (render-bst N3) (above PAD
                                     (render-node N3)
                                     (beside
                                      (above PAD
                                             (render-node N1)
                                             (beside EMPTY EMPTY))
                                      (above PAD
                                             (render-node N4)
                                             (beside
                                              EMPTY
                                              (above PAD
                                                     (render-node N7)
                                                     (beside EMPTY EMPTY)))))))


(define (render-bst t)
  (cond [(false? t) EMPTY]
        [else
         (above PAD
          (render-node t)
          (beside
           (render-bst (node-l t))
           (render-bst (node-r t))))]))


;; ============================
;; Try out
;; ============================

;
; Note that due to the recursive nature of insert, the insertion below go backward:
; TEST1 starts with 8:"a", TEST2 with 6:"a", and so on. The entry point of the following
; BSTs is the last node in a consecutive series of insertions.

(define TEST1
  (insert 4 "Jon"
          (insert 5 "Gin"
                  (insert 6 "Tom"
                          (insert 7 "Rue"
                                  (insert 8 "Rie" false))))))
(define TEST2
  (insert 4 "Jon"
          (insert 5 "Gin"
                  (insert 8 "Rie"
                          (insert 7 "Rue"
                                  (insert 6 "Tom" false))))))
(define TEST3
  (insert 11 "Lea"
          (insert 7 "Rue"
                  (insert 9 "Jan"
                          (insert 12 "Kai"
                                  (insert 3 "Dea" false))))))
(define TEST4
  (insert 11 "Lea"
          (insert 7 "Rue"
                  (insert 9 "Jan"
                          (insert 12 "Kai"
                                  (insert 10 "Pao"
                                          (insert 17 "Pia"
                                                  (insert 8 "Tim"
                                                          (insert 14 "Jon"
                                                                  (insert 27 "Gin"
                                                                          (insert 15 "Rie"
                                                                                  (insert 11 "Jan" false))))))))))))

(balance-factor TEST1) ; 4
(balance-factor TEST2) ; 0
(balance-factor TEST3) ; -3
(balance-factor TEST4) ; -1

(rectangle 400 1 "solid" "teal")
(render-bst BST10)
(rectangle 400 1 "solid" "teal")
(render-bst TEST4)
(rectangle 400 1 "solid" "teal")
