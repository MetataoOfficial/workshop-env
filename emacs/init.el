;; =============================================================================
;;                         EMACS 30 现代版快速参考指南 (2025)
;; =============================================================================
;;
;;  [核心逻辑]
;;  - Leader Key: <SPC> (所有操作的起点，Vim Normal 模式下触发)
;;  - 统一跳转: <SPC> s s (不论 Python、LaTeX 或 Markdown，以此弹出结构大纲)
;;  - 智能补全: 搜索时支持模糊匹配 (例如: 输入 "pymo" 可匹配 "python-mode")
;;
;;  [1. 文件与项目 (Files & Project)]
;;  - <SPC> f f  : 打开/新建文件 (Find file)
;;  - <SPC> f r  : 最近打开的文件 (Recent files)
;;  - <SPC> f s  : 保存当前文件
;;  - <SPC> p p  : 切换项目 (Projectile)
;;  - <SPC> TAB  : 极速切换 Buffer (Consult)
;;
;;  [2. 搜索与结构跳转 (Search & Structure)] - **核心需求实现**
;;  - <SPC> s s  : [弹出大纲] 快速跳转至函数(Py)、章节(TeX)、标题(MD/Org)
;;  - <SPC> s p  : [项目符号] 在整个项目中搜索函数定义
;;  - <SPC> s l  : [行内搜索] 模糊搜索当前文件内容 (替代 Swiper)
;;
;;  [3. 编程开发 (Coding - Python/LaTeX/LSP)]
;;  - <SPC> c a  : 执行代码动作 (Code Actions, 如修复建议)
;;  - <SPC> c r  : 变量重命名 (Rename)
;;  - <SPC> c d  : 跳转到定义 (Definition)
;;  - K          : (Normal模式) 查看光标处函数文档 (LSP)
;;  - gcc        : 注释/取消注释当前行
;;
;;  [4. 窗口与导航 (Window & Nav)]
;;  - <SPC> w h/j/k/l : 切换左/下/上/右窗口
;;  - <SPC> w v  : 左右分屏 | <SPC> w s : 上下分屏
;;  - C-x u      : 弹出 Vundo (可视化撤销树，方向键导航)
;;
;;  [5. 版本控制与工具 (Git & Tools)]
;;  - <SPC> g s  : Magit Status (Git 管理神器)
;;  - <SPC> q r  : 重启 Emacs
;;
;;  [提示]
;;  - 如果按完 <SPC> 后停顿 0.5s，底部会弹出 Which-key 提示后续键位。
;;  - 本配置自动加载 custom.el 和 custom.org (Tangle)。
;; =============================================================================

;;; init.el --- Robust Modern Emacs 30 Config

;; ===============================
;; 1. 性能优化与系统环境
;; ===============================
(setq gc-cons-threshold (* 100 1024 1024))
(setq read-process-output-max (* 1024 1024))
(setq inhibit-compacting-font-caches t)

