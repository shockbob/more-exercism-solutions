#lang racket

(provide sum-of-squares square-of-sum difference)

(define (square-of-sum n)
  (let [(sum (quotient (* n (+ n 1)) 2))]
    (* sum sum)))

(define (sum-of-squares n)
  (quotient (* n (+ n 1 ) ( + 1 (* 2 n))) 6))

(define (difference n)
  (- (square-of-sum n)(sum-of-squares n)))
