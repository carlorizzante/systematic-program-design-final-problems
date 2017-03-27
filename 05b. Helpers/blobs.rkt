(require 2htdp/image)


;; ==========================
;; Data definition
;; ==========================

;; Blob is one of:
;; - "solid"
;; - "bubble"
;; interp.  a gelatinous blob, either a solid or a bubble
;; Examples are redundant for enumerations
#;
(define (fn-for-blob b)
  (cond [(string=? b "solid") (...)]
        [(string=? b "bubble") (...)]))

;; Template rules used:
;; - one-of: 2 cases
;; - atomic distinct: "solid"
;; - atomic distinct: "bubble"


;; ListOfBlob is one of:
;; - empty
;; - (cons Blob ListOfBlob)
;; interp. a sequence of blobs in a test tube, listed from top to bottom.
(define LOB0 empty) ; empty test tube
(define LOB2 (cons "solid" (cons "bubble" empty))) ; solid blob above a bubble
(define LOB3 (cons "bubble" (cons "solid" empty))) ; bubble on top of solid

#;
(define (fn-for-lob lob)
  (cond [(empty? lob) (...)]
        [else
         (... (fn-for-blob (first lob))
              (fn-for-lob (rest lob)))]))

;; Template rules used
;; - one-of: 2 cases
;; - atomic distinct: empty
;; - compound: 2 fields
;; - reference: (first lob) is Blob
;; - self-reference: (rest lob) is ListOfBlob


;; ==========================
;; Functions
;; ==========================

;; ListOfBlob -> ListOfBlob
;; produce a list of blobs that sinks the given solid blobs by one
; (define (sink lob) empty) ; stub

(check-expect (sink empty) empty)
(check-expect (sink (cons "bubble" (cons "solid" (cons "bubble" empty))))
              (cons "bubble" (cons "bubble" (cons "solid" empty))))
(check-expect (sink (cons "solid" (cons "solid" (cons "bubble" empty))))
              (cons "bubble" (cons "solid" (cons "solid" empty))))
(check-expect (sink (cons "solid" (cons "bubble" (cons "bubble" empty))))
              (cons "bubble" (cons "solid" (cons "bubble" empty))))
(check-expect (sink (cons "solid" (cons "bubble" (cons "solid" empty))))
              (cons "bubble" (cons "solid" (cons "solid" empty))))
(check-expect (sink (cons "bubble" (cons "solid" (cons "solid" empty))))
              (cons "bubble" (cons "solid" (cons "solid" empty))))
(check-expect (sink (cons "solid" (cons "solid" (cons "bubble" (cons "bubble" empty)))))
              (cons "bubble" (cons "solid" (cons "solid" (cons "bubble" empty)))))

(define (sink lob)
  (cond [(empty? lob) empty]
        [else
         (if (bubble? (first lob))
             (cons (first lob) (sink (rest lob)))
             (sink-first (first lob) (sink (rest lob))))]))


;; Blob ListOfBlob -> ListOfBlob
;; Sinks a solid blob down a level in a list of blobs
; (define (sink-first b lob) (cons b lob)) ; stub

(check-expect (sink-first "bubble" (cons "solid" empty))
                    (cons "solid" (cons "bubble" empty)))
(check-expect (sink-first "solid" (cons "bubble" empty))
                    (cons "bubble" (cons "solid" empty)))
(check-expect (sink-first "solid" (cons "bubble" (cons "bubble" empty)))
                                  (cons "bubble" (cons "solid" (cons "bubble" empty))))

(define (sink-first b lob)
  (cond [(empty? lob) (cons b empty)]
        [else (cons (first lob) (cons b (rest lob)))]))


;; Blob -> Boolean
;; Returns true if the Blob is "bubble", otherwise false
; (define (bubble? b) false) ; stub

(check-expect (bubble? "bubble") true)
(check-expect (bubble? "solid") false)

(define (bubble? b)
  (cond [(string=? b "bubble") true]
        [else false]))
