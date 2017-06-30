(require racket/list) ;gets list-ref, take and drop

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


;; =================
;; Data definitions
;; =================

;; Val is Natural[1, 9]

;; Board is (listof Val|false)   that is 81 elements long
;; interp.
;;  Visually a board is a 9x9 array of squares, where each square
;;  has a row and column number (r, c).  But we represent it as a
;;  single flat list, in which the rows are layed out one after
;;  another in a linear fashion. (See interp. of Pos below for how
;;  we convert back and forth between (r, c) and position in a board.)

;; Pos is Natural[0, 80]
;; interp.
;;  the position of a square on the board, for a given p, then
;;    - the row    is (quotient p 9)
;;    - the column is (remainder p 9)


;; Convert 0-based row and column to Pos
(define (r-c->pos r c) (+ (* r 9) c))  ;helpful for writing tests


;; Unit is (listof Pos) of length 9
;; interp.
;;  The position of every square in a unit. There are
;;  27 of these for the 9 rows, 9 columns and 9 boxes.


;; =================
;; Constants
;; =================

(define ALL-VALS (list 1 2 3 4 5 6 7 8 9))

(define B false) ;B stands for blank

(define BD1
  (list B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B))

(define BD2
  (list 1 2 3 4 5 6 7 8 9
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B))

(define BD3
  (list 1 B B B B B B B B
        2 B B B B B B B B
        3 B B B B B B B B
        4 B B B B B B B B
        5 B B B B B B B B
        6 B B B B B B B B
        7 B B B B B B B B
        8 B B B B B B B B
        9 B B B B B B B B))

(define BD4                ;easy
  (list 2 7 4 B 9 1 B B 5
        1 B B 5 B B B 9 B
        6 B B B B 3 2 8 B
        B B 1 9 B B B B 8
        B B 5 1 B B 6 B B
        7 B B B 8 B B B 3
        4 B 2 B B B B B 9
        B B B B B B B 7 B
        8 B B 3 4 9 B B B))

(define BD4s               ;solution to 4
  (list 2 7 4 8 9 1 3 6 5
        1 3 8 5 2 6 4 9 7
        6 5 9 4 7 3 2 8 1
        3 2 1 9 6 4 7 5 8
        9 8 5 1 3 7 6 4 2
        7 4 6 2 8 5 9 1 3
        4 6 2 7 5 8 1 3 9
        5 9 3 6 1 2 8 7 4
        8 1 7 3 4 9 5 2 6))

(define BD5                ;hard
  (list 5 B B B B 4 B 7 B
        B 1 B B 5 B 6 B B
        B B 4 9 B B B B B
        B 9 B B B 7 5 B B
        1 8 B 2 B B B B B
        B B B B B 6 B B B
        B B 3 B B B B B 8
        B 6 B B 8 B B B 9
        B B 8 B 7 B B 3 1))

(define BD5s               ;solution to 5
  (list 5 3 9 1 6 4 8 7 2
        8 1 2 7 5 3 6 9 4
        6 7 4 9 2 8 3 1 5
        2 9 6 4 1 7 5 8 3
        1 8 7 2 3 5 9 4 6
        3 4 5 8 9 6 1 2 7
        9 2 3 5 4 1 7 6 8
        7 6 1 3 8 2 4 5 9
        4 5 8 6 7 9 2 3 1))

