;;; expand-function.el --- Quickly expand words to function definitions

;; Copyright (C) 2023 mrsilver

;; Author: Your Name <mrssilver1209@icloud.com>>
;; URL: https://github.com/mrssivler/expand-function
;; Version: 1.0.0
;; Package-Requires: ((emacs "27.1") (evil "1.0"))
;; Keywords: productivity, programming, functions

;;; Commentary:
;; This plugin allows you to quickly expand words under cursor to complete
;; function definitions in various programming languages with proper syntax.

;;; Usage:
;; (require 'expand-function)
;; (expand-function-setup)

;; Then in any programming mode:
;;   - Position cursor on a word and press "fw" to expand it to a function
;;   - Use prefix arguments (C-2 fw) to expand multiple words
;;   - Or visually select words and press "fw" to expand all selected

;;; Code:

(require 'evil)

(defgroup expand-function nil
  "Quickly expand words to function definitions."
  :group 'programming
  :prefix "expand-function-")

(defcustom expand-function-key "fw"
  "Key sequence to bind for expand function command."
  :type 'string
  :group 'expand-function)

(defcustom expand-function-python-indent 4
  "Python function body indentation level."
  :type 'integer
  :group 'expand-function)

(defcustom expand-function-other-indent 4
  "Default function body indentation level for other languages."
  :type 'integer
  :group 'expand-function)

(defcustom expand-function-go-param-style "()"
  "Parameter style for Go functions."
  :type 'string
  :group 'expand-function
  :options '("()" "(arg string)"))

(defcustom expand-function-c-param-style "void"
  "Parameter style for C functions."
  :type 'string
  :group 'expand-function
  :options '("void" "int argc, char *argv[]"))

(defvar expand-function--templates
  `((c-mode . ,(lambda (word indent)
                 (format "%s%s %s(%s)\n%s{\n%s%s\n%s}\n\n"
                         indent (if (derived-mode-p 'c++-mode) "" "void")
                         word expand-function-c-param-style
                         indent indent (make-string expand-function-other-indent ? ) indent)))
    (zig-mode . ,(lambda (word indent)
                   (format "%sfn %s() void {\n%s%s\n%s}\n\n"
                           indent word indent 
                           (make-string expand-function-other-indent ? ) indent)))
    (go-mode . ,(lambda (word indent)
                  (format "%sfunc %s%s {\n%s%s\n%s}\n\n"
                          indent word expand-function-go-param-style
                          indent (make-string expand-function-other-indent ? ) indent)))
    (python-mode . ,(lambda (word indent)
                      (format "%sdef %s():\n%s%s\n"
                              indent word indent 
                              (make-string expand-function-python-indent ? ))))
    (default . ,(lambda (word indent)
                  (format "%sfunction %s() {\n%s%s\n%s}\n\n"
                          indent word indent 
                          (make-string expand-function-other-indent ? ) indent))))
  "Templates for various programming languages.")

;;;###autoload
(defun expand-function-expand-n-words (n)
  "Expand the next N words into separate function definitions."
  (interactive "p")
  (let* ((indent (make-string (current-indentation) ? ))
         (start (point))
         words
         bounds
         (mode (cond ((derived-mode-p 'c-mode 'c++-mode 'c-or-c++-mode) 'c-mode)
                     ((derived-mode-p 'zig-mode) 'zig-mode)
                     ((derived-mode-p 'go-mode) 'go-mode)
                     ((derived-mode-p 'python-mode) 'python-mode)
                     (t 'default))))
    
    ;; Collect N words
    (dotimes (i n)
      (when (re-search-forward "\\_<\\w+\\_>" nil t)
        (push (match-string 0) words)
        (setq bounds (or bounds (cons start (point)))))
      (forward-word 1))
    
    (if (null words)
        (user-error "No words found at point")
      
      ;; Delete original words
      (delete-region (car bounds) (cdr bounds))
      (setq words (nreverse words))
      
      ;; Insert function definitions
      (let ((template-fn (cdr (assoc mode expand-function--templates)))
            (first t))
        (dolist (word words)
          (insert (funcall template-fn word indent))
          (when first
            (backward-char)  ; Position for editing
            (search-backward "{")
            (unless (derived-mode-p 'python-mode) 
              (forward-char 1))
            (setq first nil)))
        (search-backward "{")
        (if (derived-mode-p 'python-mode)
            (forward-line 1)
          (forward-char 1))
        (indent-according-to-mode)
        (evil-insert-state)))))

;;;###autoload
(defun expand-function-expand-region ()
  "Expand selected words in visual mode to function definitions."
  (interactive)
  (if (not (evil-visual-state-p))
      (user-error "Not in visual mode")
    (let ((n (count-words-region (region-beginning) (region-end))))
      (evil-normal-state)
      (expand-function-expand-n-words n))))

;;;###autoload
(defun expand-function-setup ()
  "Set up keybindings for expand-function."
  (interactive)
  
  (dolist (hook '(prog-mode-hook
                  c-mode-common-hook
                  zig-mode-hook
                  go-mode-hook
                  python-mode-hook
                  js-mode-hook
                  typescript-mode-hook
                  ruby-mode-hook
                  rust-mode-hook
                  php-mode-hook
                  lua-mode-hook
                  java-mode-hook
                  emacs-lisp-mode-hook
                  clojure-mode-hook
                  scheme-mode-hook))
    (add-hook hook #'expand-function-mode))
  
  (expand-function-mode 1))

(define-minor-mode expand-function-mode
  "Minor mode for expanding words to function definitions."
  :keymap `((,(kbd expand-function-key) . expand-function-expand-n-words))
  :group 'expand-function
  :global nil
  (if expand-function-mode
      (progn
        (add-hook 'evil-visual-state-entry-hook 
                  (lambda ()
                    (local-set-key (kbd expand-function-key) 
                                   #'expand-function-expand-region)) nil t)
        (message "expand-function mode enabled"))
    (progn
      (remove-hook 'evil-visual-state-entry-hook 
                   (lambda ()
                     (local-set-key (kbd expand-function-key) 
                                    #'expand-function-expand-region)) t)
      (message "expand-function mode disabled"))))

(provide 'expand-function)
;;; expand-function.el ends here
