;; ====================
;; Data definition
;; ====================

(define-struct wiz (name house kids))
;; Wizard is (make-wiz String String (Listof Wizard))
;; A wizard with name, house, and list of kids

(define WA (make-wiz "A" "S" empty))
(define WB (make-wiz "B" "G" empty))
(define WC (make-wiz "C" "R" empty))
(define WD (make-wiz "D" "H" empty))
(define WE (make-wiz "E" "R" empty))
(define WF (make-wiz "F" "R" (list WB)))
(define WG (make-wiz "G" "S" (list WA)))
(define WH (make-wiz "H" "S" (list WC WD)))
(define WI (make-wiz "I" "H" empty))
(define WJ (make-wiz "J" "R" (list WE WF WG)))
(define WK (make-wiz "K" "G" (list WH WI WJ)))

#;; Template: Arbitrary-Arity Tree, Encapsulation w/ local
(define (fn-for-wiz wiz0)
  (local [(define (fn-for-wiz wiz)
            (... (wiz-name wiz)
                 (wiz-house wiz)
                 (fn-for-low (wiz-kids wiz))))
          (define (fn-for-low low)
            (cond [(empty? low) ...]
                  [else (... (fn-for-wiz (first low))
                             (fn-for-low (rest low)))]))]
    (fn-for-wiz wiz0)))


;; ====================
;; Problem 1
;; ====================
;; Design a function that consumes a wizard and produces the names of every
;; wizard in the tree that was placed in the same house as their immediate
;; parent.

;; Wizard -> (Listof String)
;; Returns a list of names of wizards in the same house as their immediate parent.
; (define (same-house-as-parent wiz) empty) ; stub

(check-expect (same-house-as-parent WE) empty)
(check-expect (same-house-as-parent WG) (list "A"))
(check-expect (same-house-as-parent WK) (list "E" "F" "A"))

#;; Template for Wizard plus context preserving accumulator
(define (fn-for-wiz wiz0)
  ;; parent-house is ...
  ;; base case for parent-house ...
  (local [(define (fn-for-wiz wiz parent-house)
            (... parent-house
                 (wiz-name wiz)
                 (wiz-house wiz)
                 (fn-for-low (wiz-kids wiz) (... parent-house))))
          (define (fn-for-low low parent-house)
            (cond [(empty? low) (... parent-house)]
                  [else (... parent-house
                             (fn-for-wiz (first low) (... parent-house))
                             (fn-for-low (rest low) (... parent-house)))]))]
    (fn-for-wiz wiz0 ...)))

#;
(define (same-house-as-parent wiz0)
  ;; parent-house is String, the house of the current wizard's parent
  ;; base case for parent-house empty String, ""
  (local [(define (fn-for-wiz wiz parent-house)
            (... parent-house
                 (wiz-name wiz)
                 (wiz-house wiz)
                 (fn-for-low (wiz-kids wiz) (... parent-house))))
          (define (fn-for-low low parent-house)
            (cond [(empty? low) (... parent-house)]
                  [else (... parent-house
                             (fn-for-wiz (first low) (... parent-house))
                             (fn-for-low (rest low) (... parent-house)))]))]
    (fn-for-wiz wiz0 ...)))


(define (same-house-as-parent wiz0)
  ;; parent-house is String, the house of the current wizard's parent
  ;; base case for parent-house empty String, ""
  (local [(define (fn-for-wiz wiz parent-house)
            (if (string=? parent-house (wiz-house wiz))
                (cons (wiz-name wiz) (fn-for-low (wiz-kids wiz)
                                                 (wiz-house wiz)))
                (fn-for-low (wiz-kids wiz)
                            (wiz-house wiz))))
          (define (fn-for-low low parent-house)
            (cond [(empty? low) empty]
                  [else (append (fn-for-wiz (first low) parent-house)
                                (fn-for-low (rest low) parent-house))]))]
    (fn-for-wiz wiz0 "")))


;; ====================
;; Problem 2
;; ====================
;; Design a function that consumes a wizard and produces the number of wizards
;; in that tree (including the root). Your function should be tail recursive.

;; Wizard -> Natural
;; Returns the number of wizards in the tree
; (define (count-wizards wiz) 0) ; stub

(check-expect (count-wizards WA) 1)
(check-expect (count-wizards WF) 2)
(check-expect (count-wizards WJ) 6)
(check-expect (count-wizards WK) 11)