(define BD6                ;hardest ever? (Dr Arto Inkala)
  (list B B 5 3 B B B B B  ; 1 2 6 9
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

(define BD0a                ; invalid board
  (list 2 7 4 4 9 1 B B 5
        1 B B 5 B B B 9 B
        6 B B B B 3 2 8 B
        B B 1 9 B B B B 8
        B B 5 1 B B 6 B B
        7 B B B 8 B B B 3
        4 B 2 B B B B B 9
        B B B B B B B 7 B
        8 B B 3 4 9 B B B))

(define BD0b                ; invalid board
  (list 2 7 4 B 9 1 B B 5
        1 B B 5 B B B 9 B
        6 B B B B 3 2 8 B
        B B 1 9 B B B B 8
        B B 5 1 B B 6 B B
        7 B B B 8 B B B 3
        4 B 2 B 9 B B B 9
        B B B B B B B 7 B
        8 B B 3 4 9 B B B))

(define BD0c                ; invalid board
  (list 2 7 4 B 9 1 B B 5
        1 B B 5 B B B 9 B
        6 B B B B 3 2 8 B
        B B 1 9 B B B B 8
        6 B 5 1 B B 6 B B
        7 B B B 8 B B B 3
        4 B 2 B B B B B 9
        B B B B B B B 7 B
        8 B B 3 4 9 B B B))


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


;; =================
;; Functions
;; =================

;; Board -> Board or false
;; Given a starting board, returns a solution for it, or false if the board has no solution
;; Assume: the given board must be a valid problem
; (define (solve bd) false) ; stub

(check-expect (solve BD4) BD4s)
(check-expect (solve BD5) BD5s)
(check-expect (solve BD7) false)

;; template merging
(define (solve bd)
  (local [(define (solve--bd bd)
            (if (solved? bd)
                bd
                (solve--lobd (next-boards bd))))

          (define (solve--lobd lobd)
            (cond [(empty? lobd) false]
                  [else
                   (local [(define try (solve--bd (first lobd)))] ; try solve first sub-board
                     (if (not (false? try))
                         try
                         (solve--lobd (rest lobd)) ; (listof board)
                         ))]))]
    (solve--bd bd)))


;; Board -> Boolean
;; Returns true if a given board is solved (filled), false otherwise
; (define (solved? bd) false) ; stub

(check-expect (solved? BD4) false)
(check-expect (solved? BD4s) true)
(check-expect (solved? BD5) false)
(check-expect (solved? BD5s) true)
(check-expect (solved? BD7) false)

#; ;; first attempt
(define (solved? bd)
  (cond [(empty? bd) true]
        [else
         (and (not (false? (first bd)))
              (solved? (rest bd)))]))

;; Simplified solution
(define (solved? bd)
  (andmap number? bd))


;; Board -> (listof Board)
;; Given a board, returns a list of subsequent valid boards
;; That means, it finds the next available empty square and fills it up with Natural [1, 9]
;; Doing so it discards invalid boards and keeps only valid boards
; (define (next-boards bd) empty) ; stub

(check-expect (next-boards BD7) empty)
(check-expect (next-boards BD1) (list (cons 1 (rest BD1))
                                      (cons 2 (rest BD1))
                                      (cons 3 (rest BD1))
                                      (cons 4 (rest BD1))
                                      (cons 5 (rest BD1))
                                      (cons 6 (rest BD1))
                                      (cons 7 (rest BD1))
                                      (cons 8 (rest BD1))
                                      (cons 9 (rest BD1))))
(check-expect (next-boards BD5) (list (cons 5 (cons 2 (rest (rest BD5))))
                                      (cons 5 (cons 3 (rest (rest BD5))))))
(check-expect (next-boards BD6) (list (cons 1 (rest BD6))
                                      (cons 2 (rest BD6))
                                      (cons 6 (rest BD6))
                                      (cons 9 (rest BD6))))

(define (next-boards bd)
  (keep-valid-boards (fill-blank (first-blank bd) bd)))

;; Board -> Pos
;; Finds the next available position in a board, returns false if none is found
;; Assume: the board has at least one blank square
; (define (first-blank bd) 0) ; stub

(check-expect (first-blank BD1) 0)
(check-expect (first-blank BD4) 3)
(check-expect (first-blank BD5) 1)
(check-expect (first-blank BD6) 0)

#; ;; First attempt
(define (first-blank bd)
  (cond [(empty? bd) (error "Invalid (empty) board passed to first-blank")]
        [else (local [(define (sub bd n)
                        (cond [(false? (first bd)) n]
                              [else (sub (rest bd) (add1 n))]))]
                (sub bd 0))]))

;; Refactor without local (error checking not necessary due to data domain)
(define (first-blank bd)
  (if (false? (first bd)) 0
      (+ 1 (first-blank (rest bd)))))


;; Pos Board -> (listof Board)
;; Given a position on a board, and a board, returns a list of Board
;; where the position is Natural [1, 9]
; (define (fill-blank p bd) empty) ; stub

(check-expect (fill-blank 0 BD1) (list
                                  (cons 1 (rest BD1))
                                  (cons 2 (rest BD1))
                                  (cons 3 (rest BD1))
                                  (cons 4 (rest BD1))
                                  (cons 5 (rest BD1))
                                  (cons 6 (rest BD1))
                                  (cons 7 (rest BD1))
                                  (cons 8 (rest BD1))
                                  (cons 9 (rest BD1))))

(check-expect (fill-blank 1 BD3) (list
                                  (cons 1 (cons 1 (rest (rest BD3))))
                                  (cons 1 (cons 2 (rest (rest BD3))))
                                  (cons 1 (cons 3 (rest (rest BD3))))
                                  (cons 1 (cons 4 (rest (rest BD3))))
                                  (cons 1 (cons 5 (rest (rest BD3))))
                                  (cons 1 (cons 6 (rest (rest BD3))))
                                  (cons 1 (cons 7 (rest (rest BD3))))
                                  (cons 1 (cons 8 (rest (rest BD3))))
                                  (cons 1 (cons 9 (rest (rest BD3))))))

#; ;; First attempt
(define (fill-blank p bd)
  (local [(define (sub p bd n)
            (cond [(> n 9) empty]
                  [else (cons (fill-square bd p n)
                              (sub p bd (add1 n)))]))]
    (sub p bd 1)))

;; Refactor
(define (fill-blank p bd)
  (local [(define (sub n) (fill-square bd p (add1 n)))]
    (build-list 9 sub)))


;; (listof Board) -> (listof Board)
;; Removes invalid boards from a (listof Board)
; (define (keep-valid-boards lobd) empty) ; stub

(check-expect (keep-valid-boards (list BD0b BD4 BD5)) (list BD4 BD5))
(check-expect (keep-valid-boards (list BD4 BD5 BD0a)) (list BD4 BD5))
(check-expect (keep-valid-boards (list BD4 BD5 BD6)) (list BD4 BD5 BD6))

(define (keep-valid-boards lobd)
  (filter valid-board? lobd))


;; Board -> Boolean
;; Returns true no unit on the board contains the same value/natural, false otherwise
; !!!
; (define (valid-board? bd) false) ; stub

(check-expect (valid-board? BD0a) false)
(check-expect (valid-board? BD0b) false)
(check-expect (valid-board? BD0c) false)
(check-expect (valid-board? BD4) true)
(check-expect (valid-board? BD5) true)
(check-expect (valid-board? BD6) true)

(define (valid-board? bd)
  (local [(define (valid-units? lou)               ; (listof Unit) -> Boolean
            (andmap valid-unit? lou))

          (define (valid-unit? u)                  ; Unit -> Boolean
            (not (duplicated?
                  (remove-blanks
                   (read-unit u)))))

          (define (read-unit u)                    ; Unit -> (listof Val|false)
            (map read-pos u))

          (define (read-pos p)                     ; Pos -> Val|false
            (read-square bd p))

          (define (remove-blanks lovf)             ; (listof Val|false) -> (listof Val)
            (filter number? lovf))

          (define (duplicated? lov)                ; (listof Val) -> Boolean
            (cond [(empty? lov) false]
                  [else
                   (or (member (first lov) (rest lov))
                        (duplicated? (rest lov)))]))]

          (valid-units? UNITS)))


;; Board Pos -> Val or false
;; Produce value at given position on board.
(check-expect (read-square BD2 (r-c->pos 0 5)) 6)
(check-expect (read-square BD3 (r-c->pos 7 0)) 8)

(define (read-square bd p)
  (list-ref bd p))


;; Board Pos Val -> Board
;; produce new board with val at given position
(check-expect (fill-square BD1 (r-c->pos 0 0) 1)
              (cons 1 (rest BD1)))

(define (fill-square bd p nv)
  (append (take bd p)
          (list nv)
          (drop bd (add1 p))))
