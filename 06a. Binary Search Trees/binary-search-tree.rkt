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

;; Natural BST -> String or false
;; Returns the value related to a specific key in a BST, or false if not found
; (define (look-up n bst) false) ; stub

(check-expect (look-up 5 BST0) false)
(check-expect (look-up 6 BST10) false)
(check-expect (look-up 15 BST10) false)
(check-expect (look-up 10 BST10) "why")
(check-expect (look-up 7 BST10) "ruf")
(check-expect (look-up 14 BST10) "olp")

(define (look-up k bst)
  (cond [(false? bst) false]
        [(= (node-key bst) k) (node-val bst)]
        [else (if (< k (node-key bst))
                  (look-up k (node-lt bst))
                  (look-up k (node-rt bst)))]))


;; Natural BST -> ListOfString
;; Returns the path taken while searching for a given key in a given BST, completed with "Succeed" or "Fail"
; (define (bst-pah n bst) (list "Fail")) ; stub

(check-expect (bst-pah 5 BST0) (list "Fail"))
(check-expect (bst-pah 6 BST10) (list "L" "R" "R" "L" "Fail"))
(check-expect (bst-pah 15 BST10) (list "R" "L" "L" "R" "Fail"))
(check-expect (bst-pah 10 BST10) (list "Succeed"))
(check-expect (bst-pah 7 BST10) (list "L" "R" "R" "Succeed"))
(check-expect (bst-pah 14 BST10) (list "R" "L" "L" "Succeed"))

(define (bst-pah k bst)
  (cond [(false? bst) (list "Fail")]
        [(= (node-key bst) k) (list "Succeed")]
        [else (if (< k (node-key bst))
                  (cons "L" (bst-pah k (node-lt bst)))
                  (cons "R" (bst-pah k (node-rt bst))))]))


;; BST -> Natural
;; Returns the cumulative sum of all key in the BST
; (define (sum-all-keys bst) 0) ; stub

(check-expect (sum-all-keys BST0) 0)
(check-expect (sum-all-keys BST7) 7)
(check-expect (sum-all-keys BST10) 158)

(define (sum-all-keys bst)
  (cond [(false? bst) 0]
        [else (+ (node-key bst)
                 (sum-all-keys (node-lt bst))
                 (sum-all-keys (node-rt bst)))]))


;; Natural String BST -> BST
;; Insert a new into a given BST, returns the updated BST
; (define (insert-node k v bst) bst) ; stub

(check-expect (insert-node 3 "abc" BST0) (make-node 3 "abc" false false))
(check-expect (insert-node 5 "bcd" BST7) (make-node 7 "ruf" (make-node 5 "bcd" false false) false))
(check-expect (insert-node 9 "ert" BST7) (make-node 7 "ruf" false (make-node 9 "ert" false false)))
(check-expect (insert-node 29 "www" BST42) (make-node 42 "ily"
                                                      (make-node 27 "wit"
                                                                 (make-node 14 "olp" false false)
                                                                 (make-node 29 "www" false false))
                                                      (make-node 50 "dug" false false)))

(define (insert-node k v bst)
  (cond [(false? bst) (make-node k v false false)]
        [else (if (< k (node-key bst))
                  (make-node (node-key bst)
                             (node-val bst)
                             (insert-node k v (node-lt bst))
                             (node-rt bst))
                  (make-node (node-key bst)
                             (node-val bst)
                             (node-lt bst)
                             (insert-node k v (node-rt bst))))]))


;; BST -> Integer
;; Returns the balance factor of a BST list
; (define (balance-factor? bst) 0) ; stub

(check-expect (balance-factor BST0) 0)
(check-expect (balance-factor BST1) 0)
(check-expect (balance-factor BST4) -1)
(check-expect (balance-factor BST3) -1)
(check-expect (balance-factor BST42) 1)
(check-expect (balance-factor BST10) 0)

(define (balance-factor bst)
  (cond [(false? bst) 0]
        [else
         (- (bst-height (node-lt bst))
            (bst-height (node-rt bst)))]))


;; BST -> Natural
;; Returns the height of a BST node
; (define (bst-height bst) 0) ; stub

(check-expect (bst-height BST0) 0)
(check-expect (bst-height BST1) 1)
(check-expect (bst-height BST4) 2)
(check-expect (bst-height BST3) 3)
(check-expect (bst-height BST42) 3)
(check-expect (bst-height BST10) 4)

(define (bst-height bst)
  (cond [(false? bst) 0]
        [else (+ 1 (max (bst-height (node-lt bst))
                        (bst-height (node-rt bst))))]))
