#lang racket

(provide list-allergies allergic-to?)

(define pairs '(("eggs" . 1) ("peanuts" . 2) ("shellfish" . 4) ("strawberries" . 8) ("tomatoes" . 16)
  ("chocolate" . 32) ("pollen" . 64) ("cats" . 128)))

(define allergy-hash (make-hash pairs))

(define allergy-values (map car pairs))

(define (list-allergies score)
  (filter
   (lambda (value) (allergic-to? value score))
   allergy-values ))
  
(define (allergic-to? str score)
  (not (zero? (bitwise-and score (hash-ref allergy-hash str)))))
