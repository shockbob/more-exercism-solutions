#lang racket





(provide my-length
         my-reverse
         my-map
         my-filter
         my-fold
         my-append
         my-concatenate)

(define (tail-length l acc)
  (if (null? l)
      acc
      (tail-length (rest l) (add1 acc))))

(define (tail-reverse l acc)
  (if (null? l)
      acc
      (tail-reverse (rest l) (cons  (first l) acc))))

(define (my-map f lst)
  (cond
   [(empty? lst) empty]
   [else (cons (f (first lst))
               (my-map f (rest lst)))]))

(define (my-filter f lst)
  (cond
   [(empty? lst) empty]
   [#t (if (f (first lst))
                (cons (first lst) (my-filter f (rest lst)))
                (my-filter f (rest lst)))]))

(define (my-length l)
  (tail-length l 0))

(define (my-reverse l)
  (tail-reverse l '()))

(define (my-fold l i f) 0)
(define (my-append a b) 0)
(define (my-concatenate a b) 0)






















