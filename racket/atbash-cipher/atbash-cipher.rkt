#lang racket

(require racket/list)

(provide encode decode)

(define (split-str str n)
  (if (<= (string-length str) n)
      str
      (let [(f (substring str 0 n))
            (r (substring str n))]
        (string-append f " " (split-str r n)))))

(define (switch ch)
  (if (not (char-alphabetic? ch))
      ch
      (let* [(delta (- (char->integer #\z) (char->integer ch)  ))]
        (integer->char (+ (char->integer #\a) delta)))))

(define (encode m)
  (let* [(list-of-ch (map switch (string->list (string-downcase (string-replace m #rx"[^a-zA-Z0-9]" "")))))]
    (split-str (apply string list-of-ch) 5)))

(define (decode m)
  (let* [(list-of-ch (map switch (string->list (string-replace m " " ""))))]
    (apply string list-of-ch)))
