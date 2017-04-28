Suppose you are working on a program someone else wrote
that simulates traffic. In the program there are traffic
lights and cars and streets and things like that. While
reading the program you come across this function:

(define (next-color c)
  (cond [(= c 0) 2]
        [(= c 1) 0]
        [(= c 2) 1]))

What does it do? The name is a hint, it seems to produce
the "next color". But its hard to be sure.

Surely if the programmer had followed the HtDF recipe
this would be better wouldn't it? Suppose instead the   
code looked like this.

;; Natural -> Natural
;; Returns the next color of a traffic light

(check-expect (next-color 0) 2)
(check-expect (next-color 1) 0)
(check-expect (next-color 2) 1)

(define (next-color c)
  (cond [(= c 0) 2]
        [(= c 1) 0]
        [(= c 2) 1]))

That's a little better. At least it is now clear that
the function does produce the next color. And the tests
make it clear that the function is really supposed to
produce 2 when it is called with 0. But what are the
0, 1 and 2 about? And what about calling the function
with 3? The signature says that is OK, but the cond
in the body will signal an error in that case.

...see traffic-light.rkt for the final example code.
