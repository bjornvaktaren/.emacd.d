
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(setq inhibit-startup-message t) ;; Do not display startup message
(tool-bar-mode -1) ;; Hide toolbar

;; Load paths
(add-to-list 'load-path "~/.emacs.d/lisp/") ;; Load lisp path

;; Store backups in ~/.emacs.d/backups
(setq
 backup-by-copying t
 backup-directory-alist '(("." . "~/.emacs.d/backups"))
 delete-old-versions t
 kept-new-versions 60
 kept-old-versions 20
 version-control t)

;; c-mode preferences
(setq-default
 c-default-style "k&r" ;; Style
 c-basic-offset 3 ;; Indentation
 c-toggle-hungry-state) ;; Delete all whitespaces
;; Set tabs to 3 spaces wide in c-mode
(defun mikaels-c++-mode-hook ()
  (setq tab-width 3)
  (c-toggle-hungry-state 1)
  )
;; (add-hook 'c-mode-hook 'c-mode-tab-width-hook)
(add-hook 'c++-mode-hook 'mikaels-c++-mode-hook)
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; ansi colors in shell mode
(require 'ansi-color)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; define the command cppcheck
(defvar cppcheck-source-path nil
  "Path to run cppcheck on.")
(defun cppcheck-buffer-name (_mode)
  "Return \"*cppcheck*\" as the name of the buffer to use."
  "*cppcheck*")
(defun cppcheck ()
  (interactive)
  (let ((compilation-buffer-name-function  'cppcheck-buffer-name))
    (setq cppcheck-source-path
	  (read-file-name "File or path: "))
    (compile (concat "cppcheck --enable=all --template='{file}:{line}:{severity}:{message}' --quiet " cppcheck-source-path))
  ))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (flycheck php-mode rust-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(add-hook 'rust-mode-hook
          (lambda () (setq indent-tabs-mode nil)))

(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
  ;; and `package-pinned-packages`. Most users will not need or want to do this.
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  )
(package-initialize)

;; Fly-check mode
(add-hook 'c++-mode-hook 'flycheck-mode)
(add-hook 'python-mode-hook 'flycheck-mode)
