(require 2htdp/image)
(require 2htdp/universe)

;; =============================
;; Constants
;; =============================

(define TANK (triangle 20 "solid" "red")) ; Player
(define SVILL (circle 8 "solid" "red")) ; Space Villain
(define EBEAM (rectangle 2 10 "solid" "teal")) ; Energy Beam

(define PDX 5)
(define EDY -20)
(define VDX -2)
(define VDY 1)
(define VDIR 1)

(define WIDTH 400)
(define HEIGHT 500)
(define BGCOLOR "black")
(define MTS (overlay (rectangle WIDTH HEIGHT "solid" BGCOLOR)
                     (empty-scene WIDTH HEIGHT)))

(define REF (rectangle 0 0 "solid" "white")) ; block used to position each Sprite via offset
(define GAMEOVER (text "GAME OVER" 24 "white"))
(define REFURBISH 11) ; number of Space Villains below which the game needs more of them


;; =============================
;; Data Definitions
;; =============================

; (define-struct posn (x y))
;; Posn is (make-posn Natural[0,WIDTH] Natural[0,HEIGHT])
;; - x is the X Coordinate
;; - y is the Y Coordinate

(define POS1 (make-posn 100 100))
(define POS2 (make-posn 200 200))

#;
(define (fn-for-posn p)
  (... (posn-x p)
       (posn-y p)))

;; Template rules used:
;; - Compound Data with 2 fields
;; -- x             Natural[0,WIDTH]
;; -- y             Natural[0,HEIGHT]


;; Type is one of:
;; - "P"
;; - "E"
;; - "V"
;; - "T"
;; The type of a Sprite on stage, Player, Space Villain, Energy Beam, or Text

(define P "P") ; Player
(define V "V") ; Space Villain
(define E "E") ; Energy Beam
(define T "T") ; Text

#;
(define (fn-for-type type)
  (cond [(string=? type P) (...)]
        [(string=? type E) (...)]
        [(string=? type V) (...)]))

;; Template rules used:
;; - Atomic Distinct   "P"   String
;; - Atomic Distinct   "V"   String
;; - Atomic Distinct   "E"   String


(define-struct sprite (type x y dx dy img))
;; Sprite is (make-sprite Type Natural[0,WIDTH] Natural[0,HEIGHT] Natural Natural Image)
;; - type is Type
;; -- "P"   is Player
;; -- "V"   is Space Villain
;; -- "E"   is Energy Beam
;; - x is the X Coordinate
;; - y is the Y Coordinate
;; - dx is the lateral speed
;; - dy is the vertical speed
;; - img is the visual representation of the Sprite

;; For example of Sprites see Initial State

#;
(define (fn-for-sprite sprite)
  (... (sprite-type sprite)
       (sprite-x sprite)
       (sprite-y sprite)
       (sprite-dx sprite)
       (sprite-dy sprite)
       (sprite-img sprite)))

;; Template rules used:
;; - Compound with 7 fields
;; -- type    Type
;; -- x       Natural[0, WIDTH]
;; -- y       Natural[0, HEIGHT]
;; -- dx      Natural
;; -- dy      Natural
;; -- img     Image


;; State is one of:
;; - empty
;; - (cons Sprite State)
;; Current State of the Game, an arbitrary sized data with sub-sets

;; See below for Initial State and Dummy State

#;
(define (fn-for-state state)
  (cond [(empty? state) (...)]
        [else (... (fn-for-sprite (first state))
                   (fn-for-state (rest state)))]))

;; Template rules used:
;; - One of:
;; -- Atomic Distinct                 empty
;; -- Atomic Distinct                 false
;; -- Compound Data                   (cons true State)
;; -- Compound Data                   (cons Sprite State)
;; - Self-Reference                   State
;; - Reference                        Sprite


;; =============================
;; Initial State
;; =============================

; player
(define P0 (make-sprite P (/ WIDTH 2) (- HEIGHT (image-height TANK)) PDX 0 TANK))         ; center
(define P1 (make-sprite P (- (/ WIDTH 2) 100) (- HEIGHT (image-height TANK)) PDX 0 TANK)) ; left
(define P2 (make-sprite P (+ (/ WIDTH 2) 100) (- HEIGHT (image-height TANK)) PDX 0 TANK)) ; right

