#lang racket

(provide to-roman)

(define roman-powers (hash 1 "IXCM"  5  "VLD" 10  "XCM")) 
(define roman-digits #(() (1) (1 1) (1 1 1) (1 5) (5) (5 1) (5 1 1) (5 1 1 1) (1 10)))

(define (roman-text pow dig)
  (let* [(romans (vector-ref roman-digits dig))
         (roman-digits (map (lambda (dig)
                              (string-ref (hash-ref roman-powers dig) pow))
                            romans))]
    (apply string roman-digits)))

(define (char->realint c)
  (- (char->integer c) 48))

(define (to-roman n)
  (let*  [(list-of-digits (string->list (number->string n)))
          (len (length list-of-digits))
          (digits (map char->realint list-of-digits))
          (powers (range (sub1 len) -1 -1))
          (romans (map roman-text powers digits))]
    (apply string-append romans)))