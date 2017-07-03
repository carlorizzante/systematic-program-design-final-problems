(require racket/list) ;gets list-ref, take and drop

;; ===================
;; Problem
;; ===================
;;
;; Brute force Sudoku solver
;;
;; In Sudoku, the board is a 9x9 grid of SQUARES.
;; There are 9 ROWS and 9 COLUMNS, there are also 9
;; 3x3 BOXES.  Rows, columns and boxes are all UNITs.
;; So there are 27 units.
;;
;; The idea of the game is to fill each square with
;; a Natural[1, 9] such that no unit contains a duplicate
;; number.
;;


;; ===================
;; Data definitions
;; ===================

;; Val is Natural[1, 9]

;; Board is (listof Val|false) that is 81 elements long
;; interp.
;;  Visually a board is a 9x9 array of squares, where each square
;;  has a row and column number (r, c). But we represent it as a
;;  single flat list, in which the rows are layed out one after
;;  another in a linear fashion. (See interp. of Pos below for how
;;  we convert back and forth between (r, c) and position in a board.)

;; Pos is Natural[0, 80]
;; interp.
;;  the position of a square on the board, for a given p, then
;;    - the row    is (quotient p 9)
;;    - the column is (remainder p 9)


;; Convert 0-based row and column to Pos
(define (r-c->pos r c) (+ (* r 9) c))  ; helpful for writing tests


;; Unit is (listof Pos) of length 9
;; interp.
;;  The position of every square in a unit. There are
;;  27 of these for the 9 rows, 9 columns and 9 boxes.


;; ===================
;; Constants
;; ===================

(define ALL-VALS (list 1 2 3 4 5 6 7 8 9))

(define B false) ; B stands for blank

(define BD0
  (list B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B))

(define BD1
  (list 1 2 3 4 5 6 7 8 9
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B))

(define BD2
  (list 1 B B B B B B B B
        2 B B B B B B B B
        3 B B B B B B B B
        4 B B B B B B B B
        5 B B B B B B B B
        6 B B B B B B B B
        7 B B B B B B B B
        8 B B B B B B B B
        9 B B B B B B B B))

(define BD3
  (list 1 2 3 B B B B B B
        4 5 6 B B B B B B
        7 8 9 B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B))

(define BD4                ; easy
  (list 2 7 4 B 9 1 B B 5
        1 B B 5 B B B 9 B
        6 B B B B 3 2 8 B
        B B 1 9 B B B B 8
        B B 5 1 B B 6 B B
        7 B B B 8 B B B 3
        4 B 2 B B B B B 9
        B B B B B B B 7 B
        8 B B 3 4 9 B B B))

(define BD4s               ; solution to 4
  (list 2 7 4 8 9 1 3 6 5
        1 3 8 5 2 6 4 9 7
        6 5 9 4 7 3 2 8 1
        3 2 1 9 6 4 7 5 8
        9 8 5 1 3 7 6 4 2
        7 4 6 2 8 5 9 1 3
        4 6 2 7 5 8 1 3 9
        5 9 3 6 1 2 8 7 4
        8 1 7 3 4 9 5 2 6))

(define BD5                ; hard
  (list 5 B B B B 4 B 7 B
        B 1 B B 5 B 6 B B
        B B 4 9 B B B B B
        B 9 B B B 7 5 B B
        1 8 B 2 B B B B B
        B B B B B 6 B B B
        B B 3 B B B B B 8
        B 6 B B 8 B B B 9
        B B 8 B 7 B B 3 1))

(define BD5s               ; solution to 5
  (list 5 3 9 1 6 4 8 7 2
        8 1 2 7 5 3 6 9 4
        6 7 4 9 2 8 3 1 5
        2 9 6 4 1 7 5 8 3
        1 8 7 2 3 5 9 4 6
        3 4 5 8 9 6 1 2 7
        9 2 3 5 4 1 7 6 8
        7 6 1 3 8 2 4 5 9
        4 5 8 6 7 9 2 3 1))

