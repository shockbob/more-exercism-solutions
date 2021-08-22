;;; two-fer.el --- Two-fer Exercise (exercism)

;;; Commentary:

;;; Code:

(defun two-fer (&optional name)
  (concat "One for " (or name "you") ", one for me."))

(provide 'two-fer)
;;; two-fer.el ends here
