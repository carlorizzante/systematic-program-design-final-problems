(require 2htdp/image)

;; ========================
;; Constants
;; ========================

(define SIZE 14)
(define COLOR "white")

(define WIDTH 50)
(define HEIGHT 24)
(define BCOLOR "teal")

(define PAD (rectangle 6 6 "solid" "white"))
(define BLANK (rectangle WIDTH 0 "solid" "white"))


;; ========================
;; Data Definitions
;; ========================

(define-struct node (key val lt rt))
;; BST (Binary Search Tree) is one of:
;; - false
;; - (make-node Natural String BST BST)
;; A node in a Binary Search Tree data structure, such that:
;; - key              Natural       id of the current node
;; - val              String        data stored in the current node
;; - lt               BST           left side of the BST      empty or BST
;; - rt               BST           right side of the BST     empty or BST
;; INVARIANT - for a given node:
;; - the node's key is > of all its left children  - left trees  - lt
;; - the node's key is < of all its right children - right trees - rt
;; - keys are uniques across an uniform Binary Search Tree

;; Base case
(define BST0 false)

;; Left branch
(define BST7 (make-node 7 "ruf" false false))
(define BST4 (make-node 4 "dcj" false BST7))
(define BST1 (make-node 1 "abc" false false))
(define BST3 (make-node 3 "ilk" BST1 BST4))

;; Right branch
(define BST14 (make-node 14 "olp" false false))
(define BST27 (make-node 27 "wit" BST14 false))
(define BST50 (make-node 50 "dug" false false))
(define BST42 (make-node 42 "ily" BST27 BST50))

;; Initial node
(define BST10 (make-node 10 "why" BST3 BST42))

#;
(define (fn-for-bst bst)
  (cond [(false? bst) (...)]
        [else (... (node-key bst)                   ; Natural
                   (node-val bst)                   ; String
                   (fn-for-bst (node-lt bst))
                   (fn-for-bst (node-rt bst)))]))

;; Template rules:
;; - One of:
;; -- Atomic Distinct                 false
;; -- Compound Data                   (make-node Natural String BST BST)
;; - Self Reference                   (node-lt) is BST
;; - Self Reference                   (node-rt) is BST


;; ========================
;; Functions
;; ========================

;; BST -> Image
;; Given a BST, renders a visual representation of it
; (define (render-bst bst) empty-image) ; stub

(check-expect (render-bst BST0) BLANK)
(check-expect (render-bst BST3) (above
                                 (render-node BST3) PAD
                                 (beside/align "top"
                                               (above
                                                (render-node BST1) PAD
                                                (beside/align "top"
                                                              BLANK PAD BLANK))
                                               PAD
                                               (above
                                                (render-node BST4) PAD
                                                (beside/align "top"
                                                              BLANK PAD (above
                                                                         (render-node BST7) PAD
                                                                         (beside/align "top"
                                                                                       BLANK PAD BLANK)))))))

(define (render-bst bst)
  (cond [(false? bst) BLANK]
        [else (above
               (render-node bst) PAD
               (beside/align "top"
                             (render-bst (node-lt bst))
                             PAD
                             (render-bst (node-rt bst))))]))


;; BST -> Image
;; Render a single node graphically
; (define (render-node bst) empty-image) ; stub

(check-expect (render-node BST0) BLANK)
(check-expect (render-node BST7) (overlay
                                  (text (node-label BST7) SIZE COLOR)
                                  (rectangle WIDTH HEIGHT "solid" BCOLOR)))

(define (render-node bst)
  (cond [(false? bst) BLANK]
        [else (overlay
               (text (node-label bst) SIZE COLOR)
               (rectangle WIDTH HEIGHT "solid" BCOLOR))]))


;; BST -> String
;; Given a node, returns the text for its label - used by render-node
; (define (node-label bst) "") ; stub

(check-expect (node-label BST0) "")
(check-expect (node-label BST10) (string-append (number->string (node-key BST10)) ":" (node-val BST10)))
(check-expect (node-label BST7) (string-append (number->string (node-key BST7)) ":" (node-val BST7)))

(define (node-label bst)
  (cond [(false? bst) ""]
        [else (string-append (number->string (node-key bst)) ":" (node-val bst))]))


;; BST -> Image
;; Render a BST graphically, from left to right

(define (render-bst2 bst)
  (cond [(false? bst) BLANK]
        [else (beside
               (render-node bst) PAD
               (above/align "left"
                             (render-bst2 (node-lt bst))
                             PAD
                             (render-bst2 (node-rt bst))))]))


;; ========================
;; Try out
;; ========================

(render-bst BST10)

; (render-bst2 BST10)
