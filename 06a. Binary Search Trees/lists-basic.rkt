(define L1 (list "b" "c"))
(define L2 (list "d" "e" "f"))

(list "a" L1)                            ; (list "a" (list "b" "c"))
(cons "a" L1)                            ; (list "a" "b" "c")

(append L1 L2)                           ; (list "b" "c" "d" "e" "f")

(list "a" (string-append "b" "c") "d")   ; (list "a" "bc" "d")