#;; Template: Arbitrary-Arity Tree, Encapsulation w/ local
(define (count-wizards wiz0)
  (local [(define (fn-for-wiz wiz)
            (... (wiz-name wiz)
                 (wiz-house wiz)
                 (fn-for-low (wiz-kids wiz))))
          (define (fn-for-low low)
            (cond [(empty? low) ...]
                  [else (... (fn-for-wiz (first low))
                             (fn-for-low (rest low)))]))]
    (fn-for-wiz wiz0)))

#;; Template: Arbitrary-Arity Tree, Encapsulation w/ local + Result-so-far Accumulator
(define (count-wizards wiz0)
  ;; rsf (result-so-far) is ...
  ;; base case for sum is ...
  (local [(define (fn-for-wiz wiz rsf)
            (... rsf
                 (wiz-name wiz)
                 (wiz-house wiz)
                 (fn-for-low (wiz-kids wiz (... rsf)))))
          (define (fn-for-low low rsf)
            (cond [(empty? low) (... rsf)]
                  [else (... rsf
                             (fn-for-wiz (first low) (... rsf))
                             (fn-for-low (rest low) (... rsf)))]))]
    (fn-for-wiz wiz0 ...)))

#; ; Basic, not tail recursive, rsf becomes sum
(define (count-wizards wiz0)
  ;; sum is Natural
  ;; base case for sum is 0
  (local [(define (fn-for-wiz wiz sum)   ; Wizard -> Natural
            (+ 1 (fn-for-low (wiz-kids wiz) sum)))
          (define (fn-for-low low sum)   ; (Listof Wizard) -> Natural
            (cond [(empty? low) sum]
                  [else (+ (fn-for-wiz (first low) sum)
                           (fn-for-low (rest low) sum))]))]
    (fn-for-wiz wiz0 0)))

;; Tail recursive version of count-wizard
(define (count-wizards wiz0)
  ;; sum is Natural
  ;; base case for sum is 0
  (local [(define (fn-for-wiz wiz sum)
            (fn-for-low (wiz-kids wiz) (+ 1 sum)))
          (define (fn-for-low low sum)
            (cond [(empty? low) sum]
                  [else (fn-for-wiz (first low) (fn-for-low (rest low) sum))]))]
    (fn-for-wiz wiz0 0)))

;; Double accumulator
(check-expect (count-wizards2 WA) 1)
(check-expect (count-wizards2 WF) 2)
(check-expect (count-wizards2 WJ) 6)
(check-expect (count-wizards2 WK) 11)

(define (count-wizards2 wiz0)
  (local [(define (fn-for-wiz wiz todo sum)
            (fn-for-low (append (wiz-kids wiz) todo) (+ 1 sum)))
          (define (fn-for-low low sum)
            (cond [(empty? low) sum]
                  [else (fn-for-wiz (first low) (rest low) sum)]))]
    (fn-for-wiz wiz0 empty 0)))


;; ====================
;; Problem 3
;; ====================
;; Design a new function definition for same-house-as-parent that is tail
;; recursive. You will need a worklist accumulator.

;; Wizard -> (Listof String)
;; Returns a list of names of wizards in the same house as their immediate parent.
; (define (same-house-as-parent-tr wiz) empty) ; stub

(check-expect (same-house-as-parent-tr WE) empty)
(check-expect (same-house-as-parent-tr WG) (list "A"))
(check-expect (same-house-as-parent-tr WK) (list "E" "F" "A"))

#;
(define (same-house-as-parent-tr wiz0)
  ;; parent-house is String, the house of the current wizard's parent
  ;; base case for parent-house empty String, ""
  (local [(define (fn-for-wiz wiz parent-house)
            (if (string=? parent-house (wiz-house wiz))
                (cons (wiz-name wiz) (fn-for-low (wiz-kids wiz)
                                                 (wiz-house wiz)))
                (fn-for-low (wiz-kids wiz)
                            (wiz-house wiz))))
          (define (fn-for-low low parent-house)
            (cond [(empty? low) empty]
                  [else (append (fn-for-wiz (first low) parent-house)
                                (fn-for-low (rest low) parent-house))]))]
    (fn-for-wiz wiz0 "")))