(define BD6                ; hardest ever? (Dr Arto Inkala)
  (list B B 5 3 B B B B B
        8 B B B B B B 2 B
        B 7 B B 1 B 5 B B
        4 B B B B 5 3 B B
        B 1 B B 7 B B B 6
        B B 3 2 B B B 8 B
        B 6 B 5 B B B B 9
        B B 4 B B B B 3 B
        B B B B B 9 7 B B))

(define BD7                 ; no solution
  (list 1 2 3 4 5 6 7 8 B
        B B B B B B B B 2
        B B B B B B B B 3
        B B B B B B B B 4
        B B B B B B B B 5
        B B B B B B B B 6
        B B B B B B B B 7
        B B B B B B B B 8
        B B B B B B B B 9))

(define BD8                 ; invalid board for columns
  (list 2 7 4 B 9 1 B B 5
        1 B B 5 B B B 9 B
        6 B B B B 3 2 8 B
        B B 1 9 B B B B 8
        B B 5 1 B B 6 B B
        7 B B B 8 B B B 3
        4 B 2 B B B B B 9
        B B B B B B 6 7 B
        8 B B 3 4 9 B B B))

(define BD9                 ; invalid board for row
  (list 2 7 4 B 9 1 B B 5
        1 B B 5 B B B 9 B
        6 B B B B 3 2 8 B
        B B 1 9 B B B B 8
        B B 5 1 B B 6 B B
        7 B B B 8 B B 8 3
        4 B 2 B B B B B 9
        B B B B B B B 7 B
        8 B B 3 4 9 B B B))

(define BD10                 ; invalid board for boxes
  (list 5 B B B B 4 B 7 B
        B 1 B B 5 B 6 B B
        B B 4 9 B B B B B
        B 9 B B B 7 5 B B
        1 8 B 2 B B B B B
        B B B B B 6 B B B
        B B 3 B B B B B 8
        B 6 B B 8 B 3 B 9
        B B 8 B 7 B B 3 1))


;; Positions of all the rows, columns and boxes:

(define ROWS
  (list (list  0  1  2  3  4  5  6  7  8)
        (list  9 10 11 12 13 14 15 16 17)
        (list 18 19 20 21 22 23 24 25 26)
        (list 27 28 29 30 31 32 33 34 35)
        (list 36 37 38 39 40 41 42 43 44)
        (list 45 46 47 48 49 50 51 52 53)
        (list 54 55 56 57 58 59 60 61 62)
        (list 63 64 65 66 67 68 69 70 71)
        (list 72 73 74 75 76 77 78 79 80)))

(define COLS
  (list (list 0  9 18 27 36 45 54 63 72)
        (list 1 10 19 28 37 46 55 64 73)
        (list 2 11 20 29 38 47 56 65 74)
        (list 3 12 21 30 39 48 57 66 75)
        (list 4 13 22 31 40 49 58 67 76)
        (list 5 14 23 32 41 50 59 68 77)
        (list 6 15 24 33 42 51 60 69 78)
        (list 7 16 25 34 43 52 61 70 79)
        (list 8 17 26 35 44 53 62 71 80)))

(define BOXES
  (list (list  0  1  2  9 10 11 18 19 20)
        (list  3  4  5 12 13 14 21 22 23)
        (list  6  7  8 15 16 17 24 25 26)
        (list 27 28 29 36 37 38 45 46 47)
        (list 30 31 32 39 40 41 48 49 50)
        (list 33 34 35 42 43 44 51 52 53)
        (list 54 55 56 63 64 65 72 73 74)
        (list 57 58 59 66 67 68 75 76 77)
        (list 60 61 62 69 70 71 78 79 80)))

(define UNITS (append ROWS COLS BOXES))


;; ===================
;; Helper functions
;; ===================

