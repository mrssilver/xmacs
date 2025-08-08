(defvar imperial-right-windows nil "存储右侧两个窗口对象的列表")
(defvar imperial-left-width 70 "主编辑区固定宽度为70字符")
(defvar imperial-compilation-buffer-prefixes '("hand" "org") "右下窗口缓冲区名匹配的前缀/后缀")

(defun imperial-make-buffer-read-only ()
  "为特定缓冲区设置只读属性"
  (when (member (buffer-name) '("*Messages*" "*Output*" "*Compilation*"))
    (setq buffer-read-only t)))

(add-hook 'buffer-list-update-hook 'imperial-make-buffer-read-only)

(defun imperial-get-hand-org-buffer ()
  "智能获取匹配的缓冲区：优先匹配前缀/后缀，后匹配包含子串"
  (catch 'found
    (dolist (buf (buffer-list))
      (let ((name (buffer-name buf)))
        (when name
          ;; 1. 优先级1: 完全匹配前缀或后缀
          (when (or (cl-some (lambda (prefix) (string-prefix-p prefix name)) 
                             imperial-compilation-buffer-prefixes)
                    (cl-some (lambda (suffix) (string-suffix-p suffix name t)) 
                             imperial-compilation-buffer-prefixes))
            (throw 'found buf))
          
          ;; 2. 优先级2: 包含前缀或后缀
          (when (cl-some (lambda (str) (string-match-p str name))
                         imperial-compilation-buffer-prefixes)
            (throw 'found buf)))))
    ;; 默认缓冲区 - handsentence.org
    (let ((new-buf (get-buffer-create "handsentence.org")))
      (with-current-buffer new-buf
        (unless (> (buffer-size) 0) ; 如果是新缓冲区，添加欢迎信息
          (insert ";; Handsentence.org Buffer\n")
          (insert ";; This buffer is for hand-written sentences and notes\n")
          (insert ";; Use it to store important thoughts and ideas\n"))
        (org-mode) ; 启用Org模式
        ;; 移除只读设置，使其可编辑
        (setq buffer-read-only nil))
      new-buf)))

(defun imperial-get-compilation-buffer ()
  "智能获取编译缓冲区"
  (cond
   ((get-buffer "*Compilation*") (get-buffer "*Compilation*"))
   ((get-buffer "*Output*") (get-buffer "*Output*"))
   (t (get-buffer-create "*Compilation*"))))

(defun imperial-setup-layout ()
  "强制重新布局，右上显示编译缓冲区"
  (interactive)
  (let ((current-buffer (current-buffer)))
    ;; 1. 删除所有窗口
    (delete-other-windows)
    
    ;; 2. 创建基础布局
    (split-window-horizontally imperial-left-width)
    (other-window 1)
    
    ;; 3. 计算右侧区域尺寸
    (let* ((right-height (round (/ (window-height) 2.0)))
           (compilation-buf (imperial-get-compilation-buffer))
           (hand-org-buf (imperial-get-hand-org-buffer)))
      
      ;; 4. 分割右侧区域
      (split-window-vertically right-height)
      
      ;; 5. 设置右上窗口（编译缓冲区）
      (switch-to-buffer compilation-buf)
      (set-window-dedicated-p (selected-window) t)
      (imperial-make-buffer-read-only)
      (set-window-parameter (selected-window) 'no-delete-other-windows t)
      (compilation-minor-mode t) ; 启用编译小模式
      
      ;; 6. 设置右下窗口（hand/org缓冲区）
      (other-window 1)
      (switch-to-buffer hand-org-buf)
      (set-window-dedicated-p (selected-window) t)
      (set-window-parameter (selected-window) 'no-delete-other-windows t)
      ;; 移除只读设置，使其可编辑
      (setq buffer-read-only nil)
      
      ;; 7. 如果是handsentence.org，确保启用Org模式
      (when (string= (buffer-name) "handsentence.org")
        (org-mode))
      
      ;; 8. 存储右侧窗口对象
      (setq imperial-right-windows (list (previous-window) (selected-window)))
    
    ;; 9. 返回主编辑区
    (other-window -1)
    (switch-to-buffer current-buffer) ; 保留原来的缓冲区
    
    ;; 10. 返回成功
    t))

;; 编译处理函数 - 右上显示编译输出
(defun imperial-show-compilation-top-right (proc)
  "在右上区域显示编译输出"
  (let ((compilation-buf (process-buffer proc)))
    (when compilation-buf
      ;; 确保布局存在
      (unless (and imperial-right-windows
                   (window-live-p (car imperial-right-windows))
                   (window-live-p (cadr imperial-right-windows)))
        (imperial-setup-layout))
      
      ;; 在右上窗口显示编译输出
      (with-selected-window (car imperial-right-windows)
        (switch-to-buffer compilation-buf)
        (setq buffer-read-only t)
        (compilation-minor-mode t))
      
      ;; 刷新右下区域
      (when imperial-right-windows
        (let ((bottom-right-window (cadr imperial-right-windows)))
          (when (window-live-p bottom-right-window)
            (with-selected-window bottom-right-window
              (let ((hand-org-buf (imperial-get-hand-org-buffer)))
                (switch-to-buffer hand-org-buf)
                ;; 移除只读设置，使其可编辑
                (setq buffer-read-only nil)
                ;; 如果是handsentence.org，确保启用Org模式
                (when (string= (buffer-name) "handsentence.org")
                  (org-mode)))))))
      
      ;; 添加编译后钩子
      (add-hook 'compilation-finish-functions 
                (lambda (buffer status)
                  (message "编译完成: %s" status)) nil t))))

;; 编译启动钩子
(add-hook 'compilation-start-hook 'imperial-show-compilation-top-right)

;; 自动布局管理器
(defun imperial-auto-layout-manager ()
  "智能布局管理器，在需要时设置布局"
  (when (or (derived-mode-p 'prog-mode)
            (derived-mode-p 'text-mode)
            (cl-some (lambda (prefix) (string-prefix-p prefix (buffer-name)))
                     imperial-compilation-buffer-prefixes)
            (cl-some (lambda (suffix) (string-suffix-p suffix (buffer-name) t))
                     imperial-compilation-buffer-prefixes))
    (imperial-setup-layout)))

;; 自动布局触发器
(add-hook 'prog-mode-hook 'imperial-auto-layout-manager)
(add-hook 'text-mode-hook 'imperial-auto-layout-manager)
(add-hook 'compilation-filter-hook 'imperial-auto-layout-manager)

;; 布局保护函数
(defun imperial-protect-layout ()
  "保护布局不被破坏"
  (when imperial-right-windows
    ;; 确保左侧宽度正确
    (when (window-resizable nil (- imperial-left-width (window-width)) t)
      (window-resize nil (- imperial-left-width (window-width)) t))
    
    ;; 检查并恢复可能被关闭的右侧窗口
    (unless (window-live-p (nth 0 imperial-right-windows))
      (save-excursion
        (ignore-errors
          (select-window (get-largest-window))
          (split-window-horizontally imperial-left-width)
          (other-window 1)
          (split-window-vertically (round (/ (window-height) 2.0)))
          (setq imperial-right-windows (list (previous-window) (selected-window))))))
    
    ;; 确保右侧缓冲区显示正确
    (dolist (win imperial-right-windows)
      (when (window-live-p win)
        (select-window win)
        (cond
         ((eq win (car imperial-right-windows)) ; 右上窗口
          (unless (or (string= (buffer-name) "*Compilation*")
                      (string= (buffer-name) "*Output*"))
            (switch-to-buffer (imperial-get-compilation-buffer))
            (setq buffer-read-only t)))
         ((eq win (cadr imperial-right-windows)) ; 右下窗口
          (unless (member (buffer-name) (mapcar #'buffer-name (buffer-list)))
            (switch-to-buffer (imperial-get-hand-org-buf))
            ;; 移除只读设置，使其可编辑
            (setq buffer-read-only nil)
            ;; 如果是handsentence.org，确保启用Org模式
            (when (string= (buffer-name) "handsentence.org")
              (org-mode))))))
    
    ;; 返回主编辑区
    (select-window (get-largest-window))))

(add-hook 'window-configuration-change-hook 'imperial-protect-layout)

(provide 'imperial-layout)
