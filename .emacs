(require 'package)
(push '("marmalade" . "http://marmalade-repo.org/packages/")
      package-archives )
(push '("melpa" . "http://melpa.milkbox.net/packages/")
      package-archives )

(package-initialize)
(require 'evil)
(evil-mode 1)        ;; enable evil-mode



(require 'evil-numbers)
(define-key evil-normal-state-map (kbd "C-c +") 'evil-numbers/inc-at-pt)
(define-key evil-normal-state-map (kbd "C-c -") 'evil-numbers/inc-at-pt)

(global-linum-mode 1)
(defun linum-format-func (line)
   (let ((w (length (number-to-string (count-lines (point-min) (point-max))))))
     (propertize (format (format "%%%dd " w) line) 'face 'linum)))
(setq linum-format 'linum-format-func)


;; imap jj <ESC>
(define-key evil-insert-state-map "j" #'cofi/maybe-exit)
(evil-define-command cofi/maybe-exit ()
  :repeat change
  (interactive)
  (let ((modified (buffer-modified-p)))
    (insert "j")
    (let ((evt (read-event (format "Insert %c to exit insert state" ?j)
			   nil 0.5)))
      (cond
       ((null evt) (message ""))
       ((and (integerp evt) (char-equal evt ?j))
	(delete-char -1)
	(set-buffer-modified-p modified)
	(push 'escape unread-command-events))
       (t (setq unread-command-events (append unread-command-events
					                                (list evt))))))))
;; Allow tabs
(global-evil-tabs-mode t)

(add-to-list 'load-path "~/.emacs.d/vendor/emacs-powerline")
(require 'powerline)
(require 'cl)
;; colors..
;;(setq powerline-color1 "#222")     ;; dark grey;
;;(setq powerline-color2 "#444")     ;; slightly lighter grey
;; shape...
(setq powerline-arrow-shape 'arrow) ;;mirrored arrows,

;; show parenthesis match
(show-paren-mode 1)
(setq show-paren-style 'expression)

;; frame font
;; Setting English font
(if (member "Monaco" (font-family-list))
    (set-face-attribute
     'default nil :font "Monaco 12"))

(require 'moe-theme)
(moe-dark)
