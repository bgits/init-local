(provide 'init-local)
(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)

(autoload 'dired-async-mode "dired-async.el" nil t)
(dired-async-mode 1)

;; you can select the key you prefer to
(require 'ace-jump-mode)
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)
(global-set-key (kbd "C-c f") 'recentf-open-files)

;; MULTIPLE CURSORS
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(setq auth-sources '("/Users/bg/.emacs.d/.authinfo"))

;; Associate an engine
(setq web-mode-engines-alist
      '(("php"    . "\\.phtml\\'")
        ("blade"  . "\\.blade\\.")
        ("mako"   . "\\.mak\\.")))

;; Prevent an odd TRAMP bug. Hangs at "Sending password" otherwise.
;; (add-hook 'after-init-hook
;;           '(lambda ()
;;              (if (member "." load-path)
;;                  (delete "." load-path))))

;; PROJECTILE MODE

(projectile-global-mode)
(setq projectile-enable-caching t)
(setq projectile-mode-line " Projectile")

;; IDO-VERTICAL-MODE

(require 'ido-vertical-mode)
(ido-mode 1)
(ido-vertical-mode 1)
(setq ido-vertical-show-count t)

(require 'js2-refactor)
(add-hook 'js2-mode-hook #'js2-refactor-mode)
(js2r-add-keybindings-with-prefix "C-c C-m")

(add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))
(defadvice web-mode-highlight-part (around tweak-jsx activate)
  (if (equal web-mode-content-type "jsx")
      (let ((web-mode-enable-part-face nil))
        ad-do-it)
    ad-do-it))

(flycheck-define-checker jsxhint-checker
  "A JSX syntax and style checker based on JSXHint."

  :command ("jsxhint" source)
  :error-patterns
  ((error line-start (1+ nonl) ": line " line ", col " column ", " (message) line-end))
  :modes (web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (equal web-mode-content-type "jsx")
              ;; enable flycheck
              (flycheck-select-checker 'jsxhint-checker)
              (flycheck-mode))))

;; (setq jsx-indent-level 2)

(autoload 'tern-mode "tern.el" nil t)

(add-hook 'js2-mode-hook (lambda () (tern-mode t)))
(eval-after-load 'tern
  '(progn
     (require 'tern-auto-complete)
     (tern-ac-setup)))

(require 'yasnippet)
(yas-global-mode 1)
(yas-reload-all)
(require 'react-snippets)

(defun delete-tern-process ()
  (interactive)
  (delete-process "Tern"))

(package-initialize)
(elpy-enable)

(add-hook 'python-mode-hook 'anaconda-mode)
(add-hook 'python-mode-hook 'eldoc-mode)

(add-to-list 'auto-mode-alist '("\\.mak\\'" . html-mode))
(mmm-add-mode-ext-class 'html-mode "\\.mak\\'" 'mako)

;;; Related to line numbering
(require 'hlinum)
(hlinum-activate)
(require 'linum-relative)

(require 'eshell-z)

(require 'sws-mode)
(require 'jade-mode)
(add-to-list 'auto-mode-alist '("\\.styl\\'" . sws-mode))
(add-to-list 'auto-mode-alist '("\\.jade\\'" . jade-mode))

(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)

(require 'helm)
(require 'helm-config)

(require 'ace-isearch)
(global-ace-isearch-mode +1)

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(when (executable-find "curl")
  (setq helm-net-prefer-curl t))

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t)

(helm-mode 1)

;;KEY-CHORDS
(load-file "~/.emacs.d/scripts/key-chord.el")
(require 'key-chord)
(key-chord-mode 1)
(key-chord-define-global "HO"     'helm-occur)
(key-chord-define-global "m,"     'helm-M-x)
(key-chord-define-global "hb"     'helm-buffers-list)
(key-chord-define-global "gs"     'helm-google-suggest)
(key-chord-define-global "BM"     'helm-bookmarks)
(key-chord-define-global "HB"     'helm-do-ag-buffers)
(key-chord-define-global "jk"     'ace-jump-mode)


(defun transparency-on ()
  (interactive)
  (set-frame-parameter (selected-frame) 'alpha 70))

(defun transparency-off ()
  (interactive)
  (set-frame-parameter (selected-frame) 'alpha 100))

;; Set transparency of emacs
(defun transparency (value)
  "Sets the transparency of the frame window. 0=transparent/100=opaque"
  (interactive "nTransparency Value 0 - 100 opaque:")
  (set-frame-parameter (selected-frame) 'alpha value))

(setq password-cache-expiry nil)

;;; (provide 'init-local)\n
;;; init-local.el ends here
