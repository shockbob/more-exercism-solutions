#lang racket

(provide anagrams-for)

(define (normalize str)
  (sort (string->list (string-downcase str)) char>?))

(define (normed-eq worda wordb)
  (and
   (not (equal? (string-downcase worda)(string-downcase wordb)))
   (equal? (normalize worda) (normalize wordb))))


(define (anagrams-for word words)
  (filter (lambda (n) (normed-eq word n)) words))
