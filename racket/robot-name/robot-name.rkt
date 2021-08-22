#lang racket

(provide make-robot
         name
         reset!
         reset-name-cache!)

(define robot-hash (make-hash))

(define letters "ABCDEFGHIJKLMNOPQRSTUVWXYZ")

(define (random-cap)
  (string-ref letters  (random  26)))

(define (random-three-digit)
  (number->string (random 100 1000)))

(define (random-name)
  (string-append (string (random-cap)) (string (random-cap)) (random-three-digit)))

(define (make-robot)
  (let* [(robot (make-hash))
         (_ (hash-set! robot 'name (random-name)))
         (_ (hash-set! robot 'id (random 10000)))
         (_ (hash-set! robot-hash (hash-ref robot 'id) robot))]
    (hash-ref robot 'id)))
    
(define (name robot)
  (hash-ref (hash-ref robot-hash robot) 'name))

(define (reset! robot)
  (let* [(robot-obj (hash-ref robot-hash robot))
         (_ (hash-set! robot-obj 'name (random-name)))]
    #t))

(define (reset-name-cache!) 0)
  

