#lang racket

(provide classify)

(define (classify n)
  (if (<= n 2)
      'deficient
      (let [(sum (+ 1 (foldl + 0 (factors n))))]
        (if (equal? sum n)
        'perfect
        (if (> sum n)
            'abundant
            'deficient)))))

(define (factors n)
  (remove-duplicates
   (flatten
    (map
     (lambda (f) (list f (quotient n f)))
     (filter
      (lambda (x) (zero? (remainder n x)))
      (range 2 (+ 1 (sqrt n))))))))


