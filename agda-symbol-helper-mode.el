;;; agda-symbol-helper-mode.el --- Minor mode for finding unicode typing method for Agda -*- lexical-binding: t; -*-
(require 'dash)

(defvar mu-agda-last-post-command-position 0
  "Holds the cursor position fromthe last run of post-command-hooks.")

(make-variable-buffer-local 'mu-agda-last-post-command-position)

(defun mu-agda-unciode-helper-if-moved-hook ()
  "Output unicode input method if I moved."
  (defun mu-agda-unicode-input-helper ()
    "Get the current unicode input method."
    (interactive)
    (let* ((current-char (char-after)))
      ;; check if the char is in typable ascii range
      (unless (and (>= current-char 32) (<= current-char 126))
        (let ((output-msg
               (--reduce (format "%s, %s" acc it)
                         (quail-find-key current-char))))
          (message (format "Type: %s in Agda" output-msg))))))
  (let ((pos (point)))
    ;; boundary check
    (when (and (not (equal pos mu-agda-last-post-command-position))
               (not (eobp)) (not (eolp)))
      (mu-agda-unicode-input-helper)
      (setq last-post-command-position pos))))

;;;###autoload
(define-minor-mode agda-symbol-helper-mode
  "Show the typing of an Agda unicode symbol in minibuffer"
  :lighter " agda-symbol-helper"

  (if agda-symbol-helper-mode
      (add-to-list 'post-command-hook #'mu-agda-unciode-helper-if-moved-hook)
    (setq post-command-hook (remove 'mu-agda-unciode-helper-if-moved-hook post-command-hook))))

(provide 'agda-symbol-helper-mode)
