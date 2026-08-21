;; =============================================================================
;;; init.el --- Robust Modern Emacs 30 Config
;; =============================================================================
;;
;;  [提示]
;;  - 如果按完 <SPC> 后停顿 0.5s，底部会弹出 Which-key 提示后续键位。
;;  - 本配置自动加载 custom.el 和 custom.org (Tangle)。
;;
;; =============================================================================

;; ===============================
;; 1. 性能优化与系统环境
;; ===============================
(setq gc-cons-threshold (* 100 1024 1024))
(setq read-process-output-max (* 1024 1024))
(setq inhibit-compacting-font-caches t)

(defvar *sys/win64* (eq system-type 'windows-nt))
(defvar *sys/macos* (eq system-type 'darwin))
(defvar *sys/linux* (or (eq system-type 'gnu/linux) (eq system-type 'linux)))

;; Fcitx5 must be selected before a GTK/PGTK frame is created.  The real fix
;; lives in the graphical-session environment (.zprofile and Niri config),
;; but keep this fallback for Emacs started by an unusual launcher.
(when (and *sys/linux*
           (or (getenv "DISPLAY") (getenv "WAYLAND_DISPLAY")))
  (setenv "LANG" "zh_CN.UTF-8")
  (setenv "LC_ALL" "zh_CN.UTF-8")
  (setenv "LC_CTYPE" "zh_CN.UTF-8")
  (setenv "GTK_IM_MODULE" "fcitx")
  (setenv "QT_IM_MODULE" "fcitx")
  (setenv "XMODIFIERS" "@im=fcitx"))

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

(require 'cl-lib)
(require 'project)
(require 'seq)
(require 'subr-x)

;; ===============================
;; 3. 基础组件与撤销系统 (提前加载以供 Evil 使用)
;; ===============================
(use-package vundo
  :commands vundo
  :config (setq vundo-compact-display t))

(use-package projectile
  :init (projectile-mode 1)
  :config
  (setq projectile-project-search-path '("~/projects" "~/work")
        projectile-enable-caching t))

;; ===============================
;; 4. Evil 核心 (修正 Undo System 报错)
;; ===============================
(use-package evil
  :init
  (setq evil-want-keybinding nil)
  (setq evil-want-integration t
        evil-cross-lines t
        evil-respect-visual-line-mode t
        evil-search-module 'evil-search
        evil-ex-search-vim-style-regexp t)
  :config
  (evil-mode 1)
  ;; 确保在 config 阶段设置，此时 vundo 已被识别
  (setq evil-undo-system 'vundo
        evil-default-state 'normal
        evil-insert-state-cursor '(bar "green")
        evil-normal-state-cursor '(box "orange")))

(use-package evil-collection
  :after evil
  :config (evil-collection-init))

(use-package evil-commentary
  :after evil
  :config (evil-commentary-mode 1))

(use-package evil-matchit
  :after evil
  :config (global-evil-matchit-mode 1))

;; ===============================
;; 5. 统一 Leader Key (修正 Autoload 报错)
;; ===============================
(use-package general :config (general-evil-setup))

;; Use a real prefix map.  `general-override-mode-map' is state-aware, but
;; recent General/Evil combinations do not always expose its intercept map to
;; `key-binding' in Evil's Normal state.  An explicit map keeps SPC reliable.
(defvar my/leader-map (make-sparse-keymap)
  "Leader keymap shared by Evil Normal and Visual states.")

(general-create-definer my/leader-key
  :keymaps 'my/leader-map)

(my/leader-key
  "SPC" '(execute-extended-command :which-key "M-x")
  "TAB" '(consult-buffer :which-key "切换Buffer")
  "f" '(:ignore t :which-key "文件")
  "ff" 'find-file
  "fr" 'recentf-open-files
  "fs" 'save-buffer
  "fd" '(dired-jump :which-key "打开目录")
  "fb" '(consult-buffer :which-key "Buffer列表")
  "fg" '(consult-ripgrep :which-key "全文搜索")
  "fh" '(apropos-command :which-key "搜索帮助")
  "b" '(:ignore t :which-key "Buffer")
  "bb" '(consult-buffer :which-key "切换Buffer")
  "bd" '(kill-current-buffer :which-key "关闭Buffer")
  "s" '(:ignore t :which-key "搜索/结构")
  "ss" '(consult-imenu :which-key "弹出大纲结构")
  "sl" '(consult-line :which-key "当前行搜索")
  "sg" '(consult-ripgrep :which-key "项目全文搜索")
  "sp" '(consult-project-imenu :which-key "项目符号跳转")
  "/" '(evil-ex-nohighlight :which-key "清除搜索高亮")
  "w" '(:ignore t :which-key "窗口")
  "wh" '(windmove-left :which-key "左窗口")
  "wj" '(windmove-down :which-key "下窗口")
  "wk" '(windmove-up :which-key "上窗口")
  "wl" '(windmove-right :which-key "右窗口")
  "wv" '(split-window-right :which-key "左右分屏")
  "ws" '(split-window-below :which-key "上下分屏")
  "wc" '(delete-window :which-key "关闭窗口")
  "wd" '(delete-other-windows :which-key "保留当前窗口")
  "g" '(:ignore t :which-key "Git")
  "gs" '(magit-status :which-key "Git状态")
  "gb" '(magit-blame-addition :which-key "当前文件Blame")
  "p" '(projectile-command-map :which-key "项目工程")
  "c" '(:ignore t :which-key "代码/LSP")
  "ca" '(eglot-code-actions :which-key "代码动作")
  "cd" '(xref-find-definitions :which-key "跳转定义")
  "ci" '(xref-find-implementations :which-key "跳转实现")
  "co" '(xref-find-references :which-key "查看引用")
  "cr" '(eglot-rename :which-key "重命名符号")
  "ce" '(flymake-show-buffer-diagnostics :which-key "显示诊断")
  ;; 与 Neovim LSP 配置中的常用入口保持兼容。
  "e" '(flymake-show-buffer-diagnostics :which-key "诊断")
  "r" '(:ignore t :which-key "重构")
  "rn" '(eglot-rename :which-key "重命名符号")
  "l" '(:ignore t :which-key "LaTeX")
  "ll" '(my/latex-compile :which-key "编译")
  "le" '(my/latex-rebuild :which-key "强制重编译")
  "lv" '(my/latex-view :which-key "查看PDF")
  "lc" '(my/latex-clean :which-key "清理中间文件")
  "lC" '(my/latex-clean-all :which-key "清理全部产物")
  "S" '(my/surround-region :which-key "包围选区")
  ;; 与 Neovim 中的 <Space>tt/te/tv/tc 保持兼容。
  "tt" '(my/latex-compile :which-key "LaTeX编译")
  "te" '(my/latex-rebuild :which-key "LaTeX强制编译")
  "tv" '(my/latex-view :which-key "LaTeX查看PDF")
  "tc" '(my/latex-clean :which-key "LaTeX清理")
  "i" '(:ignore t :which-key "插入")
  "id" '(my/insert-timestamp :which-key "插入时间")
  "-" '(dired-jump :which-key "当前目录"))

;; Match Neovim's <leader> behavior in Evil states.  Keep C-SPC free from
;; this custom map:
;; Fcitx5 commonly uses it as the system-wide input-method trigger.
(with-eval-after-load 'evil
  (define-key evil-normal-state-map (kbd "SPC") my/leader-map)
  (define-key evil-visual-state-map (kbd "SPC") my/leader-map))

;; ===============================
;; 6. UI 与 字体 (适配不同平台)
;; ===============================
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)
(global-hl-line-mode 1)
(column-number-mode 1)
(global-visual-line-mode 1)
(show-paren-mode 1)
(delete-selection-mode 1)
(electric-pair-mode 1)
(which-key-mode 1)

;; Scrolling, wrapping and searching tuned to the Neovim defaults.
(setq scroll-margin 6
      scroll-conservatively 101
      scroll-preserve-screen-position t
      case-fold-search t
      isearch-case-fold-search 'smart
      sentence-end-double-space nil)
(setq-default line-move-visual t
              truncate-lines nil)

(defun my/setup-fonts ()
  (let ((font-size (if *sys/win64* 14 16))
        (zh-font (cond (*sys/win64* "Microsoft YaHei")
                       (*sys/macos* "PingFang SC")
                       (t "Noto Sans CJK SC"))))
    (set-face-attribute 'default nil :family "Fira Code" :height (* font-size 10))
    (set-fontset-font t 'han (font-spec :family zh-font))))

(add-hook 'window-setup-hook #'my/setup-fonts)

(defvar my/dark-theme t)

(defun my/toggle-theme ()
  "Toggle between the dark and light Doom themes."
  (interactive)
  (setq my/dark-theme (not my/dark-theme))
  (mapc #'disable-theme custom-enabled-themes)
  (load-theme (if my/dark-theme 'doom-one 'doom-one-light) t))

(use-package doom-themes :config (load-theme 'doom-one t))

(defun my/insert-timestamp ()
  "Insert the current date and time, mirroring Neovim's C-d helper."
  (interactive)
  (insert (format-time-string "%Y-%m-%d %H:%M:%S")))

(defun my/toggle-spell-checking ()
  "Toggle Flyspell in the current buffer."
  (interactive)
  (require 'flyspell)
  (flyspell-mode (if (bound-and-true-p flyspell-mode) -1 1)))

(defun my/current-comment-prefix ()
  "Return the current mode's comment prefix without trailing whitespace."
  (string-trim-right (or (and (boundp 'comment-start) comment-start) "#")))

(defun my/insert-divider ()
  "Insert a comment divider using the current major mode's syntax."
  (interactive)
  (insert (my/current-comment-prefix) " " (make-string 70 ?-)))

(defun my/insert-file-header ()
  "Insert a small, mode-aware file header at point."
  (interactive)
  (let ((prefix (my/current-comment-prefix))
        (file (or (buffer-file-name) (buffer-name))))
    (insert (format "%s File: %s\n%s Created: %s\n%s Author: Teacher\n%s %s\n"
                    prefix file
                    prefix (format-time-string "%Y-%m-%d %H:%M:%S")
                    prefix
                    prefix (make-string 64 ?-)))))

(defun my/surround-region ()
  "Surround the active region with a familiar pair of delimiters."
  (interactive)
  (unless (use-region-p)
    (user-error "需要先选中文本"))
  (let* ((choice (read-string "包围符号 (() [] {} \"\" '' `` $$ ||): "))
         (pair (assoc choice
                      '(("(" . ")") ("[" . "]") ("{" . "}")
                        ("\"" . "\"") ("'" . "'") ("`" . "`")
                        ("$" . "$") ("|" . "|")))))
    (unless pair
      (user-error "不支持的包围符号: %s" choice))
    (let ((beg (region-beginning))
          (end (region-end)))
      (save-excursion
        (goto-char end)
        (insert (cdr pair))
        (goto-char beg)
        (insert (car pair))))))

(global-set-key (kbd "<f9>") #'my/toggle-theme)
(global-set-key (kbd "<f10>") #'my/toggle-spell-checking)
(global-set-key (kbd "<f11>") #'my/insert-divider)
(global-set-key (kbd "<f12>") #'my/insert-file-header)
(global-set-key (kbd "<C-f4>") #'delete-window)
(global-set-key (kbd "C-s") #'save-buffer)

(defun my/move-line-down ()
  "Move the current line down by one line, preserving its column."
  (interactive)
  (let ((line (line-number-at-pos))
        (column (current-column)))
    (save-restriction
      (widen)
      (beginning-of-line)
      (when (= (forward-line 1) 0)
        (transpose-lines 1)
        (goto-char (point-min))
        (forward-line line)
        (move-to-column column)))))

(defun my/move-line-up ()
  "Move the current line up by one line, preserving its column."
  (interactive)
  (let ((line (line-number-at-pos))
        (column (current-column)))
    (when (> line 1)
      (save-restriction
        (widen)
        (beginning-of-line)
        (transpose-lines 1)
        (goto-char (point-min))
        (forward-line (- line 2))
        (move-to-column column)))))

(with-eval-after-load 'evil
  ;; Neovim-style directional window movement in Normal state.
  (define-key evil-normal-state-map (kbd "C-h") #'windmove-left)
  (define-key evil-normal-state-map (kbd "C-j") #'windmove-down)
  (define-key evil-normal-state-map (kbd "C-k") #'windmove-up)
  (define-key evil-normal-state-map (kbd "C-l") #'windmove-right)
  (define-key evil-normal-state-map (kbd "C-s") #'save-buffer)
  (define-key evil-visual-state-map (kbd "C-s") #'save-buffer)
  (define-key evil-insert-state-map (kbd "C-s") #'save-buffer)
  (define-key evil-normal-state-map (kbd "M-j") #'my/move-line-down)
  (define-key evil-normal-state-map (kbd "M-k") #'my/move-line-up)
  (define-key evil-normal-state-map (kbd "-") #'dired-jump))

;; Fcitx5 输入法
;;
;; Fcitx5 is external to Emacs.  The old configuration used fcitx.el to
;; toggle it and to keep it out of Evil's Normal state.  Keep that behavior
;; locally so the configuration does not depend on downloading fcitx.el.
(setq default-input-method nil)

(defun my/fcitx5-send (option)
  "Send OPTION to Fcitx5 and return its exit status.
If the daemon is absent, start it once and retry."
  (when-let ((program (executable-find "fcitx5-remote")))
    ;; Emacs is an X11 client under XWayland.  Fcitx can be active on D-Bus
    ;; while its XIM frontend is still unattached to this DISPLAY.
    (when (getenv "DISPLAY")
      (ignore-errors
        (call-process program nil nil nil "--check" "-x")))
    (let ((status
           (condition-case nil
               (call-process program nil nil nil option)
             (error nil))))
      (when (and (integerp status)
                 (not (zerop status))
                 (executable-find "fcitx5"))
        (ignore-errors
          (call-process "fcitx5" nil nil nil "-d" "--replace"))
        (sleep-for 0.3)
        (when (getenv "DISPLAY")
          (ignore-errors
            (call-process program nil nil nil "--check" "-x")))
        (setq status
              (condition-case nil
                  (call-process program nil nil nil option)
                (error nil))))
      status)))

(defun my/fcitx5-check ()
  "Show whether Emacs can reach the current Fcitx5 D-Bus instance."
  (interactive)
  (let ((program (executable-find "fcitx5-remote")))
    (if (null program)
        (user-error "找不到 fcitx5-remote")
      (let ((xim-status
             (when (getenv "DISPLAY")
               (ignore-errors
                 (call-process program nil nil nil "--check" "-x"))))
            (window-system-name (if (boundp 'window-system)
                                    window-system
                                  'unknown)))
        (with-temp-buffer
          (let ((status (call-process program nil t nil "-n"))
                (output nil))
            (setq output (string-trim (buffer-string)))
            (message "Fcitx5 remote=%s dbus=%S xim=%S current=%s window=%S DISPLAY=%s | GTK=%s XMODIFIERS=%s LC_CTYPE=%s"
                     program status xim-status
                     (if (string-empty-p output) "<无响应>" output)
                     window-system-name (or (getenv "DISPLAY") "<无>")
                     (or (getenv "GTK_IM_MODULE") "<未设置>")
                     (or (getenv "XMODIFIERS") "<未设置>")
                     (or (getenv "LC_CTYPE") "<未设置>"))))))))

(defun my/fcitx5-toggle ()
  "Toggle Fcitx5's input method."
  (interactive)
  (let ((status (my/fcitx5-send "-t")))
    (cond
     ((null status)
      (user-error "找不到 fcitx5-remote，请先安装或启动 Fcitx5"))
     ((and (integerp status) (zerop status))
      (message "Fcitx5 输入法已切换"))
     (t
      (user-error "Fcitx5 无法连接（fcitx5-remote 退出码 %s），运行 M-x my/fcitx5-check 查看环境"
                  status)))))

(defun my/fcitx5-open ()
  "Activate Fcitx5 for Evil Insert state."
  (my/fcitx5-send "-o"))

(defun my/fcitx5-close ()
  "Deactivate Fcitx5 for Evil Normal state."
  (my/fcitx5-send "-c"))

(global-set-key (kbd "C-SPC") #'my/fcitx5-toggle)
(global-set-key (kbd "C-c i") #'my/fcitx5-toggle)
(with-eval-after-load 'evil
  (dolist (map (list evil-normal-state-map
                     evil-insert-state-map
                     evil-visual-state-map))
    (define-key map (kbd "C-SPC") #'my/fcitx5-toggle)
    (define-key map (kbd "C-c i") #'my/fcitx5-toggle))
  (add-hook 'evil-insert-state-entry-hook #'my/fcitx5-open)
  (add-hook 'evil-normal-state-entry-hook #'my/fcitx5-close))
(setq use-dialog-box nil)
(when (fboundp 'global-so-long-mode)
  (global-so-long-mode 1))

;; ===============================
;; 7. 现代补全与编程 (Tree-sitter & LSP)
;; ===============================
(use-package treesit-auto :config (global-treesit-auto-mode))
(use-package vertico :init (vertico-mode 1))
(use-package orderless :custom (completion-styles '(orderless basic)))
(use-package consult
  :bind (("C-x b" . consult-buffer)
         ("C-x C-r" . consult-recent-file)))
(use-package marginalia :init (marginalia-mode 1))

(use-package company
  :hook (after-init . global-company-mode)
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.12)
  (company-tooltip-align-annotations t)
  (company-show-quick-access t)
  (company-selection-wrap-around t)
  :config
  (setq company-backends
        '((company-capf company-files company-dabbrev-code company-keywords)))
  (define-key company-active-map (kbd "TAB") #'company-complete-selection)
  (define-key company-active-map (kbd "<tab>") #'company-complete-selection)
  (define-key company-active-map (kbd "S-TAB") #'company-select-previous))

(use-package eglot
  :ensure nil
  :demand t
  :custom
  (eglot-autoshutdown t)
  (eglot-events-buffer-size 0)
  (eglot-send-changes-idle-time 0.1)
  :config
  ;; Prefer the same basedpyright server as the Neovim configuration, with
  ;; the distro pyright server as a fallback.  This also avoids Eglot's
  ;; interactive choice between basedpyright, pyright and Ruff.
  (push (cons '(python-mode python-ts-mode)
              (eglot-alternatives
               '(("basedpyright-langserver" "--stdio")
                 ("pyright-langserver" "--stdio"))))
        eglot-server-programs))

(defun my/project-root-directory ()
  "Return the current project root, or `default-directory'."
  (or (ignore-errors
        (when-let ((project (project-current)))
          (project-root project)))
      default-directory))

(defun my/python-select-project-environment ()
  "Use a local .venv/venv interpreter when one exists."
  (let* ((root (file-name-as-directory (my/project-root-directory)))
         (venv (seq-find #'file-directory-p
                         (list (expand-file-name ".venv" root)
                               (expand-file-name "venv" root)))))
    (when venv
      (let* ((bin-name (if (eq system-type 'windows-nt) "Scripts" "bin"))
             (bin (expand-file-name bin-name venv))
             (interpreter (seq-find #'file-executable-p
                                    (list (expand-file-name "python3" bin)
                                          (expand-file-name "python" bin)))))
        (when interpreter
          (setq-local python-shell-interpreter interpreter)
          (setq-local exec-path (cons bin (delete bin (copy-sequence exec-path))))
          (make-local-variable 'process-environment)
          (setenv "PATH"
                  (concat bin path-separator (getenv "PATH"))))))))

(defun my/python-run-buffer ()
  "Run the current Python file in an Emacs compilation buffer."
  (interactive)
  (unless buffer-file-name
    (user-error "The current buffer is not visiting a Python file"))
  (save-buffer)
  (let ((default-directory (my/project-root-directory))
        (python (or (and (boundp 'python-shell-interpreter)
                         python-shell-interpreter)
                    (executable-find "python3")
                    "python3")))
    (compile (format "%s -u %s"
                    (shell-quote-argument python)
                    (shell-quote-argument (buffer-file-name))))))

(defun my/python-run-region ()
  "Send the active region, or the current definition, to the Python REPL."
  (interactive)
  (if (use-region-p)
      (python-shell-send-region (region-beginning) (region-end))
    (python-shell-send-defun)))

(defun my/python-check ()
  "Run Ruff diagnostics for the current Python file or project."
  (interactive)
  (unless (executable-find "ruff")
    (user-error "Ruff is not available in PATH"))
  (when buffer-file-name (save-buffer))
  (let ((default-directory (my/project-root-directory)))
    (compile (if buffer-file-name
                 (format "ruff check %s" (shell-quote-argument buffer-file-name))
               "ruff check ."))))

(defun my/python-format-buffer ()
  "Format the current Python buffer with Ruff, without writing a temp file."
  (interactive)
  (unless (executable-find "ruff")
    (user-error "Ruff is not available in PATH"))
  (let* ((filename (or buffer-file-name "stdin.py"))
         (output (generate-new-buffer " *ruff-format*"))
         (point-offset (- (point) (point-min)))
         (status (call-process-region (point-min) (point-max) "ruff" nil output nil
                                      "format" "--stdin-filename" filename "-")))
    (unwind-protect
        (if (zerop status)
            (let ((formatted (with-current-buffer output (buffer-string))))
              (atomic-change-group
                (erase-buffer)
                (insert formatted))
              (goto-char (min (+ (point-min) point-offset) (point-max)))
              (message "Ruff formatted buffer"))
          (display-buffer output)
          (user-error "Ruff could not format this buffer"))
      (kill-buffer output))))

(defun my/python-setup ()
  "Set up Python editing, completion, LSP, and project tools."
  (my/python-select-project-environment)
  (setq-local python-indent-offset 4)
  (company-mode 1)
  (eglot-ensure))

(defun my/eglot-optional-setup ()
  "Start Eglot for Neovim-style languages when their server is installed."
  (let ((server (cond
                 ((derived-mode-p 'c-mode 'c-ts-mode 'c++-mode 'c++-ts-mode)
                  "clangd")
                 ((derived-mode-p 'go-mode 'go-ts-mode) "gopls")
                 ((derived-mode-p 'lua-mode 'lua-ts-mode)
                  "lua-language-server")
                 ((derived-mode-p 'sh-mode 'bash-ts-mode)
                  "bash-language-server")
                 ((derived-mode-p 'dart-mode 'dart-ts-mode) "dart"))))
    (when (and server (executable-find server))
      (eglot-ensure))))

(use-package python
  :ensure nil
  :config
  (setq python-shell-interpreter
        (or (executable-find "python3") "python3")
        python-shell-interpreter-args "-i -u"
        python-imenu-format-item-label-list '("{name} ({type})"))
  (add-hook 'python-mode-hook #'my/python-setup)
  (add-hook 'python-ts-mode-hook #'my/python-setup)
  (define-key python-mode-map (kbd "<f5>") #'my/python-run-buffer)
  (define-key python-mode-map (kbd "<f6>") #'my/python-run-region)
  (define-key python-mode-map (kbd "C-c C-f") #'my/python-format-buffer)
  (define-key python-mode-map (kbd "C-c C-l") #'my/python-check)
  (with-eval-after-load 'python
    (when (boundp 'python-ts-mode-map)
      (define-key python-ts-mode-map (kbd "<f5>") #'my/python-run-buffer)
      (define-key python-ts-mode-map (kbd "<f6>") #'my/python-run-region)
      (define-key python-ts-mode-map (kbd "C-c C-f") #'my/python-format-buffer)
      (define-key python-ts-mode-map (kbd "C-c C-l") #'my/python-check))))

(dolist (hook '(c-mode-hook c-ts-mode-hook c++-mode-hook c++-ts-mode-hook
                go-mode-hook go-ts-mode-hook lua-mode-hook lua-ts-mode-hook
                sh-mode-hook bash-ts-mode-hook dart-mode-hook dart-ts-mode-hook))
  (add-hook hook #'my/eglot-optional-setup))

(setq c-default-style "linux"
      c-basic-offset 4)

(use-package go-mode
  :ensure nil
  :defer t
  :config
  (setq gofmt-command "gofmt")
  (add-hook 'go-mode-hook #'gofmt-before-save))

(defun my/latex--ensure-buffer ()
  "Ensure the current buffer is a loaded LaTeX buffer before acting."
  (unless (derived-mode-p 'LaTeX-mode 'latex-mode 'tex-mode)
    (user-error "当前缓冲区不是 LaTeX-mode"))
  (unless (fboundp 'TeX-command-master)
    (require 'latex)))

(defun my/latex-compile ()
  "Compile the current LaTeX master with AUCTeX's XeLaTeX latexmk command."
  (interactive)
  (my/latex--ensure-buffer)
  (save-buffer)
  (let ((TeX-command-force "LaTeXMk"))
    (TeX-command-master)))

(defun my/latex-rebuild ()
  "Force a clean dependency rebuild of the current LaTeX master."
  (interactive)
  (my/latex--ensure-buffer)
  (save-buffer)
  (let ((TeX-command-force "LaTeXMk Full"))
    (TeX-command-master)))

(defun my/latex-view ()
  "Open the current LaTeX PDF in the configured viewer."
  (interactive)
  (my/latex--ensure-buffer)
  (TeX-view))

(defun my/latex-clean ()
  "Remove LaTeX intermediate files but keep the PDF."
  (interactive)
  (my/latex--ensure-buffer)
  (TeX-clean nil))

(defun my/latex-clean-all ()
  "Remove LaTeX intermediate files and the generated PDF."
  (interactive)
  (my/latex--ensure-buffer)
  (TeX-clean t))

(defun my/latex-setup ()
  "Set up a LaTeX buffer for XeLaTeX writing and navigation."
  (setq-local TeX-engine 'xetex
              TeX-PDF-mode t
              TeX-command-default "LaTeXMk"
              ;; A quick compile should never stop for a master-file prompt.
              ;; Included files can override this with a file-local variable.
              TeX-master t)
  (LaTeX-math-mode 1)
  (outline-minor-mode 1)
  (visual-line-mode 1)
  (company-mode 1)
  (when (fboundp 'reftex-mode)
    (reftex-mode 1))
  (when (fboundp 'TeX-source-correlate-mode)
    (TeX-source-correlate-mode 1)))

(use-package tex
  :ensure auctex
  :mode (("\\.tex\\'" . LaTeX-mode)
         ("\\.ltx\\'" . LaTeX-mode))
  :config
  ;; Load AUCTeX's site setup as well as its implementation.  The site setup
  ;; redirects the built-in TeX modes and makes .tex files enter LaTeX-mode.
  (require 'tex-site)
  (require 'latex)
  (setq TeX-auto-save t
        TeX-parse-self t
        TeX-PDF-mode t
        TeX-process-asynchronous t
        TeX-source-correlate-method 'synctex
        TeX-source-correlate-start-server t)
  (setq-default TeX-engine 'xetex
                TeX-command-default "LaTeXMk")
  ;; AUCTeX 14 already ships a LaTeXMk command; with TeX-engine=xetex it
  ;; expands to latexmk -pdfxe.  This extra entry is the explicit full-build
  ;; equivalent of Neovim's <Space>te.
  (add-to-list 'TeX-command-list
               '("LaTeXMk Full"
                 "latexmk -gg -pdfxe -interaction=nonstopmode -halt-on-error %t"
                 TeX-run-TeX nil (LaTeX-mode docTeX-mode)
                 :help "Force a full XeLaTeX rebuild"))
  (let ((viewer (cond ((executable-find "zathura") "Zathura")
                      ((executable-find "evince") "Evince")
                      (t "xdg-open"))))
    (setf (alist-get 'output-pdf TeX-view-program-selection) viewer))
  (add-hook 'LaTeX-mode-hook #'my/latex-setup)
  (define-key LaTeX-mode-map (kbd "<f7>") #'my/latex-compile)
  (define-key LaTeX-mode-map (kbd "<f8>") #'my/latex-view)
  (define-key LaTeX-mode-map (kbd "C-c C-f") #'my/latex-rebuild))

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
(setq-default fill-column 80)
(setq whitespace-style '(face tabs trailing))
(global-auto-revert-mode 1)
(recentf-mode 1)
(save-place-mode 1)
(savehist-mode 1)
(setq recentf-max-saved-items 200
      recentf-exclude '("/tmp/" "/ssh:"))

;; Keep backups and auto-saves in the Emacs directory, while preserving the
;; timestamped, recoverable workflow used by the Neovim configuration.
(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups/" user-emacs-directory)))
      auto-save-file-name-transforms
      `((".*" ,(expand-file-name "auto-save-list/" user-emacs-directory) t))
      backup-by-copying t
      version-control t
      kept-new-versions 10
      kept-old-versions 5
      delete-old-versions t)

(add-hook 'before-save-hook #'delete-trailing-whitespace)
(add-hook 'prog-mode-hook #'hs-minor-mode)
(add-hook 'prog-mode-hook #'whitespace-mode)
(add-hook 'text-mode-hook #'whitespace-mode)

(with-eval-after-load 'evil
  ;; LSP navigation/diagnostics matching the Neovim buffer-local mappings.
  (define-key evil-normal-state-map (kbd "gd") #'xref-find-definitions)
  (define-key evil-normal-state-map (kbd "gr") #'xref-find-references)
  (define-key evil-normal-state-map (kbd "K") #'eldoc-doc-buffer)
  (define-key evil-normal-state-map (kbd "[d") #'flymake-goto-prev-error)
  (define-key evil-normal-state-map (kbd "]d") #'flymake-goto-next-error))

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
";; EMACS 30 当前快捷键速查
;;
;;  Leader: <SPC> (Evil Normal/Visual)
;;  中文输入法: C-SPC / C-c i (Fcitx5)
;;
;;  [1. 文件与项目]
;;  - <SPC> f f  : 打开/新建文件
;;  - <SPC> f r  : 最近打开的文件
;;  - <SPC> f s  : 保存 | <SPC> f d : 当前目录
;;  - <SPC> f b  : Buffer 列表 | <SPC> f g : 全文搜索
;;  - <SPC> p p  : Projectile 项目命令
;;  - <SPC> TAB  : 切换 Buffer
;;
;;  [2. 搜索与结构]
;;  - <SPC> s s  : 当前文件结构大纲
;;  - <SPC> s p  : 项目符号跳转
;;  - <SPC> s l  : 当前文件搜索 | <SPC> s g : 项目全文搜索
;;  - <SPC> /    : 清除搜索高亮
;;
;;  [3. Python / LSP]
;;  - <SPC> c a  : Code Action | <SPC> c d : 定义
;;  - <SPC> c i / c o : 实现/引用 | <SPC> c e : 诊断
;;  - <SPC> e    : 显示诊断 | <SPC> r n : 重命名
;;  - gd/gr/K    : 定义/引用/悬浮文档 | [d/ ]d : 上下条诊断
;;  - <F5>/<F6>  : 运行文件/区域或当前定义
;;  - C-c C-f / C-c C-l : Ruff 格式化/检查
;;  - gcc        : 注释/取消注释
;;
;;  [4. LaTeX]
;;  - <SPC> l l  : latexmk + XeLaTeX 编译
;;  - <SPC> l e  : 强制全量重编译
;;  - <SPC> l v  : 打开 PDF (优先 zathura)
;;  - <SPC> l c  : 清理中间文件 | <SPC> l C : 清理全部产物
;;  - <SPC> t t/e/v/c : 同上，兼容 Neovim 快捷键
;;  - <F7>/<F8>  : 编译/查看 PDF
;;
;;  [5. 窗口与工具]
;;  - <SPC> w h/j/k/l : 切换窗口
;;  - <SPC> w v/s : 左右/上下分屏
;;  - <SPC> w c/d : 关闭窗口/只保留当前窗口
;;  - C-s        : 保存 | M-j/M-k : 上下移动当前行
;;  - <SPC> g s / g b : Magit 状态/Blame
;;  - <SPC> i d  : 插入时间 | <SPC> S : 包围选区
;;  - C-x u      : Vundo | F9/F10: 主题/拼写
;;  - F11/F12    : 插入分隔线/文件头
")

(provide 'init)
