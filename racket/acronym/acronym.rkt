#lang racket

(provide acronym)

(define (acronym thing)
  (let* [(thing (string-replace thing #rx"[^A-Za-z']" " "))
         (thing-list (string-split thing))
         (thing-list (filter (lambda (x) (non-empty-string? (string-trim x))) thing-list))
         (thing-list (map (lambda (x) (string-ref (string-upcase x) 0)) thing-list))]
    (apply string thing-list)))

