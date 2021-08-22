#lang racket
(provide my-reverse)

(define (rev l)
  (if (empty? l)
      '()
      (append (rev (rest l)) (list (first l)))))

(define (my-reverse s)
  (list->string (rev (string->list s))))
