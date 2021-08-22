#lang racket

(provide armstrong-number?)

(define (armstrong-number? n)
  (let* [(list-of-digits (string->list (number->string n)))
         (len (length list-of-digits))
         (digits (map
                  (lambda (c) (- (char->integer c) 48))
                  list-of-digits))
         (sum (foldr
               +
               0
               (map (lambda (digit) (expt digit len)) digits)))]
    (= sum n)))
         
