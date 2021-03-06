;;; anagram.el --- Anagram (exercism)

;;; Commentary:

;;; Code:

(require 'cl-lib)
(defun normalize (str)
  (sort (vconcat (downcase str))'> ))

(defun anagrams-for (word candidates)
  (seq-filter (lambda (candidate)
		(and (not (equal (downcase word) (downcase candidate)))
		     (equal (normalize word) (normalize candidate))))
	      candidates))

(provide 'anagrams-for)
;;; anagram.el ends here
