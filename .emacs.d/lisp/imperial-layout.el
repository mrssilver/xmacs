

(defun imperial-make-buffer-read-only ()
  "为 *Messages*、*Output* 和 *Compilation* 缓冲区设置只读属性"
  (when (member (buffer-name) '("*Messages*" "*Output*" "*Compilation*" "*Mail*" "*Org*"))
    (setq buffer-read-only t)))

(add-hook 'buffer-list-update-hook 'imperial-make-buffer-read-only)

(defun imperial-setup-layout ()
  "创建固定宽度的主编辑区和右侧共享缓冲区区域"
  (interactive)
  (let ((imperial-left-width 70)) ; 主编辑区固定70字符宽度
    (when (one-window-p) ; 只有一个窗口时才创建布局
      (when (> (window-width) (+ imperial-left-width 20)) ; 右侧至少20字符
        (let* ((right-width (- (window-width) imperial-left-width))
               (right-height (round (/ (window-height) 2.0)))
               (messages-buf (get-buffer-create "*Messages*"))
               (output-buf (get-buffer-create "*Output*"))
               (compilation-buf (get-buffer-create "*Compilation*"))
               (mail-buf (get-buffer-create "*Mail*"))
               (org-buf (get-buffer-create "*Org*")))

          ;; 水平分割主编辑区和右侧区域
          (split-window-horizontally imperial-left-width)

          ;; 配置右侧区域
          (other-window 1)
          ;; 垂直分割右侧区域
          (split-window-vertically right-height)

          ;; 设置右上窗口为 *Messages* 或 *Output* 或 *Compilation*
          (setq imperial-right-windows (list (selected-window) (next-window)))
          (switch-to-buffer messages-buf)
          (set-window-dedicated-p (selected-window) t)
          (set-window-parameter (selected-window) 'no-delete-other-windows t)
          (with-current-buffer messages-buf
            (setq buffer-read-only t)) ;; 设置为只读

          ;; 设置右下窗口为 *Mail* 或 *Org*
          (other-window 1)
          (switch-to-buffer mail-buf)
          (set-window-dedicated-p (selected-window) t)
          (set-window-parameter (selected-window) 'no-delete-other-windows t)
          (with-current-buffer mail-buf
            (setq buffer-read-only t)) ;; 设置为只读

          ;; 确保其他缓冲区也只读
          (with-current-buffer output-buf
            (setq buffer-read-only t))
          (with-current-buffer compilation-buf
            (setq buffer-read-only t))
          (with-current-buffer org-buf
            (setq buffer-read-only t))

          ;; 返回主编辑区
          (other-window 1)
          t))))))