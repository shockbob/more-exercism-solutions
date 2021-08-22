#lang racket

(provide hamming-distance)

(define (hamming-distance a b)
  (foldl + 0 (map
              (lambda (na nb) (if (equal? na nb) 0 1))
              (string->list a)
              (string->list b))))
