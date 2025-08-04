(defvar imperial-right-windows nil "存储右侧两个窗口对象的列表") (defvar imperial-left-width 70 "左侧主编辑区固定宽度")

(defun imperial-setup-layout ()
  "创建固定50字符宽度的主编辑区和右侧共享缓冲区区域"
  (interactive)
  (when (one-window-p) ; 只有一个窗口时才创建布局
    ;; 检查窗口宽度是否足够
    (when (> (window-width) (+ imperial-left-width 20)) ; 右侧至少20字符
      (let* ((right-width (- (window-width) imperial-left-width))
             (right-height (round (/ (window-height) 2.0)))
             (messages-buf (get-buffer-create "*Messages*"))
             (output-buf (get-buffer-create "*Output*")))
        
        ;; 水平分割主编辑区和右侧区域
        (split-window-horizontally imperial-left-width)
        
        ;; 配置右侧区域
        (other-window 1)
        ;; 垂直分割右侧区域
        (split-window-vertically right-height)
        
        ;; 存储右侧窗口对象
        (setq imperial-right-windows (list (selected-window) (next-window)))
        
        ;; 设置消息缓冲区
        (switch-to-buffer messages-buf)
        (set-window-dedicated-p (selected-window) t)
        (set-window-parameter (selected-window) 'no-delete-other-windows t)
        
        ;; 设置输出缓冲区
        (other-window 1)
        (switch-to-buffer output-buf)
        (set-window-dedicated-p (selected-window) t)
        (set-window-parameter (selected-window) 'no-delete-other-windows t)
        ;;(output-mode) ; 自定义的输出模式
        
        ;; 返回主编辑区
        (other-window 1)
        t)))) ; 返回t表示布局已设置

;; 配置display-buffer-alist规则
(setq display-buffer-alist
      `(;; Messages缓冲区显示在右上方
        ("\\*Messages\\*"
         (display-buffer-in-side-window)
         (side . right)
         (slot . 0)
         (window-width . ,(- (frame-width) imperial-left-width))
         (window-height . 0.7)
         (dedicated . t)
         (reusable-frames . visible))
        
        ;; Output缓冲区显示在右下方
        ("\\*Output\\*"
         (display-buffer-in-side-window)
         (side . right)
         (slot . 1)
         (window-width . ,(- (frame-width) imperial-left-width))
         (window-height . 0.3)
         (dedicated . t)
         (reusable-frames . visible))
        
        ;; 默认情况在主窗口显示
        (".*"
         (display-buffer-same-window))))

;; 窗口大小变化处理 not worthy 
(defun imperial-window-size-change-handler (frame)
  "响应窗口大小变化，保持左侧50字符宽度"
  (when (and (eq frame (selected-frame))
             imperial-right-windows)
    (let* ((current-left (nth 0 (window-edges)))
           (current-width (nth 2 (window-edges))))
      (when (and (window-live-p (car imperial-right-windows))
                 (window-live-p (cadr imperial-right-windows)))
        (with-selected-window (car imperial-right-windows)
          (window-resize (selected-window) 
                         (- imperial-left-width current-left) 
                         t))
        
        ;; 垂直平衡右侧窗口
        (balance-windows-area))))
  )

(add-hook 'window-size-change-functions 'imperial-window-size-change-handler)

;; 保护布局的函数
(defun imperial-protect-layout ()
  "防止意外破坏布局"
  (when imperial-right-windows
    (let ((main-window (get-buffer-window)))
      (dolist (win (window-list))
        (unless (or (eq win main-window)
                    (member win imperial-right-windows))
          (delete-window win))
        
        ;; 左侧窗口宽度强制50字符
        (when (and (eq win main-window)
                   (window-resizable win 
                                     (- imperial-left-width (window-width))
                                     t))
          (window-resize win 
                         (- imperial-left-width (window-width))
                         t))))))

(add-hook 'window-configuration-change-hook 'imperial-protect-layout)

;; prog-mode钩子函数
(defun imperial-prog-mode-setup ()
  "prog-mode钩子函数，自动设置固定宽度布局"
  (when (derived-mode-p 'prog-mode)
    (unless imperial-right-windows
      (imperial-setup-layout)
      ;; 初始化输出缓冲区
      (with-current-buffer (get-buffer "*Output*")
       ;; (output-mode)
        (setq buffer-read-only nil)
        (erase-buffer)
        (insert "输出缓冲区已准备好\n")
        (setq buffer-read-only t)))
    
    ;; 确保相关缓冲区显示在正确位置
    (display-buffer (get-buffer "*Messages*"))
    (display-buffer (get-buffer "*Output*"))))

;; 添加到prog-mode钩子
(add-hook 'prog-mode-hook 'imperial-prog-mode-setup)


(provide 'imperial-layout)
