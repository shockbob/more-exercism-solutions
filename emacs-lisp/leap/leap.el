;;; leap.el --- Leap exercise (exercism)

;;; Commentary:

;;; Code:

(defun leap-year-p (n)
  (or (equal 0 (mod n 400))
      (and (equal 0 (mod n 4))
	   (not (equal 0 (mod n 100))))))

(provide 'leap-year-p)
;;; leap.el ends here
