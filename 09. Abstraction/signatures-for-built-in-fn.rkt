;; =====================
;; Built-in Fn
;; =====================

;; Natural (Natural -> X) -> (listof X)         build-list

;; (X -> Boolean) (listof X) -> (listof X)      filter

;; (X -> Y) (listof X) -> (listof Y)            map

;; (X -> Boolean) (listof X) -> Boolean         andmap

;; (X -> Boolean) (listof X) -> Boolean         ormap

;; (X Y -> Y) Y (listof X) -> Y                 foldr

;; (X Y -> Y) Y (listof X) -> Y                 foldl


;; =====================
;; Fn using built-in fn
;; =====================

;; Natural -> (listof X)         build-list

;; (listof X) -> (listof X)      filter

;; (listof X) -> (listof Y)      map

;; (listof X) -> Boolean         andmap

;; (listof X) -> Boolean         ormap

;; Y (listof X) -> Y             foldr

;; Y (listof X) -> Y             foldl
