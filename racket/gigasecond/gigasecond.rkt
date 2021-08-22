#lang racket

(provide add-gigasecond)

(require racket/date)

(define (add-gigasecond date)
  (seconds->date (+ 1000000000 (date->seconds date))))