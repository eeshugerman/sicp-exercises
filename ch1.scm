;;; 1.1 ;;;

10
;; 10

(+ 5 3 4)
;; 12

(- 9 1)
;; 8

(/ 6 2)
;; 3

(+ (* 2 4) (- 4 6))
;; 6

(define a 3)
;;

(define b (+ a 1))
;;

(+ a b (* a b))
;; 19

(= a b)
;; #f

(if (and (> b a) (< b (* a b))))
;; 4

(cond ((= a 4) 6)
      ((= b 4) (+ 6 7 a))
      (else 25))
;; 16

(+ 2 (if (> b a) b a))
;; 6

(* (cond((> a b) a)
        ((< a b) b)
        (else -1))
   (+ a 1))
;; 16


;;; 1.2 ;;;
(/ (+ 5
      4
      (- 2 (- 3 (+ 6 (/ 4 5)))))
   (* 3 (- 6 2) (- 2 7)))

;;; 1.3 ;;;
(define (sum-of-squares a b) (+ (* a a) (* b b)))
(define (f a b c)
  (cond ((= (min a b c) a) (sum-of-squares b c))
        ((= (min a b c) b) (sum-of-squares a c))
        ((= (min a b c) c) (sum-of-squares a b))))

;;; 1.4 ;;;
;; pseudo code:
;; if b > 0
;;   return a + b
;; else
;;   return a - b

;;; 1.5 ;;;
;; applicative-order:
;;   The arguments `0` and `(p)` will be evaluated before
;;   the body of the procedure is interpreted. The program
;;   will hang indefinitely when evaluating `(p)` because it
;;   simply evaluates to itself resulting in infinite
;;   recursion.
;;
;; normal-order:
;;   The arguments will not be evaluated until final
;;   expression for the body is assembled. The `if` condition
;;   is true, so the final expression is simply 0; `(p)` is
;;   never evaluated and the program exits normally.


;;; 1.6 ;;;
(define (square x) (* x x))

(define (good-enough? guess x)
  (< (abs (- x (square guess))) .0001))

(define (improve guess x)
  (/ (+ guess (/ x guess)) 2))

(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
        (else else-clause)))

(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x) x)))

(define (new-sqrt-iter guess x)
  (new-if (good-enough? guess x)
          guess
          (new-sqrt-iter (improve guess x) x)))

(define (sqrt x)
  (sqrt-iter 1 x))

(define (new-sqrt x)
  (new-sqrt-iter 1 x))

;; new-sqrt hangs and then gives a memory error. This is
;; because new-if is a function, so it's arguments are
;; evaluated when it is called. The else-clause argument
;; is the result of the previous iteration, and is evaluated
;; even when the predicate good-enough? is true, so the
;; recursion never terminates.

;;; 1.7 ;;;
;; For small numbers, the arbitrary value of  .0001 is
;; is too large to give an accurate result. For large
;; numbers, the inaccuracy due to limited precision
;; may exceed .0001, so the program will not reliably
;; converge.


#;281> (sqrt-iter 1e-3 1e-4)
0.001
#;286> (square .001)
1e-06

1e+200
#;594> (sqrt-iter 1e90 1e+200)
1e+100
#;600> (square 1e100) ; hmm, this seems to work fine

(define (good-enough2? guess last-guess x)
  (<
   (/ (abs (- guess last-guess))
      x)
  .0001))

(define (sqrt-iter2 guess last-guess x)
  (if (good-enough2? guess last-guess x)
      guess
      (sqrt-iter2 (improve guess x) guess x)))

(define (sqrt2 x)
  (sqrt-iter2 1 (abs (- 1 x)) x))


#;990>(square (sqrt2 1e-8))
1e-08

#;1009> (/ (square (sqrt2 1e8)) 1e8)
1.16307483937468
