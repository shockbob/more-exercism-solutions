;;; roman-numerals.el --- roman-numerals Exercise (exercism)

;;; Commentary:

;;; Code:

(setq roman-digits [[][1][1 1][1 1 1][1 5][5][5 1][5 1 1][5 1 1 1][1 10]])

(setq roman-patterns #s(hash-table size 30 test equal data 
				   (1 "IXCM" 5 "VLD" 10 "XCM")))

(defun roman-text (pow dig)
  (let* ((romans (elt roman-digits dig))
	 (roman-digits (seq-map
	  		(lambda (roman-dig)
	  		  (substring
	  		   (gethash roman-dig roman-patterns)
	  		   pow
	  		   (+ 1 pow)))
	  		romans)))
    (apply 'concat roman-digits)))

(defun get-arabic-digits (number)
  (seq-map (lambda (ch) (- ch 48)) (number-to-string number)))

(defun to-roman (n)
  (let* ((arabic-digits (get-arabic-digits n))
	 (len (length arabic-digits))
	 (powers (number-sequence (- len 1) 0 -1))
	 (romans (seq-mapn 'roman-text powers arabic-digits)))
    (apply 'concat romans)))

(provide 'roman-numerals)
;;; roman-numerals.el ends here
