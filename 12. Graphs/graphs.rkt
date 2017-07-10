;; ==========================
;; Data definition
;; ==========================
; In computer science, we refer to such an information structure as a directed graph.
; Like trees, in directed graphs the arrows have direction. But in a graph it is
; possible to go in circles, as in the second example above. It is also possible for
; two arrows to lead into a single node, as in the fourth example.


(define-struct room (name exits))
;; Room is (make-room String (Listof Room))
;; A room with name and its one-way connections to other rooms

;; Two rooms, A -> B
(define H1 (make-room "A" (list (make-room "B" empty))))

;; Two rooms, A <-> B
(define H2 (shared ((-0- (make-room "A" (list (make-room "B" (list -0-))))))
             -0-))

; (room-name H2)           ; "A"
; H2                       ; (shared ((-0- (make-room "A" (list (make-room "B" (list -0-)))))) -0-)
; (room-exits H2)          ; (shared ((-0- (list (make-room "B" (list (make-room "A" -0-)))))) -0-)
; (length (room-exits H2)) ; 1
; (map room-name (room-exits H2)) ; (list "B")

;; Three rooms, A -> B -> C -> A
(define H3 (shared ((-A- (make-room "A" (list -B-)))
                    (-B- (make-room "B" (list -C-)))
                    (-C- (make-room "C" (list -A-))))
             -A-))

;; Five rooms with various interconnections
(define H5
  (shared ((-A- (make-room "A" (list -B- -C-)))
           (-B- (make-room "B" (list -E-)))
           (-C- (make-room "C" (list -B- -D-)))
           (-D- (make-room "D" empty))
           (-E- (make-room "E" (list -C- -D-))))
    -A-))

;; Six rooms with varios interconnections
(define H6 (shared ((-A- (make-room "A" (list -B- -D-)))
                    (-B- (make-room "B" (list -C- -E-)))
                    (-C- (make-room "C" (list -B-)))
                    (-D- (make-room "D" (list -E-)))
                    (-E- (make-room "E" (list -F- -A-)))
                    (-F- (make-room "F" empty)))
             -A-))