;; Board Pos -> Val or false
;; Produce value at given position on board.
(check-expect (read-square BD1 (r-c->pos 0 5)) 6)
(check-expect (read-square BD2 (r-c->pos 7 0)) 8)

(define (read-square bd p)
  (list-ref bd p))


;; Board Pos Val -> Board
;; produce new board with val at given position
(check-expect (fill-square BD0 (r-c->pos 0 0) 1)
              (cons 1 (rest BD0)))

(define (fill-square bd p nv)
  (append (take bd p)
          (list nv)
          (drop bd (add1 p))))


;; ===================
;; Functions
;; ===================

;; Board -> Board or false
;; Returns a solution for a given board bd if any, otherwise false
;; Assume board is valid, no invalid entries in it
; (define (solve bd) false) ; stub

(check-expect (solve BD7) false)
(check-expect (solve BD4) BD4s)
(check-expect (solve BD5) BD5s)

#;
(define (solve bd)
  (cond [(trivial? base) (trivial bd)]
        [else (... solve (next bd))]))

#;
(define (solve bd)
  (local [(define (fn-for-bd bd)          ; Board -> Board or false
            (cond [(trivial? bd) (trivial bd)]
                  [else ((fn-for-lob (next-boards bd)))]))
          (define (fn-for-lob lob)        ; (Listof Board) -> Board or false
            (cond [(empty? lob) ...]
                  [else (... (fn-for-bd (first lob))
                             (fn-for-lob (rest lob)))]))]
    (fn-for-bd bd)))

(define (solve bd)
  (local [(define (fn-for-bd bd)          ; Board -> Board or false
            (cond [(solved? bd) bd]
                  [else (fn-for-lob (next-boards bd))]))
          (define (fn-for-lob lob)        ; (Listof Board) -> Board or false
            (cond [(empty? lob) false]
                  [else
                   (local [(define try (fn-for-bd (first lob)))]
                     (if (not (false? try))
                         try
                         (fn-for-lob (rest lob))))]))]
    (fn-for-bd bd)))


;; Board -> Boolean
;; Returns true if a board has been filled up, false otherwise
;; Assume only valid boards are passed by
; (define (solved? bd) false) ; stub

(check-expect (solved? BD4) false)
(check-expect (solved? BD5) false)
(check-expect (solved? BD4s) true)
(check-expect (solved? BD5s) true)

#;
(define (solved? bd)
  (cond [(empty? bd) ...]
        [else (... (first bd)
                   (solved? (rest bd)))]))
#;
(define (solved? bd)
  (cond [(empty? bd) true]
        [else (and (not (false? (first bd)))
                   (solved? (rest bd)))]))
#;
(define (solved? bd)
  (andmap (lambda (val) (not (false? val))) bd))

(define (solved? bd)
  (andmap number? bd))


;; Board -> (Listof Board)
;; Returns all valid next boards as a list of boards, excludes invalid ones
;; Finds next empty slot and fills it up with valid entries Natural[1, 9]
; (define (next-boards bd) empty) ; stub
(check-expect (next-boards BD7) empty)
(check-expect (next-boards BD0) (list (append (list 1) (rest BD0))
                                      (append (list 2) (rest BD0))
                                      (append (list 3) (rest BD0))
                                      (append (list 4) (rest BD0))
                                      (append (list 5) (rest BD0))
                                      (append (list 6) (rest BD0))
                                      (append (list 7) (rest BD0))
                                      (append (list 8) (rest BD0))
                                      (append (list 9) (rest BD0))))
(check-expect (next-boards BD2) (list (append (list 1) (list 4) (rest (rest BD2)))
                                      (append (list 1) (list 5) (rest (rest BD2)))
                                      (append (list 1) (list 6) (rest (rest BD2)))
                                      (append (list 1) (list 7) (rest (rest BD2)))
                                      (append (list 1) (list 8) (rest (rest BD2)))
                                      (append (list 1) (list 9) (rest (rest BD2)))))
