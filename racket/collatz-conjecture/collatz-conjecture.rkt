#lang racket

(provide collatz)

(define (collatz n)
  (if (not (exact-positive-integer? n))
      (error "blah")
      (if (equal? n 1)
          0
          (let [(n (if (even? n) (quotient n 2) (+ 1 (* 3 n))))]
            (+ 1 (collatz n))))))


  

