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

(define H5
  (shared ((-A- (make-room "A" (list -B- -D-)))
           (-B- (make-room "B" (list -C- -E-)))
           (-C- (make-room "C" (list -B-)))
           (-D- (make-room "D" (list -E-)))
           (-E- (make-room "E" (list -F- -C- -A-))) ; Only difference from H4 is here
           (-F- (make-room "F" (list))))
    -A-))

;; template: structural recursion, encapsulate w/ local, tail-recursive w/ worklist,
;;           context-preserving accumulator what rooms have we already visited
#;
(define (fn-for-house r0)
  ;; todo is (listof Room); a worklist accumulator
  ;; visited is (listof String); context preserving accumulator, names of rooms already visited
  (local [(define (fn-for-room r todo visited)
            (if (member (room-name r) visited)
                (fn-for-lor todo visited)
                (fn-for-lor (append (room-exits r) todo)
                            (cons (room-name r) visited)))) ; (... (room-name r))
          (define (fn-for-lor todo visited)
            (cond [(empty? todo) (...)]
                  [else
                   (fn-for-room (first todo)
                                (rest todo)
                                visited)]))]
    (fn-for-room r0 empty empty)))


;; ============================
;; Functions
;; ============================

;; Room -> Natural
;; Returns the total number of rooms reachable from a given room, including the room itself
; (define (reachable-rooms r0) 0) ; stub

(check-expect (reachable-rooms H1) 2)
(check-expect (reachable-rooms H2) 2)
(check-expect (reachable-rooms H3) 3)
(check-expect (reachable-rooms H4) 6)

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


;; Room -> String
;; Returns the name of the room with the most number of exits
; (define (room-with-max-exits r0) 0) ; stub

(check-expect (room-with-max-exits H1) "A")
(check-expect (room-with-max-exits H2) "B")
(check-expect (room-with-max-exits H3) "C")
(check-expect (room-with-max-exits H4) "E")
(check-expect (room-with-max-exits H5) "E")

(define (room-with-max-exits r0)
  ;; todo is (listof Room); a worklist accumulator
  ;; visited is (listof String); context preserving accumulator, names of rooms already visited
  ;; rsf is room with max number of exits so far
  (local [(define (fn-for-room r todo visited rsf)
            (if (member (room-name r) visited)
                (fn-for-lor todo visited rsf)
                (fn-for-lor (append (room-exits r) todo)
                            (cons (room-name r) visited)
                            (if (> (length (room-exits rsf)) (length (room-exits r)))
                                rsf
                                r)))) ; (... (room-name r))
          (define (fn-for-lor todo visited rsf)
            (cond [(empty? todo) (room-name rsf)]
                  [else
                   (fn-for-room (first todo)
                                (rest todo)
                                visited
                                rsf)]))]
    (fn-for-room r0 empty empty (make-room "X" empty))))


;; Room -> Number
;; Returns the total exits of the room with the most number of exits
; (define (max-exits r0) 0) ; stub

(check-expect (max-exits H1) 1)
(check-expect (max-exits H2) 1)
(check-expect (max-exits H3) 1)
(check-expect (max-exits H4) 2)
(check-expect (max-exits H5) 3)

(define (max-exits r0)
  ;; todo is (listof Room); a worklist accumulator
  ;; visited is (listof String); context preserving accumulator, names of rooms already visited
  ;; rsf is room with max number of exits so far
  (local [(define (fn-for-room r todo visited rsf)
            (if (member (room-name r) visited)
                (fn-for-lor todo visited rsf)
                (fn-for-lor (append (room-exits r) todo)
                            (cons (room-name r) visited)
                            (if (> rsf (length (room-exits r)))
                                rsf
                                (length (room-exits r)))))) ; (... (room-name r))
          (define (fn-for-lor todo visited rsf)
            (cond [(empty? todo) rsf]
                  [else
                   (fn-for-room (first todo)
                                (rest todo)
                                visited
                                rsf)]))]
    (fn-for-room r0 empty empty 0)))
