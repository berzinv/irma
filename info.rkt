#lang info
(define collection "irma")
(define deps '("base" "db"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/irma.scrbl" ())))
(define pkg-desc "Irma is a tool to predict values based on a linear regression algorithm.")
(define version "0.0.1")
(define pkg-authors '(Vincent BERZIN))
(define license '(MIT))
