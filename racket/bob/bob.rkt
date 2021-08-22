#lang racket

(require racket/string)
(provide response-for)

(define (response-for s) 
  (let* [(all-spaces (zero? (string-length (string-trim s))))
         (has-uppers (ormap (lambda (c) (<= (char->integer #\A) (char->integer c) (char->integer #\Z))) (string->list s))) 
         (all-uppers (and has-uppers (equal? (string-upcase s) s)))
         (question (string-suffix? s "?"))
         (exclaim (string-suffix? s "!")) ]
    (cond
      [all-spaces "Fine. Be that way!"] 
      [(and all-uppers question) "Calm down, I know what I'm doing!" ]
      [question "Sure."]
      [(and all-uppers exclaim) "Whoa, chill out!"]
      [all-uppers "Whoa, chill out!"]
      [(zero? (string-length s)) "Fine. Be that way!"]
      [#t "Whatever."])))