#lang racket

(provide word-count)

(define (word-count str)
  (let* [(str (string-replace (string-downcase str) #rx"[,\n.|:&!&@$%^&]" " "))
         (str (string-normalize-spaces str))
         (words (string-split str " "))
         (words (map (lambda (w) (string-trim w "'")) words))
         (map (foldl (lambda (w h) (hash-set h w (add1 (hash-ref h w 0)))) (hash) words)) ]
    map))

