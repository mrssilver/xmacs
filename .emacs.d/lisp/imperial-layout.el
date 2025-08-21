(defvar split-window-enabled nil
  "控制是否允许分屏的开关，默认为 nil（禁止分屏）。")

(defun toggle-state ()
  "切换分屏开关状态，并显示提示。"
  (interactive)
  (setq split-window-enabled (not split-window-enabled))
  (if split-window-enabled
      (message "✅ 分屏已启用")
    (message "❌ 分屏已禁用")))

(toggle-state)

(defun setup-window-layout ()
  "创建稳定的三窗格布局（左I/右io+main），包含：
  - 修正窗口分割参数传递
  - 添加防御性编程检查
  - 支持交互式调用"
  (interactive)
  (delete-other-windows)
 
    ;; 创建左侧I窗口
  (split-window-horizontally)

      (set-window-parameter (selected-window) 'window-purpose "I")
     
      
    
    ;; 创建右侧io窗口
    (condition-case err
        (progn
          (split-window-vertically)
	    (other-window 1)
            (set-window-parameter (selected-window) 'window-purpose "io")
            
            (other-window 1)
          (set-window-parameter (selected-window) 'window-purpose "main"))
      (error
       (message "垂直分割失败: %s" err)
       (delete-other-windows)
       )))

(defun get-window-with-purpose (purpose)
  "查找指定用途的窗口"
  (cl-find-if 
   (lambda (w) (equal (window-parameter w 'window-purpose) purpose))
   (window-list)))


(defun ensure-layout ()
  "确保三窗格布局存在，若不存在则创建"
  (unless (and (windowp (get-window-with-purpose "I"))
               (windowp (get-window-with-purpose  "io"))
               (windowp (get-window-with-purpose "main")))
    (setup-window-layout)))



(setup-window-layout)



;; 拦截分屏函数
(defun split-window-wrapper (orig-fun &rest args)
  "根据 split-window-enabled 决定是否允许分屏。"
  (if split-window-enabled
      (apply orig-fun args)  ; 允许分屏
    (message "⚠️ 分屏操作已禁用，无法创建新窗口。")
    (ding)
    nil))  ; 不执行原函数

;; 拦截所有分屏相关函数
(advice-add 'split-window :around #'split-window-wrapper)
(advice-add 'split-window-horizontally :around #'split-window-wrapper)
(advice-add 'split-window-vertically :around #'split-window-wrapper)
(advice-add 'split-window-sensibly :around #'split-window-wrapper)

;; 拦截 display-buffer 和 pop-to-buffer（可能分屏）
(defun force-display-in-current-window (orig-fun &rest args)
  "强制 display-buffer 在当前窗口显示。"
  (if split-window-enabled
      (apply orig-fun args)
    (let ((display-buffer-alist '((nil . ((display-buffer-reuse-window . t))))))
      (apply orig-fun args))))

(advice-add 'display-buffer :around #'force-display-in-current-window)

(defun force-switch-to-buffer (orig-fun &rest args)
  "强制 pop-to-buffer 在当前窗口显示。"
  (if split-window-enabled
      (apply orig-fun args)
    (switch-to-buffer (car args))
    nil))

(advice-add 'pop-to-buffer :around #'force-switch-to-buffer)
(setq display-buffer-alist
      (list
       ;; Rule 1: *Completions*, *compilation*, *Messages* -> window "I"
       (cons
        (lambda (buf alist)
          (let ((name (buffer-name buf)))
            (string-match-p "\\` \\*Completions\\*\\|\\*compilation\\*\\|\\*Messages\\*\\|\\*Compile-Log\\*" name)))
        (list 'display-buffer-reuse-window
              (cons 'in-window-name "I")
              (cons 'dedicated t)))

       ;; Rule 2: erc 相关 buffer（如 #channel, *erc*）-> window "io"
       (cons
        (lambda (buf alist)
          (let ((name (buffer-name buf)))
            (string-match-p "\\`\\*?erc\\|^#.+:" name)))
        (list 'display-buffer-reuse-window
              (cons 'in-window-name "io")
              (cons 'dedicated t)))

       ;; Rule 3: 其他所有 buffer -> window "main"
       (cons t
             (list 'display-buffer-reuse-window
                   (cons 'in-window-name "main")))))

;; 启动时确保布局存在
(add-hook 'after-init-hook 'ensure-layout)
(setq split-window-enabled nil)






;; 为窗口名添加颜色和图标
(setq mode-line-format
  `("%e"
    ,(propertize " %b " 'face '(:background "red" :foreground "white"))
    " "
    ,(propertize "◉" 'face '(:foreground "red") 
                 'display '(raise -0.1))
   
    ))



;; 精简版配置（隐藏冗余信息）
(setq mode-line-position
  '((:eval (propertize (format "L%d C%d" (line-number-at-pos) (current-column))
                       'face '(:foreground "gold")))
    " "
    (:eval (propertize (format "%.0f%%" (* 100 (/ (float (point)) (point-max))))
                       'face '(:background "orange")))))

;; 颜色定制（需放在配置最后）
(set-face-attribute 'mode-line nil
  :background "orange" :foreground "gold")

(force-mode-line-update)

(provide 'imperial-layout)

