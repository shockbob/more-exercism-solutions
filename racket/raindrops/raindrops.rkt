#lang racket

(provide convert)

(define (make-text n d str)
  (if (zero? (remainder n d))
      str
      ""))

(define (convert n)
  (let [(strs (string-append (make-text n 3 "Pling") (make-text n 5 "Plang") (make-text n 7 "Plong")))]
    (if (zero? (string-length strs))
        (number->string n)
        strs)))
