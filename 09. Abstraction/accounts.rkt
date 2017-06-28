;; =========================
;; Data definitions
;; =========================

(define-struct node (id name bal l r))
;; Accounts is one of:
;;  - false
;;  - (make-node Natural String Integer Accounts Accounts)
;; interp. a collection of bank accounts
;;   false represents an empty collection of accounts.
;;   (make-node id name bal l r) is a non-empty collection of accounts such that:
;;    - id is an account identification number (and BST key)
;;    - name is the account holder's name
;;    - bal is the account balance in dollars CAD
;;    - l and r are further collections of accounts
;; INVARIANT: for a given node:
;;     id is > all ids in its l(eft)  child
;;     id is < all ids in its r(ight) child
;;     the same id never appears twice in the collection

(define ACT0 false)
(define ACT1 (make-node 1 "Mr. Rogers" 22 false false))
(define ACT4 (make-node 4 "Mrs. Doubtfire"  -3
                        false
                        (make-node 7 "Mr. Natural" 13 false false)))
(define ACT3 (make-node 3 "Miss Marple" 600 ACT1 ACT4))
(define ACT42
  (make-node 42 "Mr. Mom" -79
             (make-node 27 "Mr. Selatcia" 40
                        (make-node 14 "Mr. Impossible" -9 false false)
                        false)
             (make-node 50 "Miss 604" 16 false false)))
(define ACT10 (make-node 10 "Dr. No" 84 ACT3 ACT42))

#;
(define (fn-for-act act)
  (cond [(false? act) (...)]
        [else
         (... (node-id act)
              (node-name act)
              (node-bal act)
              (fn-for-act (node-l act))
              (fn-for-act (node-r act)))]))


;; =========================
;; Functions, part 1
;; =========================

;; (Accounts -> Boolean) Accounts -> Accounts
;; Removes accounts that satisfy the predicate pred

(check-expect (local [(define (yes? act) true)]
                (remove-acts yes? false))
              false)
(check-expect (local [(define (yes? act) true)]
                (remove-acts yes? ACT42))
              false)
(check-expect (local [(define (no? act) false)]
                (remove-acts no? ACT42))
              ACT42)
(check-expect (local [(define (debtor? act)
                        (negative? (node-bal act)))]
                (remove-acts debtor? ACT4))
              (make-node 7 "Mr. Natural" 13 false false))


(define (remove-acts pred act)
  (cond [(false? act) false]
        [else
         (if (pred act)
             (join (remove-acts pred (node-l act))
                   (remove-acts pred (node-r act)))
             (make-node (node-id act)
                        (node-name act)
                        (node-bal act)
                        (remove-acts pred (node-l act))
                        (remove-acts pred (node-r act))))]))


;; Accounts -> Accounts
;; remove all accounts with a negative balance
(check-expect (remove-debtors (make-node 1 "Mr. Rogers" 22 false false))
              (make-node 1 "Mr. Rogers" 22 false false))

(check-expect (remove-debtors (make-node 14 "Mr. Impossible" -9 false false))
              false)

(check-expect (remove-debtors
               (make-node 27 "Mr. Selatcia" 40
                          (make-node 14 "Mr. Impossible" -9 false false)
                          false))
              (make-node 27 "Mr. Selatcia" 40 false false))

(check-expect (remove-debtors
               (make-node 4 "Mrs. Doubtfire" -3
                          false
                          (make-node 7 "Mr. Natural" 13 false false)))
              (make-node 7 "Mr. Natural" 13 false false))

#;
(define (remove-debtors act)
  (cond [(false? act) false]
        [else
         (if (negative? (node-bal act))
             (join (remove-debtors (node-l act))
                   (remove-debtors (node-r act)))
             (make-node (node-id act)
                        (node-name act)
                        (node-bal act)
                        (remove-debtors (node-l act))
                        (remove-debtors (node-r act))))]))

(define (remove-debtors act)
  (local [(define (debtor? act) (negative? (node-bal act)))]
    (remove-acts debtor? act)))


;; Accounts -> Accounts
;; Remove all professors' accounts.
(check-expect (remove-profs (make-node 27 "Mr. Smith" 100000 false false))
              (make-node 27 "Mr. Smith" 100000 false false))
