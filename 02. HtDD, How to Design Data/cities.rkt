;; ===========================
;; Data Definition
;; ===========================

;; Information  |  Data
;; ---------------------------------
;; Vancouver    |  "Vancouver"
;; Boston       |  "Boston"
;; Copenhagen   |  "Copenhagen"

;; CityName is String
;; Interpretion: the name of a city

(define CN1 "Vancouver")
(define CN2 "Boston")
(define CN3 "Copenhagen")

;; Template rules:
;; - Atomic Non-Distinct: String

#;
(define (fn-for-city-name cn)
  (... cn))


;; ===========================
;; Functions
;; ===========================

;; CityName -> Boolean
;; Returns true if the given CityName corresponds to the best city in the World
; (define (best-city? cn) false) ; stub

(check-expect (best-city? CN1) false)
(check-expect (best-city? CN3) true)

#; ; template from CityName
(define (fn-for-city-name cn)
  (... cn))

(define (best-city? cn)
  (string=? cn "Copenhagen"))
