;; ============================
;; Data Definition
;; ============================

(define-struct room (name exits))
;; Room is (make-room String (listof Room))
;; interp. the room's name, and list of rooms that the exits lead to

(define H1 (make-room "A" (list (make-room "B" empty))))

(define H2
  (shared ((-0- (make-room "A" (list (make-room "B" (list -0-))))))
    -0-))

(define H3
  (shared ((-A- (make-room "A" (list -B-)))
           (-B- (make-room "B" (list -C-)))
           (-C- (make-room "C" (list -A-))))
    -A-))

(define H4
  (shared ((-A- (make-room "A" (list -B- -D-)))
           (-B- (make-room "B" (list -C- -E-)))
           (-C- (make-room "C" (list -B-)))
           (-D- (make-room "D" (list -E-)))
           (-E- (make-room "E" (list -F- -A-)))
           (-F- (make-room "F" (list))))
    -A-))


;; ============================
;; Templating
;; ============================

;; Template components:
;; - structural recursion
;; - encapsulate w/ local
;; - tail-recursive w/ worklist
;; - context-preserving accumulator (which room have we already visited?)

#; ;; step1 - basic template
(define (fn-for-house r0)
  (local [(define (fn-for-room r) ...)
          (define (fn-for-lor lor) ...)]
    (fn-for-room r0)))

#; ;; step2 - fn-for-room
(define (fn-for-house r0)
  (local [(define (fn-for-room r)
            (... (room-name r)
                 (room-exits r)))
          (define (fn-for-lor lor) ...)]
    (fn-for-room r0)))

#; ;; step3 - handling (listof Room) in fn-for-room
(define (fn-for-house r0)
  (local [(define (fn-for-room r)
            (... (room-name r)
                 (fn-for-lor (room-exits r))))
          (define (fn-for-lor lor) ...)]
    (fn-for-room r0)))

#; ;; step4 - fn-for-low
(define (fn-for-house r0)
  (local [(define (fn-for-room r)
            (... (room-name r)
                 (fn-for-lor (room-exits r))))
          (define (fn-for-lor lor)
            (cond [(empty? lor) (...)]
                  [else
                   (... (first lor)
                        (rest lor))]))]
    (fn-for-room r0)))

#; ;; step5 - handling fork in fn-for-lor (first/rest lor)
(define (fn-for-house r0)
  (local [(define (fn-for-room r)
            (... (room-name r)
                 (fn-for-lor (room-exits r))))
          (define (fn-for-lor lor)
            (cond [(empty? lor) (...)]
                  [else
                   (... (fn-for-room (first lor))
                        (fn-for-lor (rest lor)))]))]
    (fn-for-room r0)))

#; ;; step6 - worklist, renaming lor into todo
(define (fn-for-house r0)
  (local [(define (fn-for-room r)
            (... (room-name r)
                 (fn-for-lor (room-exits r))))
          (define (fn-for-lor todo)
            (cond [(empty? todo) (...)]
                  [else
                   (... (fn-for-room (first todo))
                        (fn-for-lor (rest todo)))]))]
    (fn-for-room r0)))

#; ;; step7 - worklist, adding todo to fn-for-room
(define (fn-for-house r0)
  (local [(define (fn-for-room r todo)
            (... (room-name r)
                 (fn-for-lor (room-exits r))))
          (define (fn-for-lor todo)
            (cond [(empty? todo) (...)]
                  [else
                   (... (fn-for-room (first todo) ...)
                        (fn-for-lor (rest todo)))]))]
    (fn-for-room r0 ...)))

