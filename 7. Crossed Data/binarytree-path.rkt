;; ============================
;; Data definition
;; ============================

(define-struct node (k v l r))
;; BinaryTree is one of:
;; - false
;; - (make-node Natural String BinaryTree BinaryTree)
;; interp. a binary tree, each node has key, value, and l/r children
(define BT0 false)
(define BT1 (make-node 1 "a" false false))
(define BT4 (make-node 4 "d"
                       (make-node 2 "b"
                                  (make-node 1 "a" false false)
                                  (make-node 3 "c" false false))
                       (make-node 5 "e" false false)))
;; Path is one of:
;; - empty
;; (cons "L" Path)
;; (cons "R" Path)
;; interp. a sequence of left and right 'turns' down though a BinaryTree
;; - (list "L" "R" "R" means take the left child of the root, then
;; - the right child of that node, and the right child again.
;; - empty means you have arrived at the destination.
(define P1 empty)
(define P2 (list "L"))
(define P3 (list "R"))
(define P4 (list "L" "R"))


;; ============================
;; Functions
;; ============================

;; BinaryTree Path -> Boolean
;; Returns true if following the path leads to a node, false otherwise
; (define (has-path? bt p) false) ; stub

;;    p        bt  | false | (make-node Nat Str BT BT)
;; -----------------|-------|---------------------------------------
;;  empty           | false | true
;; -----------------|-------|---------------------------------------
;;  (cons "L" Path) | false | (has-path? <left child> (rest path))
;; -----------------|-------|---------------------------------------
;;  (cons "R" Path) | false | (has-path? <right child> (rest path))

(check-expect (has-path? false empty) false)
(check-expect (has-path? false (list "L")) false)
(check-expect (has-path? false (list "R")) false)
(check-expect (has-path? BT1 empty) true)
(check-expect (has-path? BT4 (list "R")) true)
(check-expect (has-path? BT4 (list "L" "L" "R")) false)


;; First solution
#;
(define (has-path? bt p)
  (cond [(and (false? bt)(empty? p))                false]
        [(and (false? bt)(string=? "L" (first p)))  false]
        [(and (false? bt)(string=? "R" (first p)))  false]
        [(and (node? bt)(empty? p))                  true]
        [(and (node? bt)(string=? "L" (first p)))   (has-path? (node-l bt) (rest p))]
        [(and (node? bt)(string=? "R" (first p)))   (has-path? (node-r bt) (rest p))]))

;; Refined solution
(define (has-path? bt p)
  (cond [(false? bt) false]
        [(empty? p) true]
        [(string=? "L" (first p)) (has-path? (node-l bt) (rest p))]
        [(string=? "R" (first p)) (has-path? (node-r bt) (rest p))]))