; example of Energy Beam
(define EB0 (make-sprite E (/ WIDTH 2) (/ HEIGHT 2) 0 EDY EBEAM))         ; center
(define EB1 (make-sprite E (- (/ WIDTH 2) 100) (/ HEIGHT 2) 0 EDY EBEAM)) ; left
(define EB2 (make-sprite E (+ (/ WIDTH 2) 100) (/ HEIGHT 2) 0 EDY EBEAM)) ; right

; space villains first row
(define SV1 (make-sprite V 40 40 VDX VDY SVILL))
(define SV2 (make-sprite V 80 40 VDX VDY SVILL))
(define SV3 (make-sprite V 120 40 VDX VDY SVILL))
(define SV4 (make-sprite V 160 40 VDX VDY SVILL))
(define SV5 (make-sprite V 200 40 VDX VDY SVILL))
(define SV6 (make-sprite V 240 40 VDX VDY SVILL))
(define SV7 (make-sprite V 280 40 VDX VDY SVILL))
(define SV8 (make-sprite V 320 40 VDX VDY SVILL))
(define SV9 (make-sprite V 360 40 VDX VDY SVILL))
(define SVROW1 (list SV1 SV2 SV3 SV4 SV5 SV6 SV7 SV8 SV9))

; space villains second row
(define SV10 (make-sprite V 40 80 VDX VDY SVILL))
(define SV11 (make-sprite V 80 80 VDX VDY SVILL))
(define SV12 (make-sprite V 120 80 VDX VDY SVILL))
(define SV13 (make-sprite V 160 80 VDX VDY SVILL))
(define SV14 (make-sprite V 200 80 VDX VDY SVILL))
(define SV15 (make-sprite V 240 80 VDX VDY SVILL))
(define SV16 (make-sprite V 280 80 VDX VDY SVILL))
(define SV17 (make-sprite V 320 80 VDX VDY SVILL))
(define SV18 (make-sprite V 360 80 VDX VDY SVILL))
(define SVROW2 (list SV10 SV11 SV12 SV13 SV14 SV15 SV16 SV17 SV18))

;; game over text
(define END (make-sprite T (/ WIDTH 2) (/ HEIGHT 2) 0 0 GAMEOVER))

; initial state, no beams yet
(define ISTATE (append (list P0) SVROW1 SVROW2))

; dummy state, used for testing
(define DSTATE (list P0 SV1 SV2 SV3 EB1))


;; =============================
;; Universe
;; =============================

;; State -> State
;; Launch with (run 0)
(define (run x)
  (main ISTATE))

(define (main state)
  (big-bang state                   ; State
            (on-tick   tock)        ; State -> State
            (to-draw   render)      ; State -> Image
            (on-key    handle-keys) ; State KeyEvent -> State
            ))


;; =============================
;; Functions
;; =============================

;; State -> State
;; Updates the state

(define (tock state)
  (cond [(empty? state) empty]
        [(endgame? state) (cons END state)]
        [(refurbish? state) (move-sprites (collisions (refurbish state)))]
        [else (move-sprites (collisions state))]))


;; ListOfSprite State -> State
;; Refurbish the current State with new fellas
(define (refurbish state)
  (append (list SV2 SV3 SV4 SV5 SV6 SV7 SV8 SV11 SV12 SV13 SV14 SV15 SV16 SV17) state))


;; State -> State
;; Updates the position of all Sprite in the current State
; (define (move-sprites state) empty) ; stub

(check-expect (move-sprites empty) empty)
(check-expect (move-sprites (list P0)) (list (move-sprite P0)))
(check-expect (move-sprites (list SV1)) (list (move-sprite SV1)))
(check-expect (move-sprites (list EB1)) (list (move-sprite EB1)))
(check-expect (move-sprites DSTATE) (list (move-sprite P0)
                                          (move-sprite SV1)
                                          (move-sprite SV2)
                                          (move-sprite SV3)
                                          (move-sprite EB1)))

(define (move-sprites state)
  (cond [(empty? state) empty]
        [else (cons (move-sprite (first state))
                    (move-sprites (rest state)))]))


;; Sprite -> Sprite
;; Updates the current sprite
; (define (move-sprite sprite) sprite) ; stub

