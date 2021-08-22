#lang racket

(provide rebase)

(define (to-base-10 list-digits in-base mult)
  (if (null? list-digits)
      mult
      (to-base-10 (rest list-digits) in-base (+ (first list-digits) (* mult in-base)))))

(define (from-base-10 num in-base l)
  (if (zero? num)
      l
      (from-base-10 (quotient num in-base) in-base (append (list (remainder num in-base)) l))))

(define (bad-digits list-digits in-base)
  (ormap (lambda (n) (not (< -1 n in-base))) list-digits))

(define (rebase list-digits in-base out-base)
  (if (or (<= in-base 1)(<= out-base 1)(bad-digits list-digits in-base))
      false
      (if (or (null? list-digits)(andmap zero? list-digits))
          (list 0)
          (from-base-10 (to-base-10 list-digits in-base 0) out-base '()))))