(check-expect (next-boards BD6) (list (append (list 1) (rest BD6))
                                      (append (list 2) (rest BD6))
                                      (append (list 6) (rest BD6))
                                      (append (list 9) (rest BD6))))

(define (next-boards bd)
  (keep-valid (generate-boards bd (find-blank bd))))


;; Board -> Pos
;; Returns the Pos of the next available square
;; Assume board isn't solved or full - board has at least 1 blank
; (define (find-blank bd) 0) ; stub

; (check-expect (find-blank empty) empty) ; See (error ...)
(check-expect (find-blank BD0) 0)
(check-expect (find-blank BD1) 9)
(check-expect (find-blank BD2) 1)
(check-expect (find-blank BD3) 3)
(check-expect (find-blank BD7) 8)

#;
(define (find-blank bd)
  (local [(define (find-blank n bd)
            (cond [(empty? bd) (error "Board has no blank square")]
                  [(not (false? (read-square bd n))) n]
                  [else (find-blank (add1 n) (rest bd))]))]
    (find-blank 0 bd)))
#;
(define (find-blank bd)
  (cond [(empty? bd) (error "Board has no blank square")]
        [else (local [(define (find-blank bd pos)
                        (cond [(false? (read-square bd pos)) pos]
                              [else (find-blank bd (add1 pos))]))]
                (find-blank bd 0))]))
#;
(define (find-blank bd)
  (local [(define (find-blank bd pos)
            (cond [(false? (read-square bd pos)) pos]
                  [else (find-blank bd (add1 pos))]))]
    (find-blank bd 0)))

(define (find-blank bd)
  (if (false? (first bd))
      0
      (+ 1 (find-blank (rest bd)))))


;; Board Pos -> (Listof Board)
;; Generates 9 boards, each with Val 1 to 9 at the given position - Val is Natural[1, 9]
; (define (generate-boards bd p) empty) ; stub

(check-expect (generate-boards BD0 0) (list (append (list 1) (rest BD0))
                                            (append (list 2) (rest BD0))
                                            (append (list 3) (rest BD0))
                                            (append (list 4) (rest BD0))
                                            (append (list 5) (rest BD0))
                                            (append (list 6) (rest BD0))
                                            (append (list 7) (rest BD0))
                                            (append (list 8) (rest BD0))
                                            (append (list 9) (rest BD0))))

(check-expect (generate-boards BD5 1) (list (append (list (first BD5)) (list 1) (rest (rest BD5)))
                                            (append (list (first BD5)) (list 2) (rest (rest BD5)))
                                            (append (list (first BD5)) (list 3) (rest (rest BD5)))
                                            (append (list (first BD5)) (list 4) (rest (rest BD5)))
                                            (append (list (first BD5)) (list 5) (rest (rest BD5)))
                                            (append (list (first BD5)) (list 6) (rest (rest BD5)))
                                            (append (list (first BD5)) (list 7) (rest (rest BD5)))
                                            (append (list (first BD5)) (list 8) (rest (rest BD5)))
                                            (append (list (first BD5)) (list 9) (rest (rest BD5)))))
#;
(define (generate-boards bd pos)
  (local [(define (gen bd pos val)
            (cond [(> val 9) empty]
                  [else (cons (fill-square bd pos val)
                              (gen bd pos (add1 val)))]))]
    (gen bd pos 1)))

(define (generate-boards bd pos)
  (local [(define (build-one n)
            (fill-square bd pos (+ n 1)))]
    (build-list 9 build-one)))


;; (Listof Board) -> (Listof Board)
;; Removes invalid boards from a (Listof Board) - see Sudoku rules
; (define (keep-valid lob) empty) ; stub