(check-expect (move-sprite P0) (make-sprite
                                (sprite-type P0)
                                (+ (sprite-x P0) (sprite-dx P0))
                                (+ (sprite-y P0) (sprite-dy P0))
                                (sprite-dx P0)
                                (sprite-dy P0)
                                (sprite-img P0)))
(check-expect (move-sprite SV1) (make-sprite
                                 (sprite-type SV1)
                                 (+ (sprite-x SV1) (sprite-dx SV1))
                                 (+ (sprite-y SV1) (sprite-dy SV1))
                                 (sprite-dx SV1)
                                 (sprite-dy SV1)
                                 (sprite-img SV1)))
(check-expect (move-sprite EB1) (make-sprite
                                 (sprite-type EB1)
                                 (+ (sprite-x EB1) (sprite-dx EB1))
                                 (+ (sprite-y EB1) (sprite-dy EB1))
                                 (sprite-dx EB1)
                                 (sprite-dy EB1)
                                 (sprite-img EB1)))

(define (move-sprite sprite)
  (make-sprite (sprite-type sprite)
               (+ (sprite-x sprite) (sprite-dx sprite))
               (+ (sprite-y sprite) (sprite-dy sprite))
               (sprite-dx sprite)
               (sprite-dy sprite)
               (sprite-img sprite)))


;; State -> Image
;; Renders the State
; (define (render state) empty-image) ; stub

(check-expect (render empty) MTS)
(check-expect (render DSTATE) (place-images
                               (get-sprites DSTATE)
                               (get-posns DSTATE)
                               MTS))

(define (render state)
  (cond [(empty? state) MTS]
        [else (place-images
               (get-sprites state)
               (get-posns state)
               MTS)]))


;; State -> ListOfImages
;; Given a State returns a list of all its Images in the same order
;; !!!
; (define (get-sprites state) empty) ; stub

(check-expect (get-sprites empty) empty)
(check-expect (get-sprites (list P0 SV1)) (list (sprite-img P0) (sprite-img SV1)))
(check-expect (get-sprites DSTATE) (list
                                    (sprite-img P0)
                                    (sprite-img SV1)
                                    (sprite-img SV2)
                                    (sprite-img SV3)
                                    (sprite-img EB1)))

(define (get-sprites state)
  (cond [(empty? state) empty]
        [else (cons (sprite->image (first state))
                    (get-sprites (rest state)))]))


;; State -> ListOfPosns
;; Given a State returns a list of the coordinates of all Sprites as Posns
; (define (get-posns state) empty) ; stub

(check-expect (get-posns empty) empty)
(check-expect (get-posns (list P0 SV1)) (list
                                         (make-posn (sprite-x P0) (sprite-y P0))
                                         (make-posn (sprite-x SV1) (sprite-y SV1))))
(check-expect (get-posns DSTATE) (list
                                  (make-posn (sprite-x P0) (sprite-y P0))
                                  (make-posn (sprite-x SV1) (sprite-y SV1))
                                  (make-posn (sprite-x SV2) (sprite-y SV2))
                                  (make-posn (sprite-x SV3) (sprite-y SV3))
                                  (make-posn (sprite-x EB1) (sprite-y EB1))))

(define (get-posns state)
  (cond [(empty? state) empty]
        [else (cons (sprite->posn (first state))
                    (get-posns (rest state)))]))


;; State KeyEvent -> State
;; Handles player inputs via Keyboard
; (define (handle-keys state key) state) ; stub

(check-expect (handle-keys ISTATE " ") (fire-ebeam ISTATE P0))
(check-expect (handle-keys (list EB0 P1 SV1 SV2) " ") (fire-ebeam (list EB0 P1 SV1 SV2) P1))
(check-expect (handle-keys ISTATE "left") (update-player ISTATE))
(check-expect (handle-keys ISTATE "right") (update-player ISTATE))

(define (handle-keys state key)
  (cond [(key=? key " ") (fire-ebeam state (get-player state))]
        [(key=? key "left") (update-player state)]
        [(key=? key "right") (update-player state)]
        [else state]))


;; State -> State
;; Adds an Energy Beam at proper x,y coordinate into the current State
; (define (fire-ebeam state player) state) ; stub