(define (same-house-as-parent-tr wiz0)
  ;; - parent-house is String, the house of the current wizard's parent
  ;; base case for parent-house empty String, ""
  ;; - rsf is List, the result so far of the on-going gathering of Wizards' names
  ;; base case for rsf is empty
  (local [(define (fn-for-wiz wiz parent-house rsf)
            (if (string=? parent-house (wiz-house wiz))
                (fn-for-low (wiz-kids wiz) (wiz-house wiz) (list (wiz-name wiz)))
                (fn-for-low (wiz-kids wiz) (wiz-house wiz) empty)))
          (define (fn-for-low low parent-house rsf)
            (cond [(empty? low) rsf]
                  [else (fn-for-low
                         (rest low)
                         parent-house
                         (append rsf (fn-for-wiz (first low) parent-house rsf)))]))]
    (fn-for-wiz wiz0 "" empty)))


;; ====================
;; Problem 3 - templating from scratch
;; ====================

#; ; Templating from Wizard plus content preserving and result-so-far accumulators
(define (fn-for-wiz wiz0)
  ; - parent-house - is the house of the current wizard's parent
  ; - rsf - is the list of names of wizards who's parent is in the same house
  (local [(define (fn-for-wiz wiz parent-house rsf)
            (... parent-house rsf
                 (wiz-name wiz)
                 (wiz-house wiz)
                 (fn-for-low (wiz-kids wiz) (... parent-house) (... rsf))))
          (define (fn-for-low low parent-house rsf)
            (cond [(empty? low) (... parent-house rsf)]
                  [else (... parent-house rsf
                             (fn-for-wiz (first low) (... parent-house) (... rsf))
                             (fn-for-low (rest low) (... parent-house) (... rsf)))]))]
    (fn-for-wiz wiz0 ... ...)))

#;
(define (fn-for-wiz wiz0)
  ; - parent-house - is the house of the current wizard's parent
  ; - rsf - is the list of names of wizards who's parent is in the same house
  (local [(define (fn-for-wiz wiz parent-house rsf)
            (if (string=? parent-house (wiz-house wiz))
                (fn-for-low (wiz-kids wiz) (... parent-house) (... rsf))
                (fn-for-low (wiz-kids wiz) (... parent-house) (... rsf))
                ))
          (define (fn-for-low low parent-house rsf)
            (cond [(empty? low) (... parent-house rsf)]
                  [else (fn-for-low (rest low)
                                    (... parent-house)
                                    (... rsf (fn-for-wiz (first low) (... parent-house) (... rsf))))]
                  ))
          ]
    (fn-for-wiz wiz0 ... ...)))


;; ====================
;; Problem 3 - prof's solution
;; ====================