(defvar *sys/win64* (eq system-type 'windows-nt))
(defvar *sys/macos* (eq system-type 'darwin))
(defvar *sys/linux* (or (eq system-type 'gnu/linux) (eq system-type 'linux)))

;; ===============================
;; 2. 包管理 (ELPA 镜像)
;; ===============================
(require 'package)
(setq package-archives
      '(("gnu"    . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
        ("melpa"  . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
        ("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")))

(unless (bound-and-true-p package--initialized) (package-initialize))
(require 'use-package)
(setq use-package-always-ensure t)

;; ===============================
;; 3. 基础组件与撤销系统 (提前加载以供 Evil 使用)
;; ===============================
(use-package vundo
  :commands vundo
  :config (setq vundo-compact-display t))

(use-package projectile
  :init (projectile-mode 1)
  :config (setq projectile-project-search-path '("~/projects" "~/work")))

;; ===============================
;; 4. Evil 核心 (修正 Undo System 报错)
;; ===============================
(use-package evil
  :init
  (setq evil-want-keybinding nil)
  (setq evil-want-integration t)
  :config
  (evil-mode 1)
  ;; 确保在 config 阶段设置，此时 vundo 已被识别
  (setq evil-undo-system 'vundo))

(use-package evil-collection
  :after evil
  :config (evil-collection-init))

;; ===============================
;; 5. 统一 Leader Key (修正 Autoload 报错)
;; ===============================
(use-package general :config (general-evil-setup))

;; 将定义移出 use-package 宏，避免 Emacs 30 的严格 keymap 检查
(general-create-definer my/leader-key
  :states '(normal insert visual emacs)
  :keymaps 'override
  :prefix "SPC"
  :global-prefix "C-SPC")

(my/leader-key
  "SPC" '(execute-extended-command :which-key "M-x")
  "TAB" '(consult-buffer :which-key "切换Buffer")
  "f" '(:ignore t :which-key "文件")
  "ff" 'find-file
  "fr" 'recentf-open-files
  "fs" 'save-buffer
  "s" '(:ignore t :which-key "搜索/结构")
  "ss" '(consult-imenu :which-key "弹出大纲结构")
  "sl" '(consult-line :which-key "当前行搜索")
  "sp" '(consult-project-imenu :which-key "项目符号跳转")
  "w" 'evil-window-map
  "g" '(magit-status :which-key "Git状态")
  "p" '(projectile-command-map :which-key "项目工程"))

;; ===============================
;; 6. UI 与 字体 (适配不同平台)
;; ===============================
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode 1)
(which-key-mode 1)

(defun my/setup-fonts ()
  (let ((font-size (if *sys/win64* 14 16))
        (zh-font (cond (*sys/win64* "Microsoft YaHei")
                       (*sys/macos* "PingFang SC")
                       (t "Noto Sans CJK SC"))))
    (set-face-attribute 'default nil :family "Fira Code" :height (* font-size 10))
    (set-fontset-font t 'han (font-spec :family zh-font))))

(add-hook 'window-setup-hook #'my/setup-fonts)

(use-package doom-themes :config (load-theme 'doom-one t))

;; ===============================
;; 7. 现代补全与编程 (Tree-sitter & LSP)
;; ===============================
(use-package treesit-auto :config (global-treesit-auto-mode))
(use-package vertico :init (vertico-mode 1))
(use-package orderless :custom (completion-styles '(orderless basic)))
(use-package consult)
(use-package marginalia :init (marginalia-mode 1))

(use-package python
  :mode ("\\.py\\'" . python-ts-mode)
  :hook (python-ts-mode . eglot-ensure)
  :config (setq python-imenu-format-item-label-list '("{name} ({type})")))

(use-package tex
  :ensure auctex
  :config
  (setq TeX-auto-save t TeX-parse-self t TeX-engine 'xetex)
  (add-hook 'LaTeX-mode-hook #'outline-minor-mode))

(use-package markdown-mode
  :mode ("\\.md\\'" . gfm-mode)
  :config
  (add-hook 'markdown-mode-hook 'outline-minor-mode)
  (add-hook 'markdown-mode-hook 'markdown-cycle))

;; ===============================
;; 8. Org-Mode 深度集成
;; ===============================
(use-package org
  :config
  (setq org-startup-indented t
        org-hide-emphasis-markers t)
  (setq org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)" "CANCEL(c)"))))

(use-package evil-org
  :after org
  :hook (org-mode . evil-org-mode)
  :config (require 'evil-org-agenda) (evil-org-agenda-set-keys))

;; ===============================
;; 9. 习惯设置与自定义加载
;; ===============================
(setq-default indent-tabs-mode nil tab-width 4)
(global-auto-revert-mode 1)
(recentf-mode 1)
(save-place-mode 1)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; 自动加载外部文件
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file) (load custom-file))

(let ((custom-org (expand-file-name "custom.org" user-emacs-directory)))
  (when (file-exists-p custom-org)
    (org-babel-tangle-file custom-org)
    (load (concat (file-name-sans-extension custom-org) ".el"))))

;; 扫尾
(setq gc-cons-threshold (* 2 1024 1024))
(message ">>> Welcome to the Lisp workshop.")

;; 自定义 Scratch 缓冲显示内容
(setq initial-scratch-message
";;  - Leader Key: <SPC> (所有操作的起点，Vim Normal 模式下触发)
;;  - 统一跳转: <SPC> s s (不论 Python、LaTeX 或 Markdown，以此弹出结构大纲)
;;
;;  [1. 文件与项目 (Files & Project)]
;;  - <SPC> f f  : 打开/新建文件 (Find file)
;;  - <SPC> f r  : 最近打开的文件 (Recent files)
;;  - <SPC> f s  : 保存当前文件
;;  - <SPC> p p  : 切换项目 (Projectile)
;;  - <SPC> TAB  : 极速切换 Buffer (Consult)
;;
;;  [2. 搜索与结构跳转 (Search & Structure)] - **核心需求实现**
;;  - <SPC> s s  : [弹出大纲] 快速跳转至函数(Py)、章节(TeX)、标题(MD/Org)
;;  - <SPC> s p  : [项目符号] 在整个项目中搜索函数定义
;;  - <SPC> s l  : [行内搜索] 模糊搜索当前文件内容 (替代 Swiper)
;;
;;  [3. 编程开发 (Coding - Python/LaTeX/LSP)]
;;  - <SPC> c a  : 执行代码动作 (Code Actions, 如修复建议)
;;  - <SPC> c r  : 变量重命名 (Rename)
;;  - <SPC> c d  : 跳转到定义 (Definition)
;;  - K          : (Normal模式) 查看光标处函数文档 (LSP)
;;  - gcc        : 注释/取消注释当前行
;;
;;  [4. 窗口与导航 (Window & Nav)]
;;  - <SPC> w h/j/k/l : 切换左/下/上/右窗口
;;  - <SPC> w v  : 左右分屏 | <SPC> w s : 上下分屏
;;  - C-x u      : 弹出 Vundo (可视化撤销树，方向键导航)
")

(provide 'init)