(check-expect (fire-ebeam (list P0) P0) (list (make-sprite E
                                                           (+ (sprite-x P0) (/ (image-width (sprite-img P0)) 2))
                                                           (- (sprite-y P0) (image-height (sprite-img P0)))
                                                           0  EDY EBEAM)
                                              P0))
(check-expect (fire-ebeam (list EB0 P1 SV2) P1) (list (make-sprite E
                                                                   (+ (sprite-x P1) (/ (image-width (sprite-img P1)) 2))
                                                                   (- (sprite-y P1) (image-height (sprite-img P1)))
                                                                   0  EDY EBEAM)
                                                      EB0 P1 SV2))

(define (fire-ebeam state player)
  (cons (make-sprite E
                     (+ (sprite-x player) (/ (image-width (sprite-img player)) 2))
                     (- (sprite-y player) (image-height (sprite-img player)))
                     0  EDY EBEAM)
        state))


;; State -> State
;; Updates the direction of movement of the Player, left/right
; (define (update-player state n) state) ; stub

(check-expect (update-player (list EB1 P1 SV1)) (list EB1
                                                      (make-sprite P
                                                                   (sprite-x P1)
                                                                   (sprite-y P1)
                                                                   (* -1 (sprite-dx P1))
                                                                   (sprite-dy P1)
                                                                   TANK)
                                                      SV1))
(check-expect (update-player (list SV2 P2 EB0)) (list SV2
                                                      (make-sprite P
                                                                   (sprite-x P2)
                                                                   (sprite-y P2)
                                                                   (* -1 (sprite-dx P2))
                                                                   (sprite-dy P2)
                                                                   TANK)
                                                      EB0))

(define (update-player state)
  (cond [(empty? state) empty]
        [(player? (first state)) (cons (flip-sprite (first state)) (rest state))]
        [else (cons (first state) (update-player (rest state)))]))


;; =============================
;; Collisions
;; =============================

;; State -> State
;; Updates the State depending on various Sprites' collisions
(define (collisions state)
  (bounce-sprites (remove-sprites state)))


;; State -> State
;; Removes Sprites from State if they collide against an other Sprite
; (define (remove-sprites state) state) ; stub

(check-expect (remove-sprites DSTATE) DSTATE)
(check-expect (remove-sprites ISTATE) ISTATE)
(check-expect (remove-sprites (list P2 (make-ebeam 70 0) SV3)) (list P2 SV3))

(define (remove-sprites state)
  (remove-villains (remove-ebeams state)))


;; State -> State
;; Removes from State Energy Beams that overshot the stage (height = 0)
; (define (remove-ebeams state) state) ;stub

(check-expect (remove-ebeams empty) empty)
(check-expect (remove-ebeams DSTATE) DSTATE)
(check-expect (remove-ebeams (list P0 SV5
                                   (make-ebeam 200 200)
                                   (make-ebeam 150 0) SV7))
              (list P0 SV5 (make-ebeam 200 200) SV7))

(define (remove-ebeams state)
  (cond [(empty? state) empty]
        [(and (ebeam? (first state)) (overshot? (first state)))
         (remove-ebeams (rest state))]
        [else (cons (first state) (remove-ebeams (rest state)))]))


;; State -> State
;; Removes Space Villains that collided with an Energy Beam
; (define (remove-villains villains) state) ; stub

(check-expect (remove-villains empty) empty)
(check-expect (remove-villains ISTATE) ISTATE)

(define (remove-villains state)
  (remove-villains-helper state (get-ebeams state)))

(check-expect (remove-villains-helper empty empty) empty)
(check-expect (remove-villains-helper empty (list EB0 EB1)) empty)
(check-expect (remove-villains-helper DSTATE empty) DSTATE)

(define (remove-villains-helper state ebeams)
  (cond [(empty? state) empty]
        [(or (ebeam? (first state)) (player? (first state))) (cons (first state) (remove-villains-helper (rest state) ebeams))]
        [else (if (collide-with-any? (first state) ebeams)
                  (remove-villains-helper (rest state) ebeams)
                  (cons (first state) (remove-villains-helper (rest state) ebeams)))]))


