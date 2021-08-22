#lang racket

(provide isogram?)

(define (has-dups ls hsh)
  (if (empty? ls)
      false
      (if (hash-ref hsh (first ls) false)
          true
          (has-dups (rest ls) (hash-set hsh (first ls) true)))))

(define (isogram? s)
  (let* [ (valids (filter char-alphabetic? (string->list (string-downcase s))))]
    (not (has-dups valids (hash)))))
