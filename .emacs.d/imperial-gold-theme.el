(deftheme imperial-gold "帝王金主题")

;; 御用配色方案
(defvar imperial-gold/colors
  '((midnight-bg   . "#0a0814")    ; 玄夜背景
    (royal-blood   . "#c23b3b")    ; 函数/变量定义血色
    (imperial-gold . "#e6b422")    ; 注释金色
    (ivory-milk    . "#fffaf0")    ; 普通字符乳白
    (cream-highlight . "#fffee6") ; 高亮乳白
    (gold-light    . "#ffed8a")    ; 辅助金色
    (crimson-shadow . "#3c1d22")   ; 血色阴影
    (regal-purple  . "#5d3a9b")    ; 装饰紫色
    (inactive-bg   . "#1f1b24")    ; 非激活模式行背景
    (inactive-fg   . "#a89159")))  ; 非激活模式行前景

(custom-theme-set-faces
 'imperial-gold
 ;; == 核心规则 ==
 `(default ((t :background ,(cdr (assoc 'midnight-bg imperial-gold/colors))
            :foreground ,(cdr (assoc 'ivory-milk imperial-gold/colors)))))
  
 ;; == 语法高亮 ==
 ;; 所有普通字符乳白（包括关键字、符号、字符串等）
 (dolist (face '(font-lock-keyword-face
                font-lock-builtin-face
                font-lock-constant-face
                font-lock-type-face
                font-lock-doc-face
                font-lock-string-face
                font-lock-warning-face))
   (set-face-attribute face nil :foreground (cdr (assoc 'ivory-milk imperial-gold/colors))))

 ;; 函数/变量定义处 - 血色
 `(font-lock-function-name-face ((t :foreground ,(cdr (assoc 'royal-blood imperial-gold/colors)) :bold t)))
 `(font-lock-variable-name-face ((t :foreground ,(cdr (assoc 'royal-blood imperial-gold/colors)))))

 ;; 注释 - 金色
 `(font-lock-comment-face ((t :foreground ,(cdr (assoc 'imperial-gold imperial-gold/colors)) :italic t)))

 ;; == UI元素 ==
 `(mode-line ((t :background ,(cdr (assoc 'crimson-shadow imperial-gold/colors))
                 :foreground ,(cdr (assoc 'cream-highlight imperial-gold/colors))
                 :box nil
                 :height 1.05)))
 `(mode-line-inactive ((t :background ,(cdr (assoc 'inactive-bg imperial-gold/colors)) 
                        :foreground ,(cdr (assoc 'inactive-fg imperial-gold/colors)))))
 `(cursor ((t :background ,(cdr (assoc 'gold-light imperial-gold/colors)))))
 `(region ((t :background ,(cdr (assoc 'crimson-shadow imperial-gold/colors)))))

 ;; 智能👆指示器（当前buffer）
 `(mode-line-buffer-id ((t :weight ultra-bold :foreground ,(cdr (assoc 'cream-highlight imperial-gold/colors)))))

 ;; == Go mode specific faces ==
 ;; 如果go-mode定义了这些face，我们将它们设置为乳白（非标准face）
 `(go-directive-face ((t :foreground ,(cdr (assoc 'ivory-milk imperial-gold/colors)))))
 `(go-err-face ((t :foreground ,(cdr (assoc 'ivory-milk imperial-gold/colors)))))
 `(go-label-face ((t :foreground ,(cdr (assoc 'ivory-milk imperial-gold/colors)))))
 `(go-type-name-face ((t :foreground ,(cdr (assoc 'ivory-milk imperial-gold/colors)))))
 )

;; == 动态👆指示器系统 ==
(setq-default mode-line-format
              (list
               '(:eval (if (eq (current-buffer) (window-buffer (selected-window)))
                          (propertize "👆懂不懂啊  " 
                                      'face `(:background ,(cdr (assoc 'royal-blood imperial-gold/colors))
                                              :foreground ,(cdr (assoc 'cream-highlight imperial-gold/colors))))
                        (propertize "👉" 
                                    'face `(:background ,(cdr (assoc 'inactive-bg imperial-gold/colors))
                                            :foreground ,(cdr (assoc 'inactive-fg imperial-gold/colors))))))
               " %b "  ; 缓冲区名
               "| "
               mode-line-position
               " "
               mode-line-modes
               mode-line-misc-info))


;; == GO语言专属配置 ==
(defun imperial-gold/go-mode-hook ()
  "专为Go语言设计的视觉规则"
  ;; 函数定义 - 血色高亮
  (set-face-attribute 'go-func-face nil 
                      :foreground (cdr (assoc 'royal-blood imperial-gold/colors))
                      :bold t)
  
  ;; 变量定义 - 血色无加粗
  (set-face-attribute 'go-var-name-face nil 
                      :foreground (cdr (assoc 'royal-blood imperial-gold/colors)))
  
  ;; 注释 - 帝王金
  (set-face-attribute 'go-comment-face nil 
                      :foreground (cdr (assoc 'imperial-gold imperial-gold/colors))
                      :italic t)
  
  ;; 其他元素统一乳白
  (dolist (face '(go-keyword-face 
                 go-builtin-face
                 go-type-face 
                 go-string-face 
                 go-constant-face))
    (set-face-attribute face nil 
                       :foreground (cdr (assoc 'ivory-milk imperial-gold/colors))))

  ;; 结构体字段特别高亮
  (set-face-attribute 'go-field-name-face nil 
                     :foreground (cdr (assoc 'gold-light imperial-gold/colors))
                     :underline t))

(add-hook 'go-mode-hook 'imperial-gold/go-mode-hook)

(provide-theme 'imperial-gold)