(check-expect (keep-valid empty) empty)
(check-expect (keep-valid (list (append (list 1) (rest BD0))
                                (append (list 2) (rest BD0))
                                (append (list 3) (rest BD0))
                                (append (list 4) (rest BD0))
                                (append (list 5) (rest BD0))
                                (append (list 6) (rest BD0))
                                (append (list 7) (rest BD0))
                                (append (list 8) (rest BD0))
                                (append (list 9) (rest BD0)))) (list (append (list 1) (rest BD0))
                                                                     (append (list 2) (rest BD0))
                                                                     (append (list 3) (rest BD0))
                                                                     (append (list 4) (rest BD0))
                                                                     (append (list 5) (rest BD0))
                                                                     (append (list 6) (rest BD0))
                                                                     (append (list 7) (rest BD0))
                                                                     (append (list 8) (rest BD0))
                                                                     (append (list 9) (rest BD0))))
(check-expect (keep-valid (list (append (list (first BD5)) (list 1) (rest (rest BD5)))
                                (append (list (first BD5)) (list 2) (rest (rest BD5)))
                                (append (list (first BD5)) (list 3) (rest (rest BD5)))
                                (append (list (first BD5)) (list 4) (rest (rest BD5)))
                                (append (list (first BD5)) (list 5) (rest (rest BD5)))
                                (append (list (first BD5)) (list 6) (rest (rest BD5)))
                                (append (list (first BD5)) (list 7) (rest (rest BD5)))
                                (append (list (first BD5)) (list 8) (rest (rest BD5)))
                                (append (list (first BD5)) (list 9) (rest (rest BD5))))) (list (append (list (first BD5)) (list 2) (rest (rest BD5)))
                                                                                               (append (list (first BD5)) (list 3) (rest (rest BD5)))))

(define (keep-valid lob)
  (filter valid-board? lob))


;; Board -> Boolean
;; Returns true if the board is valid, otherwise false
;; A board is valid if it does not contain any duplicate Val in any of its Unit
; (define (valid-board? bd) false) ; stub

(check-expect (valid-board? BD0) true)
(check-expect (valid-board? BD4) true)
(check-expect (valid-board? BD5) true)
(check-expect (valid-board? BD6) true)
(check-expect (valid-board? BD7) true)
(check-expect (valid-board? BD8) false)  ; invalid for columns
(check-expect (valid-board? BD9) false)  ; invalid for row
(check-expect (valid-board? BD10) false) ; invalid for boxes

(define (valid-board? bd)
  (local [(define (valid-units? lou)       ; (Listof Unit) -> Boolean
            (andmap valid-unit? lou))
          (define (valid-unit? lop)        ; (Listof Pos -> Boolean
            (not (duplicates? (filter number? (map read lop)))))
          (define (read pos)               ; Pos -> Val
            (read-square bd pos))]
    (valid-units? UNITS)))


;; (Listof Val) -> Boolean
;; Returns true if there are any duplicates in the (Listof Val), false otherwise
;; Assume (Listof Val) contains only numbers
; (define (duplicates? lov) false) ; stub

(check-expect (duplicates? empty) false)
(check-expect (duplicates? (list 2 2)) true)
(check-expect (duplicates? (list 6 7 8 9)) false)
(check-expect (duplicates? (list 1 2 3 4 5 6 7 8 9)) false)
(check-expect (duplicates? (list 1 2 3 2 5 6 7 8 9)) true)
(check-expect (duplicates? (list 4 2 3 5 4)) true)

(define (duplicates? vals)
  (cond [(empty? vals) false]
        [else (or (find? (first vals) (rest vals)) ; we could use member instead of find?
                  (duplicates? (rest vals)))]))


;; Val (ListofVal) -> Boolean
;; Returns true if the given val is found within the given (Listof Val)
; (define (find? n lon) false) ; stub

(check-expect (find? 0 empty) false)
(check-expect (find? 1 (list 2 3 4)) false)
(check-expect (find? 3 (list 3)) true)
(check-expect (find? 7 (list 2 3 4 7 9)) true)

(define (find? n lon)
  (cond [(empty? lon) false]
        [else (or (= n (first lon))
                  (find? n (rest lon)))]))
