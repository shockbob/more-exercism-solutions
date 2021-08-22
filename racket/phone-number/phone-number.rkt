#lang racket

(provide nanp-clean)

(define (nanp-clean s)
  (let* [(cleaned (string-replace (string-replace s #rx"[^0-9]" "") #rx"^1" ""))]
    (if (not (and (equal? 10 (string-length cleaned))
                  (regexp-match #px"[2-9][0-9]{2}[2-9][0-9]{6}" cleaned)))
        (error "error")
        cleaned)))
    