;; State -> State
;; Bounces Sprites and flip their directions when they touch the left/right edges
; (define (bounce-sprites state) state) ; stub

(check-expect (bounce-sprites DSTATE) DSTATE)
(check-expect (bounce-sprites (list EB0
                                    (make-sprite P WIDTH (- HEIGHT (image-height TANK)) PDX 0 TANK)
                                    SV1 SV6))
              (list EB0 (make-sprite P WIDTH (- HEIGHT (image-height TANK)) (* -1 PDX) 0 TANK) SV1 SV6))
(check-expect (bounce-sprites (list SV7
                                    (make-sprite P 0 (- HEIGHT (image-height TANK)) PDX 0 TANK)
                                    SV12 EB2))
              (list SV7 (make-sprite P 0 (- HEIGHT (image-height TANK)) (* -1 PDX) 0 TANK) SV12 EB2))


(define (bounce-sprites state)
  ; helper fn receives one-time bounce-group result, otherwise weird things happen
  (bounce-sprites-helper state (bounce-group? (get-villains state))))

(define (bounce-sprites-helper state flip-villain)
  (cond [(empty? state) empty]
        [(and (player? (first state)) (edges? (first state)))
         (cons (flip-sprite (first state)) (bounce-sprites (rest state)))]
        [(and (villain? (first state)) flip-villain)
         (cons (flip-sprite (first state)) (bounce-sprites-helper (rest state) flip-villain))]
        [else (cons (first state) (bounce-sprites-helper (rest state) flip-villain))]))


;; =============================
;; Booleans
;; =============================

;; Sprite -> Boolean
;; Given a Sprite, returns true if the sprite has Type P, otherwise false
; (define (player? sprite) false) ; stub

(check-expect (player? P0) true)
(check-expect (player? P1) true)
(check-expect (player? P2) true)
(check-expect (player? SV1) false)
(check-expect (player? SV2) false)
(check-expect (player? EB1) false)

(define (player? sprite)
  (string=? P (sprite-type sprite)))


;; Sprite -> Boolean
;; Given a Sprite, returns true if the sprite has Type V, otherwise false
; (define (villain? sprite) false) ; stub

(check-expect (villain? P0) false)
(check-expect (villain? P1) false)
(check-expect (villain? SV3) true)
(check-expect (villain? SV8) true)
(check-expect (villain? SV12) true)
(check-expect (villain? EB0) false)

(define (villain? sprite)
  (string=? V (sprite-type sprite)))


;; Sprite -> Boolean
;; Given a Sprite, returns true if the sprite has Type E, otherwise false
; (define (ebeam? sprite) false) ; stub

(check-expect (ebeam? P0) false)
(check-expect (ebeam? P1) false)
(check-expect (ebeam? SV12) false)
(check-expect (ebeam? EB0) true)
(check-expect (ebeam? EB2) true)

(define (ebeam? sprite)
  (string=? E (sprite-type sprite)))


;; State -> Boolean
;; Returns true if any of the Sprites in the list is close to the left/right edge of the screen
; (define (bounce-group? state) false) ; stub

(check-expect (bounce-group? empty) false)
(check-expect (bounce-group? DSTATE) false)
(check-expect (bounce-group? ISTATE) false)
(check-expect (bounce-group? (list SV1 SV2
                                   (make-villain 0 100) SV8)) true)
(check-expect (bounce-group? (list SV7
                                   (make-villain WIDTH 400) SV9 SV12)) true)

(define (bounce-group? state)
  (cond [(empty? state) false]
        [(edges? (first state)) true]
        [else (bounce-group? (rest state))]))


;; Sprite -> Boolean
;; Returns true if the Sprite is on the left/right edges
; (define (edges? sprite) false) ; stub

(check-expect (edges? P0) false)
(check-expect (edges? SV7) false)
(check-expect (edges? EB1) false)
(check-expect (edges? (make-villain 0 100)) true)
(check-expect (edges? (make-player WIDTH 100)) true)

(define (edges? sprite)
  (or (<= (- (sprite-x sprite) (image-width (sprite-img sprite))) 0)
      (>= (+ (sprite-x sprite) (image-width (sprite-img sprite))) WIDTH)))


;; Sprite -> Boolean
;; Returns true if a Sprite went over the upper edge of the screen
; (define (overshot? sprite) false) ; stub

