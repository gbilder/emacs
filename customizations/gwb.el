
;; Personal settings

(setq user-full-name "Geoffrey Bilder")

;; tramp mode speedup
(setq tramp-default-method "ssh")

;; Be lazy answering questions
(fset 'yes-or-no-p 'y-or-n-p)

;; Define package repositories
(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
              '("tromey" . "http://tromey.com/elpa/") t)
(add-to-list 'package-archives
              '("melpa" . "http://melpa.milkbox.net/packages/") t)

;; Setup backups
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq delete-old-versions -1)
(setq version-control t)
(setq vc-make-backup-files t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

;; Some initial modern sanity
;; TODO: fix conflicts with CIDER/Clojure mode
;; (cua-mode)

;; Start in a useful mod
(setq default-major-mode 'text-mode)

;; Load my abbreviations
(load "gwb_abbrev")

;; Handle buffers, windows sanely
(global-set-key "\C-s" 'save-buffer)
;; (global-set-key "\C-w" 'kill-buffer)

;; better smex
(global-set-key (kbd "ESC .") 'smex)

;; Customise some editing
(global-set-key "\C-d" 'kill-whole-line)

;; Don't be a prat
(autoload 'artbollocks-mode "artbollocks-mode")
(add-hook 'text-mode-hook 'artbollocks-mode)

;; Make sense of parens
(show-paren-mode t)

;; Text shuffling
;; Move lines/regions
(defun move-text-internal (arg)
  (cond
   ((and mark-active transient-mark-mode)
    (if (> (point) (mark))
        (exchange-point-and-mark))
    (let ((column (current-column))
          (text (delete-and-extract-region (point) (mark))))
      (forward-line arg)
      (move-to-column column t)
      (set-mark (point))
      (insert text)
      (exchange-point-and-mark)
      (setq deactivate-mark nil)))
   (t
    (let ((column (current-column)))
      (beginning-of-line)
      (when (or (> arg 0) (not (bobp)))
        (forward-line)
        (when (or (< arg 0) (not (eobp)))
          (transpose-lines arg)
          (when (and (eval-when-compile
                       '(and (>= emacs-major-version 24)
                             (>= emacs-minor-version 3)))
                     (< arg 0))
            (forward-line -1)))
        (forward-line -1))
      (move-to-column column t)))))

(defun gwb-move-text-down (arg)
  "Move region (transient-mark-mode active) or current line
  arg lines down."
  (interactive "*p")
  (move-text-internal arg))

(defun gwb-move-text-up (arg)
  "Move region (transient-mark-mode active) or current line
  arg lines up."
  (interactive "*p")
  (move-text-internal (- arg)))

;; Bind keys to above text shuffling
(global-set-key (kbd "ESC <up>") 'gwb-move-text-up)
(global-set-key (kbd "ESC <down>") 'gwb-move-text-down)


;; Sample function template so I can test stuff
;; ‘C-u’ is bound to command ‘universal-argument’
;; Note default value for 'C-u' is 4
;; ‘M-x foo’ calls ‘foo’ with ‘arg’ bound to nil
;; ‘C-u M-x foo’ calls ‘foo’ with ‘arg’ bound to (4)
;; ‘C-u 3 M-x foo’ calls ‘foo’ with ‘arg’ bound to 3
;; https://www.emacswiki.org/emacs/PrefixArgument
(defun gwb-foo (arg)
      "Print the current raw prefix argument value."
      (interactive "P")
      (message "gwb-foo: raw prefix arg is %S" arg))

;; Test a key assignment to above
(global-set-key (kbd "<f5>") 'gwb-foo)
