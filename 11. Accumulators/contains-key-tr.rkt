;; ======================
;; Problem
;; ======================
; Starting with the following data definition for a binary tree (not a binary search tree)
; design a tail-recursive function called contains? that consumes a key and a binary tree
; and produces true if the tree contains the key.


;; ======================
;; Data definition
;; ======================

(define-struct node (k v l r))
;; BT is one of:
;;  - false
;;  - (make-node Integer String BT BT)
;; Interp. A binary tree, each node has a key, value and 2 children
(define BT1 false)
(define BT2 (make-node 1 "a"
                       (make-node 6 "f"
                                  (make-node 4 "d" false false)
                                  false)
                       (make-node 7 "g" false false)))

#;
(define (fn-for-node node)
  (cond [(false? node) ...]
        [(else (... (node-k node) ; Natural
                    (node-v node) ; String
                    (fn-for-node (node-l node))
                    (fn-for-node (node-r node))))]))


;; ======================
;; Functions
;; ======================

;; String BT -> Boolean
;; Returns true if the given key is contained in the BST
; (define (contains? key bst) false) ; stub

(check-expect (contains? 1 BT1) false)
(check-expect (contains? 1 BT2) true)
(check-expect (contains? 3 BT2) false)
(check-expect (contains? 7 BT2) true)

(define (contains? key node)
  (cond [(false? node) false]
        [else (or (= key (node-k node))
                  (contains? key (node-l node))
                  (contains? key (node-r node)))]))

;; Tail recursive version - Not sure about this one

(check-expect (contains?tr 1 BT1) false)
(check-expect (contains?tr 1 BT2) true)
(check-expect (contains?tr 3 BT2) false)
(check-expect (contains?tr 7 BT2) true)

(define (contains?tr key node)
  (cond [(false? node) false]
        [(= key (node-k node)) true]
        [else (or (contains? key (node-l node))
                  (contains? key (node-r node)))]))
