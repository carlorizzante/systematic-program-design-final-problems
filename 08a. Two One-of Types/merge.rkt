;; ==========================
;; Data definition
;; ==========================

;; ListOfNumber is one of:
;; - empty
;; (cons Number ListOfNumber)

;; Assume ListOfNumber is a list of sorted numbers in ascending order

(define LON0 empty)
(define LON1 (cons 1 empty))
(define LON2 (cons 2 LON1))
(define LON3 (cons 3 LON2))


;; ==========================
;; Functions
;; ==========================

;; ListOfNumber ListOfNumber -> ListOfNumber
;; Given two lists of numbers, returns a new list with all the numbers sorted in ascending order
;; Assume given lists are already sorted in ascending order.
; (define (merge a b) empty) ; stub

;; a     /    b | empty | ListOfNumber
;; ------------------------------------
;; empty        | empty | b
;; ------------------------------------
;; ListOfNumber |   a   | ...a ...b ...

(check-expect (merge empty empty) empty)
(check-expect (merge (list 1 2 3) empty) (list 1 2 3))
(check-expect (merge empty (list 3 5 8)) (list 3 5 8))
(check-expect (merge (list 1 3 5) (list 2 4 6)) (list 1 2 3 4 5 6))
(check-expect (merge (list 4) (list 1 3 6)) (list 1 3 4 6))
(check-expect (merge (list 4 7 9) (list 8)) (list 4 7 8 9))

#;
(define (merge a b)
  (cond [(and (empty? a) (empty? b)) empty]
        [(empty? a) b]
        [(empty? b) a]
        [else (if (< (first a) (first b))
                  (cons (first a) (merge (rest a) b))
                  (cons (first b) (merge a (rest b))))]))

(define (merge a b)
  (cond [(empty? a) b]
        [(empty? b) a]
        [else (if (< (first a) (first b))
                  (cons (first a) (merge (rest a) b))
                  (cons (first b) (merge a (rest b))))]))