#; ;; step8 - tail recursive fn-for-room
(define (fn-for-house r0)
  (local [(define (fn-for-room r todo)
            (fn-for-lor (append (room-exits r) todo))) ; (... (room-name r) ?
          (define (fn-for-lor todo)
            (cond [(empty? todo) (...)]
                  [else
                   (... (fn-for-room (first todo) ...)
                        (fn-for-lor (rest todo)))]))]
    (fn-for-room r0 ...)))

#; ;; step9 - tail recursive fn-for-lor
(define (fn-for-house r0)
  (local [(define (fn-for-room r todo)
            (fn-for-lor (append (room-exits r) todo))) ; (... (room-name r) ?
          (define (fn-for-lor todo)
            (cond [(empty? todo) (...)]
                  [else
                   (fn-for-room (first todo) (rest todo))]))]
    (fn-for-room r0 empty))) ; worklist starts out as empty

#; ;; step10 - notes
(define (fn-for-house r0)
  ; todo is (listof Room) - a worklist accumulator
  ; visited is (listof String) - context preserving accumulator (visited rooms' names)
  ;                              assumes rooms' names are unique
  (local [(define (fn-for-room r todo)
            (fn-for-lor (append (room-exits r) todo))) ; (... (room-name r) ?
          (define (fn-for-lor todo)
            (cond [(empty? todo) (...)]
                  [else
                   (fn-for-room (first todo) (rest todo))]))]
    (fn-for-room r0 empty))) ; worklist starts out as empty

#; ;; step11 - adding context preserving accumulator
(define (fn-for-house r0)
  ; todo is (listof Room) - a worklist accumulator
  ; visited is (listof String) - context preserving accumulator (visited rooms' names)
  ;                              assumes rooms' names are unique
  (local [(define (fn-for-room r todo visited)
            (fn-for-lor (append (room-exits r) todo))) ; (... (room-name r) ?
          (define (fn-for-lor todo visited)
            (cond [(empty? todo) (...)]
                  [else
                   (fn-for-room (first todo) (rest todo))]))]
    (fn-for-room r0 empty ...))) ; worklist starts out as empty

#; ;; step12 - adding context preserving accumulator, part II
(define (fn-for-house r0)
  ; todo is (listof Room) - a worklist accumulator
  ; visited is (listof String) - context preserving accumulator (visited rooms' names)
  ;                              assumes rooms' names are unique
  (local [(define (fn-for-room r todo visited)
            (if (member (room-name r) visited)
                (fn-for-lor todo visited)
                (fn-for-lor (append (room-exits r) todo)
                            (cons (room-name r) visited)))) ; (... (room-name r) ?
          (define (fn-for-lor todo visited)
            (cond [(empty? todo) (...)]
                  [else
                   (fn-for-room (first todo) (rest todo))]))]
    (fn-for-room r0 empty ...))) ; worklist starts out as empty

#; ;; step13 - adding context preserving accumulator, part III
(define (fn-for-house r0)
  ; todo is (listof Room) - a worklist accumulator
  ; visited is (listof String) - context preserving accumulator (visited rooms' names)
  ;                              assumes rooms' names are unique
  (local [(define (fn-for-room r todo visited)
            (if (member (room-name r) visited)
                (fn-for-lor todo visited)
                (fn-for-lor (append (room-exits r) todo)
                            (cons (room-name r) visited)))) ; (... (room-name r) ?
          (define (fn-for-lor todo visited)
            (cond [(empty? todo) (...)]
                  [else
                   (fn-for-room (first todo)
                                (rest todo)
                                visited)]))] ; it's only fn-for-room that manipultes visited
    (fn-for-room r0 empty empty))) ; worklist starts out as empty


;; ============================
;; Functions
;; ============================

;; Room String -> Boolean
;; Given a Room as root, returns true if a second Room (by name) is reachable, false otherwise
; (define (reachable? r0 rn) false) ; stub

(check-expect (reachable? H1 "A") true)
(check-expect (reachable? H1 "B") true)
(check-expect (reachable? (first (room-exits H1)) "A") false) ; from B to A
(check-expect (reachable? (first (room-exits H2)) "A") true) ; from B to A
(check-expect (reachable? H1 "C") false)
(check-expect (reachable? H4 "F") true)
(check-expect (reachable? (first (room-exits H4)) "A") true) ; from B to A
(check-expect (reachable? (first (room-exits H4)) "D") true) ; from B to D

(define (reachable? r0 rn)
  ; todo is (listof Room) - a worklist accumulator
  ; visited is (listof String) - context preserving accumulator (visited rooms' names)
  ;                              assumes rooms' names are unique
  (local [(define (fn-for-room r todo visited)
            (if (string=? (room-name r) rn) true
                (if (member (room-name r) visited)
                    (fn-for-lor todo visited)
                    (fn-for-lor (append (room-exits r) todo)
                                (cons (room-name r) visited))))) ; (... (room-name r) ?
          (define (fn-for-lor todo visited)
            (cond [(empty? todo) false]
                  [else
                   (fn-for-room (first todo)
                                (rest todo)
                                visited)]))] ; it's only fn-for-room that manipultes visited
    (fn-for-room r0 empty empty))) ; worklist starts out as empty



;; Room -> Natural
;; produce the total number of rooms reachable from a given room, including the room itself

(check-expect (reachable-rooms H1) 2)
(check-expect (reachable-rooms H2) 2)
(check-expect (reachable-rooms H3) 3)
(check-expect (reachable-rooms H4) 6)

#; ; template + result-so-far accumulator
(define (reachable-rooms r0)
  ;; todo is (listof Room); a worklist accumulator
  ;; visited is (listof String); context preserving acc, names of rooms already visited
  ;; rsf is total of rooms reached so far
  (local [(define (fn-for-room r todo visited rsf)
            (if (member (room-name r) visited)
                (fn-for-lor todo visited (... rsf))
                (fn-for-lor (append (room-exits r) todo)
                            (cons (room-name r) visited)
                            (... rsf))))
          (define (fn-for-lor todo visited rsf)
            (cond [(empty? todo) (... rsf)]
                  [else
                   (fn-for-room (first todo)
                                (rest todo)
                                visited
                                (... rsf))]))]
    (fn-for-room r0 empty empty)))

; proper function
(define (reachable-rooms r0)
  ;; todo is (listof Room); a worklist accumulator
  ;; visited is (listof String); context preserving acc, names of rooms already visited
  ;; rsf is total of rooms reached so far
  (local [(define (fn-for-room r todo visited rsf)
            (if (member (room-name r) visited)
                (fn-for-lor todo visited rsf)
                (fn-for-lor (append (room-exits r) todo)
                            (cons (room-name r) visited)
                            (+ 1 rsf))))
          (define (fn-for-lor todo visited rsf)
            (cond [(empty? todo) rsf]
                  [else
                   (fn-for-room (first todo)
                                (rest todo)
                                visited
                                rsf)]))]
    (fn-for-room r0 empty empty 0)))