(check-expect (remove-profs (make-node 44 "Prof. Longhair" 2 false false)) false)
(check-expect (remove-profs (make-node 67 "Mrs. Dash" 3000
                                       (make-node 9 "Prof. Booty" -60 false false)
                                       false))
              (make-node 67 "Mrs. Dash" 3000 false false))
(check-expect (remove-profs
               (make-node 97 "Prof. X" 7
                          false
                          (make-node 112 "Ms. Magazine" 467 false false)))
              (make-node 112 "Ms. Magazine" 467 false false))

#;
(define (remove-profs act)
  (cond [(false? act) false]
        [else
         (if (has-prefix? "Prof." (node-name act))
             (join (remove-profs (node-l act))
                   (remove-profs (node-r act)))
             (make-node (node-id act)
                        (node-name act)
                        (node-bal act)
                        (remove-profs (node-l act))
                        (remove-profs (node-r act))))]))

(define (remove-profs act)
  (local [(define (prof? act) (has-prefix? "Prof." (node-name act)))]
    (remove-acts prof? act)))



;; String String -> Boolean
;; Determine whether pre is a prefix of str.
(check-expect (has-prefix? "" "rock") true)
(check-expect (has-prefix? "rock" "rockabilly") true)
(check-expect (has-prefix? "blues" "rhythm and blues") false)

(define (has-prefix? pre str)
  (string=? pre (substring str 0 (string-length pre))))

;; Accounts Accounts -> Accounts
;; Combine two Accounts's into one
;; ASSUMPTION: all ids in act1 are less than the ids in act2
(check-expect (join ACT42 false) ACT42)
(check-expect (join false ACT42) ACT42)
(check-expect (join ACT1 ACT4)
              (make-node 4 "Mrs. Doubtfire" -3
                         ACT1
                         (make-node 7 "Mr. Natural" 13 false false)))
(check-expect (join ACT3 ACT42)
              (make-node 42 "Mr. Mom" -79
                         (make-node 27 "Mr. Selatcia" 40
                                    (make-node 14 "Mr. Impossible" -9
                                               ACT3
                                               false)
                                    false)
                         (make-node 50 "Miss 604" 16 false false)))

(define (join act1 act2)
  (cond [(false? act2) act1]
        [else
         (make-node (node-id act2)
                    (node-name act2)
                    (node-bal act2)
                    (join act1 (node-l act2))
                    (node-r act2))]))


;; Accounts -> Accounts
;; Removes from the list all accounts which name has an odd number of characters
; (define (remove-odd-characters act) empty) ; stub

(check-expect (remove-odd-characters (make-node 7 "Miss Daisy" 12 false false))
              (make-node 7 "Miss Daisy" 12 false false))
(check-expect (remove-odd-characters (make-node 7 "Mrs. Robinson" 12 false false))
              false)

(define (remove-odd-characters act)
  (local [(define (odd-name? act) (odd? (string-length (node-name act))))]
    (remove-acts odd-name? act)))


;; =========================
;; Fold function for Accounts
;; =========================

;; (Natural String Integer X X -> X) X Accounts -> X
;; Abstract fold function for Account
(define (fold-act fn base act)  ; -> X
  (cond [(false? act) base]
        [else
         (fn (node-id act)
             (node-name act)
             (node-bal act)
             (fold-act fn base (node-l act))
             (fold-act fn base (node-r act)))]))


;; =========================
;; Functions, part 2
;; =========================

;; Accounts -> Accounts
;; Applies a fee (detracts) to all accounts in the tree
; (define (charge-fee fee act) act) ; stub

(check-expect (charge-fee 3
                          (make-node 97 "Prof. X" 7
                                     false
                                     (make-node 112 "Ms. Magazine" 467 false false)))
              (make-node 97 "Prof. X" 4
                         false
                         (make-node 112 "Ms. Magazine" 464 false false)))

(define (charge-fee fee act)
  (local [(define (fn id name bal rl rr)
            (make-node id name (- bal fee) rl rr))
          (define base false)]
    (fold-act fn base act)))
