#lang racket

(provide nucleotide-counts)

(define valid-nucs '(#\A #\C #\G #\T))

(define (nucleotide-counts nucs)
  (if (andmap (lambda (c) (set-member? valid-nucs c)) (string->list nucs))
      (let* [(hash-nucs (foldl
                         (lambda (l h) (hash-set h l (+ 1 (hash-ref h l 0))))
                         (hash)
                         (string->list nucs)))]
        (map
         (lambda (k) (cons k (hash-ref hash-nucs k 0)))
         valid-nucs))
      (error  "invalid nucleotide")))
