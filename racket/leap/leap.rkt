#lang racket

(provide leap-year?)

(define (leap-year? year)
  (or (zero? (remainder year 400))
      (and (zero? (remainder year 4))
           (not (zero? (remainder year 100))))))
