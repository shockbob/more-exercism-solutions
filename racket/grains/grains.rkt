#lang racket

(provide square total)

(define (square n)
  (if (= n 1)
      1
      (* 2 (square (- n 1)))))

(define (total)
   (foldl + 0 (map square (range 1 65)))) 





