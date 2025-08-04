(package-initialize)
(require 'package)
;;(add-to-list 'package-archives
;;           '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
            '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'load-path "~/.emacs.d/lisp/")
(require 'rainbow-mode)
(require 'imperial-layout)




(load-theme 'imperial-gold t)
(set-frame-position (selected-frame) 0 0)
(set-frame-width (selected-frame) 190)
(set-frame-height (selected-frame) 59)
(custom-set-variables
 '(package-selected-packages
   '(preview-auto gotest-ts colorful-mode lsp-ui org-pdftools go-autocomplete org-translate dot-mode org-evil go-gen-test company-go go-gopath go-complete org-ai rainbow-blocks graphviz-dot-mode go-imports general minimap org-journal async isearch-mb spell-fu ## evil ess slime commenter go-dlv gotest magithub go-eldoc go-guru go-errcheck ffmpeg-player esup use-package org-remark rainbow-mode auto-correct auto-dim-other-buffers python erc rainbow-delimiters popon multiple-cursors minibuffer-header minibuffer-line minibar company-statistics perl-doc ztree pdf-tools org emacsql gited diminish diff-hl magit git-modes go-mode markdown-mode memory-usage)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(rainbow-delimiters-base-error-face ((t (:inherit rainbow-delimiters-base-face :foreground "light green"))))
 '(rainbow-delimiters-base-face ((t (:inherit nil))))
 '(rainbow-delimiters-depth-1-face ((t (:inherit rainbow-delimiters-base-face :foreground "NavajoWhite3"))))
 '(rainbow-delimiters-depth-2-face ((t (:inherit rainbow-delimiters-base-face :foreground "olive drab"))))
 '(rainbow-delimiters-depth-3-face ((t (:inherit rainbow-delimiters-base-face :foreground "firebrick"))))
 '(rainbow-delimiters-depth-4-face ((t (:inherit rainbow-delimiters-base-face :foreground "yellow1"))))
 '(rainbow-delimiters-depth-5-face ((t (:inherit rainbow-delimiters-base-face :foreground "red4"))))
 '(rainbow-delimiters-depth-6-face ((t (:inherit rainbow-delimiters-base-face :foreground "ivory1"))))
 '(rainbow-delimiters-depth-7-face ((t (:inherit rainbow-delimiters-base-face :foreground "DarkOrange4"))))
 '(rainbow-delimiters-depth-8-face ((t (:inherit rainbow-delimiters-base-face :foreground "wheat2"))))
 '(rainbow-delimiters-depth-9-face ((t (:inherit rainbow-delimiters-base-face :foreground "gold1")))))
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
;;关闭默认界面
(setq inhibit-startup-message t)
(tool-bar-mode -1)
(menu-bar-mode 1)
(scroll-bar-mode -1)
(global-font-lock-mode  t)
;;显示时间
(display-time-mode t)
;;设置默认模式
(setq initial-major-mode 'text-mode)
;;显示空白字符
(global-whitespace-mode t)
(setq whitespace-style '(face space tabs trailing lines-tail newline empty tab-mark newline-mark))
;;最近的文件
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(setq recentf-max-saved-items 25)
(global-set-key (kbd "C-x C-r") 'recentf-open-files)
(setq cache-directory "~/.emacs_cache")
;;(setq globalautorevertnonfilebuffers nil)
;;(setq globalautoreverttailedbuffers nil)
;;globalautorevertnonfilebuffers是用于控制非文件缓冲区（如dired缓冲区等）的自动刷新；globalautoreverttailedbuffers用于控制有“tail”模式（如某些日志文件查看模式）的缓冲区自动刷新。
;;如果想完全禁止自动刷新，包括文件内容更新后的自动重新读取，可以使用如下代码：
(setq globalautorevertmode nil)
;;自动刷新
;;(global-auto-revert-mode t)
;;这样设置之后，Emacs就不会自动检查文件是否被外部修改而进行刷新了。
;;要禁止Emacs自动保存，可以在Emacs的初始化文件（.emacs或init.el）中添加以下代码：
(setq auto-save-default nil)
;;这行代码将autosavedefault变量设置为nil，从而关闭自动保存功能。这样Emacs就不会自动为正在编辑的文件创建自动保存文件了。
;; 设置org目录
(setq org-directory "~/Documents/org")
(setq org-export-directory "~/Documents/org/org-exports")












(defun make-node (value left right)
 "Create a binary tree node."
 (list :value value :left left :right right))
(defun print-tree (node indent)
 "Print a binary tree in a readable format."
 (when node
   (print-tree (plist-get node :right) (+ indent 2))
   (insert (make-string indent ?\ ))
   (insert (format "%s\n" (plist-get node :value)))
   (print-tree (plist-get node :left) (+ indent 2))))
;; 创建一个简单的二叉树
;;(setq root (make-node 5
;;                      (make-node 3 (make-node 1 nil nil) (make-node 4 nil nil))
;;                      (make-node 8 nil (make-node 9 nil nil))))
;; 打印二叉树
;;(with-output-to-temp-buffer "*Binary Tree*"
;;  (print-tree root 0))
(defun insert-newline-every-m-chars (m n)
 "Insert a newline every M characters in the current buffer."
 (interactive "nStart line: \nsEnd line: ")
 (let ((start (point-min))
       (end (point-max)))
   (save-excursion
     (goto-char start)
     (while (< (point) end)
       (forward-char m)
       (insert n )))))
;;        (insert "\n")))))










;; 安装 Delve：go install github.com/go-delve/delve/cmd/dlv@latest
;;go install github.com/golangci/lsp/cmd/golangci-lsp@latest
;;go install golang.org/x/tools/gopls@latest
;; company-go：可选的代码补全工具（可与 lsp-go 配合使用）。
;; 调整 lsp-log-level 为 warn 减少日志输出：
;;(global-lsp-mode 1)

(imperial-setup-layout)








(defun go-generate-benchmark-internal ()
  "Generate benchmark buffer including internal functions with naming convention."
  (interactive)
  (unless (eq major-mode 'go-mode)
    (user-error "Not in Go mode"))
  
  (let* ((pkg-name (go-package-name))
         (file-name (file-name-nondirectory (buffer-file-name)))
         (bench-file-name (replace-regexp-in-string "\\.go$" "_benchmark_test.go" file-name))
         (bench-buffer (get-buffer-create bench-file-name))
         (existing-bench-funcs)
         (source-funcs)
         (new-count 0))
    
    (message "🚀 Starting Go benchmark generator: %s" file-name)
    
    ;; 获取所有函数（包括内部函数）
    (save-excursion
      (goto-char (point-min))
      (message "🔍 Scanning all functions...")
      (while (re-search-forward "^func\\s-+\\(?:([^)]+)\\)?\\s-*\\([a-zA-Z0-9_]+\\)\\s-*(" nil t)
        (let ((func-name (match-string-no-properties 1)))
          (cond
           ((string-prefix-p "Benchmark" func-name)
            (message "   ⚠️ Skipping benchmark function: %s" func-name))
           ((string= "main" func-name)
            (message "   ⚠️ Skipping main function"))
           (t
            (message "   ✅ Found function: %s" func-name)
            (push (cons func-name (match-beginning 0)) source-funcs)))))
      (message "🔍 Found %d functions" (length source-funcs)))
    
    (setq source-funcs (nreverse source-funcs))
    
    ;; 获取现有基准测试函数
    (with-current-buffer bench-buffer
      (goto-char (point-min))
      (message "🔍 Checking existing benchmarks...")
      (while (re-search-forward "^func\\s-+\\(Benchmark_[a-zA-Z0-9_]+\\|Benchmark[A-Z][a-zA-Z0-9_]*\\)\\s-*(b \\*testing\\.B)" nil t)
        (push (match-string-no-properties 1) existing-bench-funcs)))
    
    ;; 切换到基准测试缓冲区
    (switch-to-buffer bench-buffer)
    (go-mode)
    
    (message "✏️ Preparing benchmark file: %s" bench-file-name)
    (when (= (buffer-size) 0)
      (message "   📄 Creating new benchmark file...")
      (insert (format "package %s\n\n" pkg-name)
              "import \"testing\"\n\n")
      (setq buffer-undo-list nil))
    
    ;; 为每个函数生成基准测试
    (dolist (func-record source-funcs)
      (let* ((func-name (car func-record))
             (is-internal (string-match-p "^[[:lower:]]" func-name))
             (bench-name (if is-internal 
                             (concat "Benchmark_" func-name) 
                           (concat "Benchmark" func-name)))
             (param-exist (save-excursion
                            (with-current-buffer (current-buffer)
                              (goto-char (cdr func-record))
                              (re-search-forward "func\\s-+.*?\\s-*(" (line-end-position) t)
                              (looking-at-p "[^)]+)")))))
        
        (unless (member bench-name existing-bench-funcs)
          (message "   🚧 Generating benchmark for: %s → %s" func-name bench-name)
          (save-excursion
            (goto-char (point-max))
            (when (> (current-column) 0) (insert "\n"))
            (insert (format "// %s benchmarks the %s function\n" bench-name func-name))
            (insert (format "func %s(b *testing.B) {\n" bench-name))
            (insert "\t// Setup benchmark environment\n")
            
            ;; 添加参数初始化
            (when param-exist
              (insert (format "\t// Initialize function parameters for %s\n" func-name))
              (insert "\t// Example: param1 := value1, param2 := value2\n"))
            
            (insert "\n")
            (insert "\tb.ResetTimer()\n")
            (insert "\tb.ReportAllocs()\n")
            (insert "\tfor i := 0; i < b.N; i++ {\n")
            
            ;; 函数调用
            (insert (format "\t\t%s(", func-name))
            (when param-exist
              (insert "/* parameters */"))
            (insert ")\n")
            
            (insert "\t}\n")
            (insert "}\n\n"))
          (setq new-count (1+ new-count)))))
    
    ;; 保存和格式代码
    (if (> new-count 0)
        (progn
          (message "🔧 Formatting and saving benchmark file...")
          (save-buffer)
          (gofmt)
          (message "🎉 Success! Generated %d new benchmark functions" new-count))
      (message "🌟 Nothing new to generate. All benchmarks are up to date!"))))

;; 添加快捷键绑定
(eval-after-load 'go-mode
  '(define-key go-mode-map (kbd "C-c b") 'go-generate-benchmark-internal))




(defun go-generate-test-buffer ()
  "Generate test buffer for current Go file, adding tests only for missing functions."
  (interactive)
  (unless (eq major-mode 'go-mode)
    (user-error "Not in Go mode"))
  
  (let* ((pkg-name (go-package-name))
         (file-name (file-name-nondirectory (buffer-file-name)))
         (test-file-name (replace-regexp-in-string "\\.go$" "_test.go" file-name))
         (test-buffer (get-buffer-create test-file-name))
         (existing-test-funcs)
         (source-funcs))
    
    ;; 获取当前文件中所有导出函数名
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "^func\\s-+(?\\([a-zA-Z0-9_* \t\n]*\\))?\\s-*\\([A-Z][a-zA-Z0-9_]*\\)\\s-*(" nil t)
        (let ((func-name (match-string-no-properties 2)))
          (unless (or (string-prefix-p "Test" func-name)
                      (string= "main" func-name))
            (push func-name source-funcs)))))
    
    (setq source-funcs (nreverse source-funcs))
    
    ;; 获取测试文件中已经存在的测试函数
    (with-current-buffer test-buffer
      (goto-char (point-min))
      (while (re-search-forward "^func\\s-+Test\\([A-Z][a-zA-Z0-9_]*\\)\\s-*(t \\*testing\\.T)" nil t)
        (push (match-string-no-properties 1) existing-test-funcs)))
    
    ;; 切换到测试缓冲区
    (switch-to-buffer test-buffer)
    (go-mode)
    
    (when (= (buffer-size) 0)
      ;; 如果是新文件，添加基本模板
      (insert (format "package %s\n\n" pkg-name)
              "import \"testing\"\n\n")
      (setq buffer-undo-list nil)) ; 避免把文件创建记入undo列表
    
    ;; 为缺失的函数生成测试模板
    (dolist (func-name source-funcs)
      (unless (member func-name existing-test-funcs)
        ;; 在文件末尾插入新测试
        (save-excursion
          (goto-char (point-max))
          (when (> (current-column) 0) (insert "\n"))
          (insert (format "func Test%s(t *testing.T) {\n" func-name)
                  "\tt.Run(\"test-case\", func(t *testing.T) {\n"
                  "\t\t// TODO: 测试实现\n"
                  "\t})\n"
                  "}\n\n"))))
    
    ;; 保存和格式代码
    (when (buffer-modified-p)
      (save-buffer)
      (gofmt))
    (message "Generated %d new test functions" 
             (- (length source-funcs) (length existing-test-funcs)))))

;; 添加快捷键
(eval-after-load 'go-mode
  '(define-key go-mode-map (kbd "C-c C-t") 'go-generate-test-buffer))



(defun go-generate-benchmark-internal ()
  "Generate benchmark buffer including internal functions with naming convention."
  (interactive)
  (unless (eq major-mode 'go-mode)
    (user-error "Not in Go mode"))
  
  (let* ((pkg-name (go-package-name))
         (file-name (file-name-nondirectory (buffer-file-name)))
         (bench-file-name (replace-regexp-in-string "\\.go$" "_benchmark_test.go" file-name))
         (bench-buffer (get-buffer-create bench-file-name))
         (existing-bench-funcs)
         (source-funcs)
         (new-count 0))
    
    (message "🚀 Starting Go benchmark generator: %s" file-name)
    
    ;; 获取所有函数（包括内部函数）
    (save-excursion
      (goto-char (point-min))
      (message "🔍 Scanning all functions...")
      (while (re-search-forward "^func\\s-+\\(?:([^)]+)\\)?\\s-*\\([a-zA-Z0-9_]+\\)\\s-*(" nil t)
        (let ((func-name (match-string-no-properties 1)))
          (cond
           ((string-prefix-p "Benchmark" func-name)
            (message "   ⚠️ Skipping benchmark function: %s" func-name))
           ((string= "main" func-name)
            (message "   ⚠️ Skipping main function"))
           (t
            (message "   ✅ Found function: %s" func-name)
            (push (cons func-name (match-beginning 0)) source-funcs)))))
      (message "🔍 Found %d functions" (length source-funcs)))
    
    (setq source-funcs (nreverse source-funcs))
    
    ;; 获取现有基准测试函数
    (with-current-buffer bench-buffer
      (goto-char (point-min))
      (message "🔍 Checking existing benchmarks...")
      (while (re-search-forward "^func\\s-+\\(Benchmark_[a-zA-Z0-9_]+\\|Benchmark[A-Z][a-zA-Z0-9_]*\\)\\s-*(b \\*testing\\.B)" nil t)
        (push (match-string-no-properties 1) existing-bench-funcs)))
    
    ;; 切换到基准测试缓冲区
    (switch-to-buffer bench-buffer)
    (go-mode)
    
    (message "✏️ Preparing benchmark file: %s" bench-file-name)
    (when (= (buffer-size) 0)
      (message "   📄 Creating new benchmark file...")
      (insert (format "package %s\n\n" pkg-name)
              "import \"testing\"\n\n")
      (setq buffer-undo-list nil))
    
    ;; 为每个函数生成基准测试
    (dolist (func-record source-funcs)
      (let* ((func-name (car func-record))
             (is-internal (string-match-p "^[[:lower:]]" func-name))
             (bench-name (if is-internal 
                             (concat "Benchmark_" func-name) 
                           (concat "Benchmark" func-name)))
             (param-exist (save-excursion
                            (with-current-buffer (current-buffer)
                              (goto-char (cdr func-record))
                              (re-search-forward "func\\s-+.*?\\s-*(" (line-end-position) t)
                              (looking-at-p "[^)]+)")))))
        
        (unless (member bench-name existing-bench-funcs)
          (message "   🚧 Generating benchmark for: %s → %s" func-name bench-name)
          (save-excursion
            (goto-char (point-max))
            (when (> (current-column) 0) (insert "\n"))
            (insert (format "// %s benchmarks the %s function\n" bench-name func-name))
            (insert (format "func %s(b *testing.B) {\n" bench-name))
            (insert "\t// Setup benchmark environment\n")
            
            ;; 添加参数初始化
            (when param-exist
              (insert (format "\t// Initialize function parameters for %s\n" func-name))
              (insert "\t// Example: param1 := value1, param2 := value2\n"))
            
            (insert "\n")
            (insert "\tb.ResetTimer()\n")
            (insert "\tb.ReportAllocs()\n")
            (insert "\tfor i := 0; i < b.N; i++ {\n")
            
            ;; 函数调用
            (insert (format "\t\t%s(", func-name))
            (when param-exist
              (insert "/* parameters */"))
            (insert ")\n")
            
            (insert "\t}\n")
            (insert "}\n\n"))
          (setq new-count (1+ new-count)))))
    
    ;; 保存和格式代码
    (if (> new-count 0)
        (progn
          (message "🔧 Formatting and saving benchmark file...")
          (save-buffer)
          (gofmt)
          (message "🎉 Success! Generated %d new benchmark functions" new-count))
      (message "🌟 Nothing new to generate. All benchmarks are up to date!"))))

;; 添加快捷键绑定
(eval-after-load 'go-mode
  '(define-key go-mode-map (kbd "C-c b") 'go-generate-benchmark-internal))


