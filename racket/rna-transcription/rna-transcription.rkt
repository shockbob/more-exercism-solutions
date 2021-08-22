#lang racket

(provide to-rna)

(define rna-map (hash #\G #\C
                      #\C #\G
                      #\T #\A
                      #\A #\U))

(define (to-rna dna)
  (list->string (map (lambda (d) (hash-ref rna-map d)) (string->list dna))))
