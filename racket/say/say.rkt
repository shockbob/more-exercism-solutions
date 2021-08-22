#lang racket/base

;; Converts integers to English-language descriptions

;; --- NOTE -------------------------------------------------------------------
;; The test cases in "say-test.rkt" assume:
;; - Calling a function with an out-of-range argument triggers a contract error
;; - That `step3` returns a list of (number, symbol) pairs
;;
;; We have provided sample contracts so the tests compile, but you
;;  will want to edit & strengthen these.
;;
;; (For example, things like 0.333 and 7/8 pass the `number?` contract
;;  but these functions expect integers and natural numbers)
;; ----------------------------------------------------------------------------

(require racket/contract)

(provide (contract-out
           [step1 (-> (integer-in 0 99) string?)]
          ;; Convert a positive, 2-digit number to an English string

          [step2 (-> number? (listof number?))]
          ;; Divide a large positive number into a list of 3-digit (or smaller) chunks

          [step3 (-> number? (listof (cons/c number? symbol?)))]
          ;; Break a number into chunks and insert scales between the chunks

          [step4 (-> number? string?)]
          ;; Convert a number to an English-language string
          ))
(require racket/vector)
(require racket/list)
(require racket/string)
;; =============================================================================

(define powers #(UNK END thousand million billion trillion))

(define power-map (hash 'thousand "thousand" 'million "million" 'billion "billion" 'trillion "trillion" 'END ""))

(define num-dict (hash 0 "" 1  "one" 2  "two" 3  "three" 4  "four" 5  "five" 6  "six"  7  "seven" 
                       8  "eight" 9  "nine"  10  "ten"  11  "eleven"  12  "twelve"  13  "thirteen"  14  "fourteen" 
                       15  "fifteen"  16  "sixteen"  17  "seventeen"  18  "eighteen"  19  "nineteen"))

(define tens-dict (hash 2  "twenty" 3  "thirty" 4  "forty" 5  "fifty" 6  "sixty" 7  "seventy" 8  "eighty"
                        9  "ninety"))

(define (tens-and-ones n)
  (let [(tens-digit (quotient (remainder n 100) 10))
        (ones-digit (remainder n 10))]
    (if (< tens-digit 2)
        (hash-ref num-dict (remainder n 100))
        (if (zero? ones-digit)
            (string-append (hash-ref tens-dict tens-digit))
            (string-append (hash-ref tens-dict tens-digit) "-" (hash-ref num-dict ones-digit))))))

  
(define (huns n)
  (if (< n 100)
      ""
      (string-append (hash-ref num-dict (quotient n 100)) " hundred")))
  
(define (up-to-999 n)
  (string-join
   (filter non-empty-string? (list (huns n) (tens-and-ones n)))
   " "))

(define (split-num num)
  (if (< num 1000)
      (list num)
      (append (split-num (quotient num 1000)) (list (remainder num 1000)))))

(define (step1 n)
  (if (zero? n)
      "zero"
      (tens-and-ones n)))

(define (step2 N)
  (split-num N))

(define (step3 n)
  (let [(nums-list (step2 n))]
    (let* [(powers (map (lambda (n) (vector-ref powers n)) (range (length nums-list) 0 -1)))
           (power-list (map (lambda (a b) (cons a b)) nums-list powers))
           (filtered-list (filter (lambda (c) (not (zero? (car c)))) power-list))]
      filtered-list)))
          
(define (convert-to-string result)
  (let* [(strs (list (up-to-999 (car result)) (hash-ref power-map (cdr result))))
         (final-result (string-join (filter non-empty-string? strs) " "))]
    final-result))

(define (step4 N)
  (if (zero? N)
      "zero"
      (let* [(result (step3 (abs N)))
             (string-result (map convert-to-string result))
             (neg (if (< N 0) "negative " ""))]
        (string-append neg (string-join string-result)))))
  