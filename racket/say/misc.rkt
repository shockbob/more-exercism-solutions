 (define (get-next v n) (if (zero? (remainder (vector-length v) n))
                            (vector-split-at v n)
                            (vector-split-at v (remainder (vector-length v) n))))

(define (vector->num v val)
  (if (vector-empty? v)
      val
      (vector->num (vector-drop v 1) (+ (* 10 val) (vector-ref v 0)))))

(define (list->num l val)
  (if (null? l)
      val
      (list->num (rest l) (+ (* 10 val) (first l)))))


(define (split-up v n ls) (if (vector-empty? v)
                              ls
                              (let-values ([(f r) (get-next v n)])
                                           (split-up r n (append ls (list (vector->list f)))))))