(check-expect (overshot? EB0) false)
(check-expect (overshot? (make-ebeam 200 0)) true)

(define (overshot? sprite)
  (<= (sprite-y sprite) 0))


;; Sprite State -> Boolean
;; Returns true is the given Sprite collides with any of the sprites into State
; (define (collide-with-any? sprite ebeams) false) ; stub

(check-expect (collide-with-any? (make-villain 200 200) empty) false)
(check-expect (collide-with-any? SV1 (list EB0 EB1)) false)
(check-expect (collide-with-any? (make-villain 200 200) (list EB0 EB1 (make-ebeam 200 200))) true)

(define (collide-with-any? sprite ebeams)
  (cond [(empty? ebeams) false]
        [else (if (collide? sprite (first ebeams))
                  true
                  (collide-with-any? sprite (rest ebeams)))]))


;; Sprite Sprite -> Boolean
;; Returns true if the two given sprites collides, otherwise false
; (define (collide? s1 s2) true) ; stub

(check-expect (collide? SV1 EB0) false)
(check-expect (collide? (make-villain 200 200) (make-ebeam 200 200)) true)
(check-expect (collide? (make-villain 140 140) (make-ebeam 145 145)) true)
(check-expect (collide? (make-villain 140 140) (make-ebeam 135 135)) true)

(define (collide? s1 s2)
  (and
   (and (<= (- (sprite-x s1) (/ (image-width (sprite-img s1)) 2)) (sprite-x s2))
        (>= (+ (sprite-x s1) (/ (image-width (sprite-img s1)) 2)) (sprite-x s2)))
   (and (<= (- (sprite-y s1) (/ (image-height (sprite-img s1)) 2)) (sprite-y s2))
        (>= (+ (sprite-y s1) (/ (image-height (sprite-img s1)) 2)) (sprite-y s2)))))


;; State -> Boolean
;; Returns true if end game conditions are met, false otherwise
; (define (endgame? state) false) ; stub

(check-expect (endgame? ISTATE) false)
(check-expect (endgame? DSTATE) false)
(check-expect (endgame? (list P0 (make-villain 200 HEIGHT))) true)

(define (endgame? state)
  (cond [(empty? state) true]
        [(villains-win? (get-villains state)) true]
        [else false]))


;; State -> Boolean
;; Returns true if at any given time any of the villains reaches the bottom of the screen, false otherwise
; (define (villains-win? villains) false) ; stub

(check-expect (villains-win? empty) false)
(check-expect (villains-win? (list SV1 SV2 SV3)) false)
(check-expect (villains-win? (list SV5 (make-villain 50 HEIGHT))) true)

(define (villains-win? villains)
  (cond [(empty? villains) false]
        [(>= (sprite-y (first villains)) HEIGHT) true]
        [else (villains-win? (rest villains))]))


;; State -> Boolean
;; Returns true if the State needs refurbishing (less than REFURBISH villains)
; (define (refurbish? state) false) ; stub

(check-expect (refurbish? ISTATE) false)
(check-expect (refurbish? empty) true) ; Refurbishing is dependent from the constant REFURBISH

(define (refurbish? state)
  (< (count state) REFURBISH))


;; =============================
;; Utilities
;; =============================

;; State -> Sprite
;; Extracts the player (or players) from the state
;; Assumes there is only one player
; (define (get-player state) PLAYER) ; stub

(check-expect (get-player empty) false)
(check-expect (get-player DSTATE) P0)
(check-expect (get-player (list EB1 P1 SV1 SV2 SV3)) P1)
(check-expect (get-player (list SV1 SV2 P2 SV3)) P2)
(check-expect (get-player ISTATE) P0)

(define (get-player state)
  (cond [(empty? state) false]
        [(player? (first state)) (first state)]
        [else (get-player (rest state))]))


;; State -> ListOfSprites
;; Estracts a list of Energy Beams from State
; (define (get-ebeams state) empty) ; stub

(check-expect (get-ebeams empty) empty)
(check-expect (get-ebeams ISTATE) empty)
(check-expect (get-ebeams DSTATE) (list EB1))
(check-expect (get-ebeams (list EB0 SV1 P0 SV7 EB2)) (list EB0 EB2))

