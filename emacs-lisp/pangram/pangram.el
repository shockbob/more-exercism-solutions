;;; pangram.el --- Pangram (exercism)

(defun is-pangram (str)
  (= 26 (length (delete-dups (seq-filter
		      (lambda (ch) (<= ?a ch ?z))
		      (vconcat (downcase str)))))))

(provide 'is-pangram)

