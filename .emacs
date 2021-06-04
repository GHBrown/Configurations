(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(require 'evil)
(evil-mode 1)

(ido-mode 1)

(add-hook 'prog-mode-hook #'hs-minor-mode) ;enable hideshow mode globally for code folding
;maybe remap za etc. to more intuitive keys?

(ac-config-default)
(global-auto-complete-mode t)
(define-key ac-completing-map [return] nil)
(define-key ac-completing-map "\r" nil)

(load-theme 'wombat)
(global-linum-mode t)
(set-face-foreground 'linum "white")
(setq linum-format "%3d \u2502")

(global-set-key (kbd "C-c t") 'transpose-frame)
(global-set-key (kbd "C-c s") 'rotate-frame)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (chapel-mode evil-vimish-fold transpose-frame auto-complete auto-complete-auctex auto-complete-c-headers auto-complete-chunk auto-complete-clang auto-complete-clang-async auto-complete-distel auto-complete-exuberant-ctags auto-complete-nxml auto-complete-pcmp auto-complete-rst evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