(define (get-ebeams state)
  (cond [(empty? state) empty]
        [else (if (ebeam? (first state))
                  (cons (first state) (get-ebeams (rest state)))
                  (get-ebeams (rest state)))]))


;; State -> ListOfSprites
;; Estracts a list of Space Villains from State
; (define (get-villains state) empty) ; stub

(check-expect (get-villains empty) empty)
(check-expect (get-villains ISTATE) (list SV1 SV2 SV3 SV4 SV5 SV6 SV7 SV8 SV9 SV10 SV11 SV12 SV13 SV14 SV15 SV16 SV17 SV18))
(check-expect (get-villains DSTATE) (list SV1 SV2 SV3))
(check-expect (get-villains (list EB0 SV1 P0 SV7 EB2)) (list SV1 SV7))

(define (get-villains state)
  (cond [(empty? state) empty]
        [else (if (villain? (first state))
                  (cons (first state) (get-villains (rest state)))
                  (get-villains (rest state)))]))


;; Sprite -> Posn
;; Given a Sprite returns its correspondent Posn
; (define (sprite->posn sprite) (make-posn 0 0)) ; stub

(check-expect (sprite->posn P0) (make-posn (sprite-x P0) (sprite-y P0)))
(check-expect (sprite->posn SV1) (make-posn (sprite-x SV1) (sprite-y SV1)))
(check-expect (sprite->posn EB1) (make-posn (sprite-x EB1) (sprite-y EB1)))

(define (sprite->posn sprite)
  (make-posn (sprite-x sprite) (sprite-y sprite)))


;; Sprite -> Image
;; Given a Sprite returns it Image
; (define (sprite->image sprite) empty-image) ; stub

(check-expect (sprite->image P0) (sprite-img P0))
(check-expect (sprite->image SV1) (sprite-img SV1))
(check-expect (sprite->image EB1) (sprite-img EB1))

(define (sprite->image sprite) (sprite-img sprite))


;; Sprite -> Sprite
;; Invert the direction of movement of a Sprite
; (define (flip-sprite sprite) sprite) ; stub

(check-expect (flip-sprite SV1) (make-sprite V
                                             (sprite-x SV1)
                                             (sprite-y SV1)
                                             (* -1 (sprite-dx SV1))
                                             (sprite-dy SV1)
                                             (sprite-img SV1)))
(check-expect (flip-sprite SV6) (make-sprite V
                                             (sprite-x SV6)
                                             (sprite-y SV6)
                                             (* -1 (sprite-dx SV6))
                                             (sprite-dy SV6)
                                             (sprite-img SV6)))

(define (flip-sprite sprite)
  (make-sprite (sprite-type sprite)
               (sprite-x sprite)
               (sprite-y sprite)
               (* -1 (sprite-dx sprite))
               (sprite-dy sprite)
               (sprite-img sprite)))


;; Natural[0,WIDTH] Natural[0,WIDTH] -> Sprite
;; Returns a Player at x,y coordinates

(check-expect (make-player 100 100)
              (make-sprite P 100 100 PDX 0 TANK))

(define (make-player x y)
  (make-sprite P x y PDX 0 TANK))


;; Natural[0,WIDTH] Natural[0,WIDTH] -> Sprite
;; Returns an Energy Beam at x,y coordinates

(check-expect (make-ebeam 100 100)
              (make-sprite E 100 100 0 EDY EBEAM))

(define (make-ebeam x y)
  (make-sprite E x y 0 EDY EBEAM))


;; Natural[0,WIDTH] Natural[0,WIDTH] -> Sprite
;; Returns a Space Villain at x,y coordinates

(check-expect (make-villain 100 100)
              (make-sprite V 100 100 VDX VDY SVILL))

(define (make-villain x y)
  (make-sprite V x y VDX VDY SVILL))


;; State -> Natural
;; Counts the item in the current State
; (define (count state) 0) ; stub

(check-expect (count empty) 0)
(check-expect (count (list P0 SV1 SV2)) 3)
(check-expect (count (list P0 EB0 SV1 SV2 SV3)) 5)

(define (count state)
  (cond [(empty? state) 0]
        [else (+ 1 (count (rest state)))]))