; H6 ; (shared ((-0- (make-room "A" (list -3- (make-room "D" (list -10-)))))
;          (-10- (make-room "E" (list (make-room "F" '()) -0-)))
;          (-3- (make-room "B" (list (make-room "C" (list -3-)) -10-))))
;   -0-)


;; Template
;; - Structural recursion
;; - Encapsulation w/ local
;; - Tail-recursive w/ worklist
;; - Context-preserving accumulator (base case - where have we've been already)
#;
(define (fn-for-house r0)
  (local [(define (fn-for-room r)
            (... (room-name r)
                 (fn-for-lor (room-exits r))))
          (define (fn-for-lor lor)
            (cond [(empty? lor) ...]
                  [else (... (fn-for-room (first lor))
                             (fn-for-lor (rest lor)))]))
          ]
    (fn-for-room r0)))

#; ; Mine
(define (fn-for-house r0)
  (local [(define (fn-for-room r wkl)
            (... wkl
                 (room-name r)
                 (fn-for-lor (room-exits r) (... wkl))))
          (define (fn-for-lor lor wkl)
            (cond [(empty? lor) (... wkl)]
                  [else (... wkl
                             (fn-for-room (first lor) (... wkl))
                             (fn-for-lor (rest lor) (... wkl)))]))
          ]
    (fn-for-room r0 wkl)))

#; ; Prof's
(define (fn-for-house r0)
  (local [(define (fn-for-room r todo)
            (... (room-name r)
                 (fn-for-lor (room-exits r))))
          (define (fn-for-lor todo)
            (cond [(empty? todo) ...]
                  [else (... (fn-for-room (first todo) (... todo))
                             (fn-for-lor (rest todo)))]))
          ]
    (fn-for-room r0 ...todo)))

#;
(define (fn-for-house r0)
  (local [(define (fn-for-room r todo)
            ; (... (room-name r)
            (fn-for-lor (append (room-exits r) todo)))
          (define (fn-for-lor todo)
            (cond [(empty? todo) ...]
                  [else (fn-for-room (first todo)
                                     (rest todo))]))
          ]
    (fn-for-room r0 ...todo)))

#; ; - infinite loop at this stage, gotta fix that with context-preserving acc
(define (fn-for-house r0)
  ;; todo is worklist (List of Room) - starts out as empty
  (local [(define (fn-for-room r todo)
            ; (... (room-name r)
            (fn-for-lor (append (room-exits r) todo)))
          (define (fn-for-lor todo)
            (cond [(empty? todo) ...]
                  [else (fn-for-room (first todo)
                                     (rest todo))]))
          ]
    (fn-for-room r0 empty)))

#;
(define (fn-for-house r0)
  ;; todo    is (List of Room)   - worklist, starts out as empty
  ;; visited is (List of String) - context-preserving accumulator, Names of rooms already visited
  (local [(define (fn-for-room r todo visited)
            ; (... (room-name r)
            (fn-for-lor (append (room-exits r) tod) (... visited)))
          (define (fn-for-lor todo visited)
            (cond [(empty? todo) ...]
                  [else (fn-for-room (first todo)
                                     (rest todo)
                                     (... visited))]))
          ]
    (fn-for-room r0 empty (... visited))))

#;
(define (fn-for-house r0)
  ;; todo    is (List of Room)   - worklist, starts out as empty
  ;; visited is (List of String) - context-preserving accumulator, Names of rooms already visited
  (local [(define (fn-for-room r todo visited)
            (if (member? (room-name r) visited)
                (fn-for-lor todo (... visited))
                (fn-for-lor (append (room-exits r) todo) (... visited))))
          (define (fn-for-lor todo visited)
            (cond [(empty? todo) ...]
                  [else (fn-for-room (first todo)
                                     (rest todo)
                                     (... visited))]))
          ]
    (fn-for-room r0 empty (... visited))))

#;
(define (fn-for-house r0)
  ;; todo    is (List of Room)   - worklist, starts out as empty
  ;; visited is (List of String) - context-preserving accumulator, Names of rooms already visited
  (local [(define (fn-for-room r todo visited)
            ; (room-name r) ; Don't forget this part, may be useful
            (if (member? (room-name r) visited)
                (fn-for-lor todo visited)
                (fn-for-lor (append (room-exits r) todo)
                            (cons (room-name r) visited))))
          (define (fn-for-lor todo visited)
            (cond [(empty? todo) ...]
                  [else (fn-for-room (first todo)
                                     (rest todo)
                                     visited)]))
          ]
    (fn-for-room r0 empty empty)))


;; ==========================
;; Functions
;; ==========================

;; Room String -> Boolean
;; Returns true if the room name is reachable within tree
; (define (reachable? r rn) false) ; stub

(check-expect (reachable? H1 "A") true)
(check-expect (reachable? H1 "B") true)
(check-expect (reachable? H1 "C") false)
(check-expect (reachable? (first (room-exits H1)) "A") false)
(check-expect (reachable? H6 "F") true)

(define (reachable? r0 rn)
  ;; todo    is (List of Room)   - worklist, starts out as empty
  ;; visited is (List of String) - context-preserving accumulator, Names of rooms already visited
  (local [(define (fn-for-room r todo visited)
            (cond [(string=? (room-name r) rn) true]
                  [else (if (member? (room-name r) visited)
                            (fn-for-lor todo visited)
                            (fn-for-lor (append (room-exits r) todo)
                                        (cons (room-name r) visited)))]))
          (define (fn-for-lor todo visited)
            (cond [(empty? todo) false]
                  [else (fn-for-room (first todo)
                                     (rest todo)
                                     visited)]))
          ]
    (fn-for-room r0 empty empty)))


;; Room -> Natural
;; produce the total number of rooms reachable from a given room, including the room itself
; (define (count-rooms r) 0) ; stub

(check-expect (count-rooms H1) 2)
(check-expect (count-rooms H2) 2)
(check-expect (count-rooms H3) 3)
(check-expect (count-rooms H5) 5)
(check-expect (count-rooms H6) 6)

(define (count-rooms r0)
  ;; todo    is (List of Room)   - worklist, starts out as empty
  ;; visited is (List of String) - context-preserving accumulator, Names of rooms already visited
  ;; count is Natural            - result-so-far accumulator, number of rooms visited
  (local [(define (fn-for-room r todo visited count)
            (if (member? (room-name r) visited)
                (fn-for-lor todo visited count)
                (fn-for-lor (append (room-exits r) todo)
                            (cons (room-name r) visited)
                            (add1 count))))
          (define (fn-for-lor todo visited count)
            (cond [(empty? todo) count]
                  [else (fn-for-room (first todo)
                                     (rest todo)
                                     visited
                                     count)]))
          ]
    (fn-for-room r0 empty empty 0)))
