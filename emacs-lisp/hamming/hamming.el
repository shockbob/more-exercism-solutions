;;; hamming.el --- Hamming (exercism)

;;; Commentary:

;;; Code:
(require `seq)

(defun hamming-distance (a b)
  (if (not (= (length a)(length b)))
      (error "not equal")
    (seq-count 'null (seq-mapn (lambda (ax bx) (equal ax bx)) a b))))

(provide 'hamming)
;;; hamming.el ends here
