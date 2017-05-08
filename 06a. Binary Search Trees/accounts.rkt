;; ============================
;; Data Definitions
;; ============================

(define-struct account (num name))
;; Account is (make-account Natural String)
;; An account with ID and the person's name
;; - num           Natural      the person's ID
;; - name          String       the person's name

(define A1 (make-account 1 "aaa"))
(define A2 (make-account 3 "bbb"))
(define A3 (make-account 7 "ccc"))
(define A4 (make-account 12 "ddd"))
(define A5 (make-account 15 "eee"))
(define A6 (make-account 16 "fff"))
(define A7 (make-account 21 "ggg"))

#;
(define (fn-for-account a)
  (... (account-num a)
       (account-name a)))


;; Accounts is one of:
;;  - empty
;;  - (cons (make-account Natural String) Accounts)
;; A list of accounts:
;; - num           Natural       is an account number
;; - name          String        is the person's name

(define L0 empty)
(define L1 (list A1))
(define L7 (list A1 A2 A3 A4 A5 A6 A7))

#;
(define (fn-for-accounts accs)
  (cond [(empty? accs) (...)]
        [else
         (... (account-num  (first accs))        ; Natural
              (account-name (first accs))        ; String
              (fn-for-accounts (rest accs)))]))


;; ============================
;; Functions
;; ============================

;; Accounts Natural -> String or false
;; Try to find account with given number in accounts. If found produce name, otherwise produce false.
; (define (lookup n a) false) ; stub

(check-expect (lookup 1 L0) false)
(check-expect (lookup 1 L1) "aaa")
(check-expect (lookup 7 L7) "ccc")
(check-expect (lookup 9 L7) false)

(define (lookup n a)
  (cond [(empty? a) false]
        [else
         (if (= n (account-num (first a)))
             (account-name (first a))
             (lookup n (rest a)))]))
