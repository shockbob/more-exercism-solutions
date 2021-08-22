#lang racket

(provide grep)

(define (show-numbers arguments)
  (member "-n" arguments))

(define (only-names arguments)
  (member "-l" arguments))

(define (inverse arguments)
  (member "-v" arguments))

(define (whole-line arguments)
  (member "-x" arguments))

(define (ignore-case arguments)
  (member "-i" arguments))

(define (programmed-match arguments pattern line)
  (let* [(pattern (if (ignore-case arguments) (string-downcase pattern) pattern))
         (line (if (ignore-case arguments) (string-downcase line) line))
         (matcher (if (whole-line arguments) equal? regexp-match))]
    (if (inverse arguments)
        (not (matcher pattern line))
        (matcher pattern line))))

(define (grep-file arguments pattern file)
  (let* [(lines (file->lines file))
         (lines-with-numbers (map
                              (lambda (line count) (cons count line))
                              lines
                              (range 1 (add1 (length lines)))))]
    (filter
     (lambda (line-with-number) (programmed-match  arguments pattern (cdr line-with-number)))
     lines-with-numbers)))

(define (get-file-strings arguments name lines-with-numbers file-count)
  (let [(name-on-line (if (equal? 1 file-count) "" (string-append name ":")))]
    (if (and (positive? (length lines-with-numbers)) (only-names arguments))
        (list name)
        (map (lambda (line-with-number) (if (show-numbers arguments)
                                            (string-append name-on-line (number->string (car line-with-number)) ":" (cdr line-with-number))
                                            (string-append name-on-line (cdr line-with-number))))
             lines-with-numbers))))
                                     
(define (grep arguments pattern files)
  (foldl (lambda [file strs] (let* [(lines-with-numbers (grep-file arguments pattern file))
                                    (file-lines (get-file-strings arguments file lines-with-numbers (length files)))]
                               (append strs file-lines)))
         '()
         files))
  
