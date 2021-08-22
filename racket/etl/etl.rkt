#lang racket

(provide etl)

(define (etl hash-in)
  (let [(valid-keys (andmap (lambda [k] (> k 0)) (hash-keys hash-in)))
        (valid-values (andmap (lambda [l] (andmap (lambda (v) (string? v)) l)) (hash-values hash-in)))]
    (if (not (and valid-keys valid-values))
        (raise-arguments-error 'contract "bad keys or values")
        (foldl
         (lambda (key hash)
           (foldl
            (lambda (char hash) (hash-set hash (string-downcase char) key))
            hash
            (hash-ref hash-in key)))
         (hash)
         (hash-keys hash-in))))) 
