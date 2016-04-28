
;; Set by emacs.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("8f0334c430540bf45dbcbc06184a2e8cb01145f0ae1027ce6b1c40876144c0c9" "e87a2bd5abc8448f8676365692e908b709b93f2d3869c42a4371223aab7d9cf8" default)))
 '(flymake-allowed-file-name-masks
   (quote
    (("\\.\\(?:c\\(?:pp\\|xx\\|\\+\\+\\)?\\|CC\\)\\'" flymake-simple-make-init nil nil)
     ("\\.xml\\'" flymake-xml-init nil nil)
     ("\\.html?\\'" flymake-xml-init nil nil)
     ("\\.cs\\'" flymake-simple-make-init nil nil)
     ("\\.p[ml]\\'" flymake-perl-init nil nil)
     ("\\.php[345]?\\'" flymake-php-init nil nil)
     ("\\.h\\'" flymake-master-make-header-init flymake-master-cleanup nil)
     ("\\.java\\'" flymake-simple-make-java-init flymake-simple-java-cleanup nil)
     ("[0-9]+\\.tex\\'" flymake-master-tex-init flymake-master-cleanup nil)
     ("\\.tex\\'" flymake-simple-tex-init nil nil)
     ("\\.idl\\'" flymake-simple-make-init nil nil)
     ("\\.ino\\'" flymake-simple-make-init nil nil))))
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Common Lisp.
(require 'cl-lib)

;; Package manager for ELPA (and add MELPA).
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; Function to install all required packages on a new machine.
(defun jim-install-packages ()
  (interactive)
  (defvar jim-packages
    '(go-mode flymake-go dot-mode whole-line-or-region auto-complete go-autocomplete arduino-mode helm projectile helm-projectile))
  (package-refresh-contents)
  (dolist (p jim-packages)
    (when (not (package-installed-p p))
      (package-install p))))

;; ---------------------- Language modes ---------------------------------------

;; Go
;; Requires: go get github.com/rogpeppe/godef
;;           go get github.com/nsf/gocode
(defun jim-go-mode ()
  ;; gofmt on save.
  (add-hook 'before-save-hook 'gofmt-before-save)
  ;; Add flymake support for go.
  (require 'flymake-go)
  (flymake-mode)
  ;; Auto-complete support
  (auto-complete-mode 1)
  ;; Compile support
  (if (not (string-match "go build" compile-command))
      (set (make-local-variable 'compile-command)
           "go build -v && go test -v && go vet"))
  ;; 8-wide tabs are too wide.
  (setq tab-width 2))
(add-hook 'go-mode-hook 'jim-go-mode)
(with-eval-after-load 'go-mode
  (require 'go-autocomplete))


;; Shell
(defun jim-shell-mode ()
  ;; Fix indentation.
  (setq sh-basic-offset 2
	sh-indentation 2))
(add-hook 'sh-mode-hook 'jim-shell-mode)

;; ---------------------- Features ---------------------------------------------

;; Helm & Projectile
(require 'helm-config)
;;(require 'projectile)
;;(projectile-global-mode)
;;(setq projectile-completion-system 'helm)
;;(helm-projectile-on)
(helm-mode 1)
(define-key global-map [remap find-file] 'helm-find-files)
(define-key global-map [remap occur] 'helm-occur)
(define-key global-map [remap list-buffers] 'helm-buffers-list)
(define-key global-map [remap dabbrev-expand] 'helm-dabbrev)
(global-set-key (kbd "M-x") 'helm-M-x)
;; Emulate vi's . to repeat last edit or command.
;; Enable by default for all files, but also enable-on-demand.
(require 'dot-mode)
(add-hook 'find-file-hooks 'dot-mode-on)
(global-set-key [(control ?.)] (lambda () (interactive) (dot-mode 1)
				 (message "Dot mode activated.")))

;; Make any command (e.g. M-w that operates on a region operate on the line
;; if no region is selected. Also make yanking aware of whole-line kills.
(require 'whole-line-or-region)

;; Autoindent open-*-lines
(defvar newline-and-indent t
  "Modify the behavior of the open-*-line functions to cause them to autoindent.")

;; Disable tool bars and menu bars.
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;; Put autosave files (ie #foo#) in one place, *not* scattered all over the
;; file system! (The make-autosave-file-name function is invoked to determine
;; the filename of an autosave file.)
(defvar autosave-dir (concat "~/tmp/emacs_autosaves/" (user-login-name) "/"))
(make-directory autosave-dir t)

(defun auto-save-file-name-p (filename)
  (string-match "^#.*#$" (file-name-nondirectory filename)))

(defun make-auto-save-file-name ()
  (concat autosave-dir
	   (if buffer-file-name
		 (concat "#" (file-name-nondirectory buffer-file-name) "#")
	     (expand-file-name
	      (concat "#%" (buffer-name) "#")))))

;; Put backup files (ie foo~) in one place too. (The backup-directory-alist
;; list contains regexp=>directory mappings; filenames matching a regexp are
;; backed up in the corresponding directory. Emacs will mkdir it if necessary.)
(defvar backup-dir (concat "~/tmp/emacs_backups/" (user-login-name) "/"))
(setq backup-directory-alist (list (cons "." backup-dir)))

;; Numbered backups
(setq version-control t)
(setq kept-old-versions 3)
(setq kept-new-versions 10)
(setq trim-versions-without-asking t)

;; Auto-save more often
(setq auto-save-interval 150)
(setq auto-save-timeout 20)

;; Show line and column numbers.
(line-number-mode 1)
(column-number-mode 1)

;; Scroll the compilation output to the bottom.
(setq compilation-scroll-output t)

;; clang-format
(load "/usr/share/clang/clang-format.el")
(global-set-key [C-M-tab] 'clang-format-region)

;; ---------------------- Key bindings -----------------------------------------

;; Enable useful things disabled by default.
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;; Don't allow C-z (too easy to hit by accident).
(global-unset-key (kbd "C-z"))

;; M-x is too hard to press.
(global-set-key "\C-xx" 'execute-extended-command)

;; C-w kills word (like bash) but will kill-region if there is one.
(defun kill-region-or-word ()
  (interactive)
  (call-interactively
   (if (use-region-p) 'kill-region 'backward-kill-word)))
(global-set-key "\C-w" 'kill-region-or-word)

;; Repeat the last compile command (without confirmation).
(global-set-key "\C-cc" 'recompile)

;; Make C-o behave like vi's o command.
(defun open-next-line (arg)
  "Move to the next line and then opens a line.
    See also `newline-and-indent'."
  (interactive "p")
  (end-of-line)
  (open-line arg)
  (next-line 1)
  (when newline-and-indent
    (indent-according-to-mode)))
(global-set-key (kbd "C-o") 'open-next-line)

;; Make M-o behave like vi's O command.
(defun open-previous-line (arg)
  "Open a new line before the current one. 
     See also `newline-and-indent'."
  (interactive "p")
  (beginning-of-line)
  (open-line arg)
  (when newline-and-indent
    (indent-according-to-mode)))
(global-set-key (kbd "M-o") 'open-previous-line)

;; Make *-of-line smarter w.r.t. indentation.
(defvar xemacsp (and (boundp 'xemacsp) xemacsp))
(defun smarter-do-it (eol-test skip-fun eol-fun)
  "Helper for `smarter-beginning-of-line' and `smarter-end-of-line'."
  ;; xemacs deactivates the region if you call (end-of-line) non-interactively
  ;; so manually fix the region up.
  (let* ((old-mark (if xemacsp (mark)
		     (if mark-active (mark) nil)))
	 (fixup-region
	  (and xemacsp old-mark)))
    (if (funcall eol-test)
	(funcall skip-fun " \t")
      (funcall eol-fun))
    (when fixup-region
      (push-mark old-mark t t))))
(defun smarter-beginning-of-line ()
  "Toggles point between bol and first non-whitespace char in line."
  (interactive)
  (smarter-do-it #'smarter-bolp
		 #'skip-chars-forward
		 #'beginning-of-line))
(defun smarter-end-of-line ()
  "Toggles point between eol and last non-whitespace char in line."
  (interactive)
  (smarter-do-it #'smarter-eolp
		 #'skip-chars-backward
		 #'end-of-line-sans-padding))
(defun smarter-bolp ()
  "In table cells (`table.el'), make `bolp' work properly."
  (or (bolp)
      (and (fboundp 'table-cell-bolp)
	   (table-cell-bolp))))
(defun smarter-eolp ()
  "In table cells (`table.el'), make `eolp' work properly."
  (or (eolp)
      (and (fboundp 'table-cell-eolp)
	   (table-cell-eolp))))
(defun end-of-line-sans-padding (&optional N)
  "Synonym for `end-of-line'.
   This is a placeholder function if `table-extras' isn't loaded."
  (interactive)
  (end-of-line N))
(global-set-key "\C-a" 'smarter-beginning-of-line)
(global-set-key "\C-e" 'smarter-end-of-line)
(global-set-key [end]  'smarter-end-of-line)
(global-set-key [home] 'smarter-beginning-of-line)

;; Enable flymake-mode
(global-set-key "\C-cf" 'flymake-mode)
