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
    (regal-purple  . "#5d3a9b"))   ; 装饰紫色
  )

(custom-theme-set-faces
 'imperial-gold
 
 ;; == 核心规则 ==
 ;; 普通字符乳白色
 `(default ((t (:background ,(cdr (assoc 'midnight-bg imperial-gold/colors))
                 :foreground ,(cdr (assoc 'ivory-milk imperial-gold/colors))))))
   
 ;; == 语法高亮 ==
 ;; 所有普通字符乳白（包括关键字）
 `(font-lock-keyword-face ((t (:foreground ,(cdr (assoc 'ivory-milk imperial-gold/colors))))))
 `(font-lock-builtin-face ((t (:foreground ,(cdr (assoc 'ivory-milk imperial-gold/colors))))))
 `(font-lock-constant-face ((t (:foreground ,(cdr (assoc 'ivory-milk imperial-gold/colors))))))
 `(font-lock-type-face ((t (:foreground ,(cdr (assoc 'ivory-milk imperial-gold/colors))))))
 `(font-lock-doc-face ((t (:foreground ,(cdr (assoc 'ivory-milk imperial-gold/colors))))))
 
 ;; 函数/变量定义处 - 血色
 `(font-lock-function-name-face ((t (:foreground ,(cdr (assoc 'royal-blood imperial-gold/colors)) :bold t))))
 `(font-lock-variable-name-face ((t (:foreground ,(cdr (assoc 'royal-blood imperial-gold/colors))))))
 
 ;; 注释 - 金色
 `(font-lock-comment-face ((t (:foreground ,(cdr (assoc 'imperial-gold imperial-gold/colors)) :italic t))))
 
 ;; == Go语言增强 ==
 `(go-func-name-face ((t (:inherit font-lock-function-name-face)))) ; Go函数名血色
 `(go-var-name-face ((t (:inherit font-lock-variable-name-face)))) ; Go变量名血色
 
 ;; == UI元素 ==
 `(mode-line ((t (:background ,(cdr (assoc 'crimson-shadow imperial-gold/colors))
                  :foreground ,(cdr (assoc 'cream-highlight imperial-gold/colors))
                  :box nil
                  :height 1.05))))
 `(mode-line-inactive ((t (:background "#1f1b24" 
                             :foreground "#a89159"))))
 `(cursor ((t (:background ,(cdr (assoc 'gold-light imperial-gold/colors))))))
 `(region ((t (:background ,(cdr (assoc 'crimson-shadow imperial-gold/colors))))))
 
 `(mode-line-buffer-id ((t (:weight ultra-bold :foreground ,(cdr (assoc 'cream-highlight imperial-gold/colors))))))
)

;; == 动态👆指示器系统 ==
(defvar imperial-current-indicator " 👆 "
  "当前缓冲区指示器符号")

(defun imperial-update-indicator ()
  "更新当前窗口👆指示器"
  (setq imperial-current-indicator 
        (propertize " 👆 " 
                    'face `(:background ,(cdr (assoc 'royal-blood imperial-gold/colors))
                            :foreground ,(cdr (assoc 'cream-highlight imperial-gold/colors)))))
  (force-mode-line-update))

(setq-default mode-line-format
              (list
               '(:eval imperial-current-indicator) ; 👆指示器
               " %b "  ; 缓冲区名
               "| "
               mode-line-position
               " "
               mode-line-modes
               mode-line-misc-info))

(add-hook 'window-selection-change-functions #'imperial-update-indicator)
(add-hook 'buffer-list-update-hook #'imperial-update-indicator)
(imperial-update-indicator)

(provide-theme 'imperial-gold)

