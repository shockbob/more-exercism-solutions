#lang racket

(provide meetup-day)
(require racket/date)

(define (build-date year month day)
  (seconds->date (find-seconds 0 0 0 day month year #f) #f))

(define day-of-week-map (hash 'Monday 1 'Tuesday 2 'Wednesday 3 'Thursday 4 'Friday 5 
                              'Saturday 6 'Sunday 0))

(define which-map (hash 'first 0 'second 1 'third 2 'fourth 3 'fifth 4 'last -1))

(define (get-day-of-month year month day)
  (date-week-day (build-date year month day)))

(define month-map (hash 1 31 2 28 3 31 4 30 5 31 6 30 7 31 8 31 9 30 10 31 11 30 12 31))

(define (days-in-month year month)
  (if (and (zero? (remainder year 4))(equal? month 2))
      29
      (hash-ref month-map month)))

(define (first-match-day year month day-number first-to-check)
  (let* [(first-day (get-day-of-month year month first-to-check))
         (first-matching-day (+ first-to-check (- day-number first-day)))
         (first-matching-day (if (< first-matching-day first-to-check) (+ 7 first-matching-day) first-matching-day))]
    first-matching-day))

(define (get-matching-days year month day-number first-to-check)
  (let* [(length-month  (days-in-month year month))
         (first-matching-day (first-match-day year month day-number first-to-check))]
    (range first-matching-day (add1 length-month) 7)))

(define (get-meetup month year day-of-week which first-day-to-check)
  (let* [(day-number (hash-ref day-of-week-map day-of-week))
         (matching-days (apply vector (get-matching-days year month day-number first-day-to-check))) 
         (index (hash-ref which-map which))]
    (if (negative? index)
        (build-date year month (vector-ref matching-days (sub1 (vector-length matching-days))))
        (build-date year month (vector-ref matching-days index)))))
    
   
(define (meetup-day year month day-of-week which)
  (if (equal? 'teenth which)
      (get-meetup month year day-of-week 'first 13)
      (get-meetup month year day-of-week which 1)))