#; ; Templating from Wizard plus content worklist accumulator
(define (same-house-as-parent-tr3 wiz0)
  ; - todo is - (Listof ...) worklist accumulator
  (local [(define (fn-for-wiz wiz todo)
            ; (... (wiz-name wiz) (wiz-house wiz)
            (fn-for-low (append (... (wiz-kids wiz) todo))))
          (define (fn-for-low todo)
            (cond [(empty? todo) ...]
                  [else (fn-for-wiz (first todo) (rest todo))]))]
    (fn-for-wiz wiz0 ...)))

#; ; Templating from Wizard plus content worklist and result-so-far accumulators
(define (same-house-as-parent-tr3 wiz0)
  ; - todo is - (Listof ...) worklist accumulator
  ; - rsf is - (Listof String) result-so-far accumulator
  (local [(define (fn-for-wiz wiz todo rsf)
            ; (... (wiz-name wiz) (wiz-house wiz)
            (fn-for-low (append (... (wiz-kids wiz) todo (... rsf)))))
          (define (fn-for-low todo rsf)
            (cond [(empty? todo) ...]
                  [else (fn-for-wiz (first todo) (rest todo) (... rsf))]))]
    (fn-for-wiz wiz0 ... ...)))

#; ; Templating from Wizard plus content worklist and result-so-far accumulators
(define (same-house-as-parent-tr3 wiz0)
  ; - todo is - (Listof ...) worklist accumulator
  ; - rsf is - (Listof String) result-so-far accumulator
  (local [(define (fn-for-wiz wiz todo rsf)
            ; (... (wiz-name wiz) (wiz-house wiz)
            (fn-for-low (append (... (wiz-kids wiz) todo (... rsf)))))
          (define (fn-for-low todo rsf)
            (cond [(empty? todo) ...]
                  [else (fn-for-wiz (first todo) (rest todo) (... rsf))]))]
    (fn-for-wiz wiz0 ... ...)))

#; ; Templating from Wizard, plus...
; - content worklist and result-so-far accumulators
; - worklist entry helper
(define (same-house-as-parent-tr3 wiz0)
  ; - todo is - (Listof ...) worklist accumulator
  ; - rsf is - (Listof String) result-so-far accumulator
  (local [(define-struct wle (w ph))
          ;; WLE (worklist entry) is (make-wle Wizard String)
          ;; A worklist entry with the wizard to pass to fn-for-wiz
          ;; and that wizard's parent house
          (define (fn-for-wiz wiz ph todo rsf)
            ; (... (wiz-name wiz) (wiz-house wiz)
            (fn-for-low (append (... (wiz-kids wiz) todo (... rsf)))))
          (define (fn-for-low todo rsf)
            (cond [(empty? todo) rsf]
                  [else (fn-for-wiz
                         (wle-w (first todo))
                         (wle-ph (first todo))
                         (rest todo) (... rsf))]))]
    (fn-for-wiz wiz0 ... ... ...)))

#; ; Templating from Wizard, plus...
; - content worklist and result-so-far accumulators
; - worklist entry helper
(define (same-house-as-parent-tr3 wiz0)
  ; - todo is - (Listof ...) worklist accumulator
  ; - rsf is - (Listof String) result-so-far accumulator
  (local [(define-struct wle (w ph))
          ;; WLE (worklist entry) is (make-wle Wizard String)
          ;; A worklist entry with the wizard to pass to fn-for-wiz
          ;; and that wizard's parent house
          (define (fn-for-wiz wiz ph todo rsf)
            ; (... (wiz-name wiz) (wiz-house wiz)
            (fn-for-low (append (map (λ (k)
                                       (make-wle k (wiz-house wiz)))
                                     (wiz-kids wiz))
                                todo (... rsf))))
          (define (fn-for-low todo rsf)
            (cond [(empty? todo) rsf]
                  [else (fn-for-wiz
                         (wle-w (first todo))
                         (wle-ph (first todo))
                         (rest todo) (... rsf))]))]
    (fn-for-wiz wiz0 ... ... ...)))

#; ; Templating from Wizard, plus...
; - content worklist and result-so-far accumulators
; - worklist entry helper
(define (same-house-as-parent-tr3 wiz0)
  ; - todo is - (Listof ...) worklist accumulator
  ; - rsf is - (Listof String) result-so-far accumulator
  (local [(define-struct wle (w ph))
          ;; WLE (worklist entry) is (make-wle Wizard String)
          ;; A worklist entry with the wizard to pass to fn-for-wiz
          ;; and that wizard's parent house
          (define (fn-for-wiz wiz ph todo rsf)
            (fn-for-low (append (map (λ (k)
                                       (make-wle k (wiz-house wiz)))
                                     (wiz-kids wiz))
                                todo)
                        (if (string=? (wiz-house wiz) ph)
                            (cons (wiz-name wiz) rsf)
                            rsf)))
          (define (fn-for-low todo rsf)
            (cond [(empty? todo) rsf]
                  [else (fn-for-wiz
                         (wle-w (first todo))
                         (wle-ph (first todo))
                         (rest todo) rsf)]))]
    (fn-for-wiz wiz0 ... ... ...)))

(check-expect (same-house-as-parent-tr3 WE) empty)
(check-expect (same-house-as-parent-tr3 WG) (list "A"))
(check-expect (same-house-as-parent-tr3 WK) (list "A" "F" "E"))

(define (same-house-as-parent-tr3 wiz0)
  ; - todo is - (Listof ...) worklist accumulator
  ; - rsf is - (Listof String) result-so-far accumulator
  (local [(define-struct wle (w ph))
          ;; WLE (worklist entry) is (make-wle Wizard String)
          ;; A worklist entry with the wizard to pass to fn-for-wiz
          ;; and that wizard's parent house
          (define (fn-for-wiz wiz ph todo rsf)
            (fn-for-low (append (map (λ (k)
                                       (make-wle k (wiz-house wiz)))
                                     (wiz-kids wiz))
                                todo)
                        (if (string=? (wiz-house wiz) ph)
                            (cons (wiz-name wiz) rsf)
                            rsf)))
          (define (fn-for-low todo rsf)
            (cond [(empty? todo) rsf]
                  [else (fn-for-wiz
                         (wle-w (first todo))
                         (wle-ph (first todo))
                         (rest todo) rsf)]))]
    (fn-for-wiz wiz0 "" empty empty)))
