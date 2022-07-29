#lang racket

(provide linear-regression)

(define (linear-regression data)
  (define x (map car data))
  (define x2 (map (lambda (i) (* i i)) x))
  (define y (map cdr data))
  (define xy (map (lambda (p) (* (car p) (cdr p))) data))
  (define n (length x))

  (define sumX (apply + x))
  (define sumX2 (apply + x2))
  (define sumY (apply + y))
  (define sumXY (apply + xy))

  (define b (/ (- (* n sumXY)
                  (* sumX sumY))
               (- (* n sumX2)
                  (* sumX sumX))))
  (define a (/ (-  sumY (* b sumX))
               n))

  (lambda (x)
    (+ a (* b x))))


