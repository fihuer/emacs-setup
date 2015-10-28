(global-set-key (kbd "C-c m") 'compile) ; Ctrl+c m
(global-set-key (kbd "C-c !") 'flyspell-goto-next-error)

(load "~/.emacs.d/window.el")

(load-file "~/.emacs.d/pyemacs/epy-init.el")

;; (load-file "~/.emacs.d/visws.el")

(add-to-list 'load-path "/usr/share/doc/git-1.8.3.1/contrib/emacs/")
(require 'git)
(require 'git-blame)

(add-to-list 'load-path "~/.emacs.d/dash/")
(load-file "~/.emacs.d/let-alist.el")
(add-to-list 'load-path "~/.emacs.d/flycheck/")
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(git-blame-use-colors nil)
 '(visible-whitespace-mappings (quote ((10 [36 10]) (9 [92 9]) (32 [46])))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(git-blame-prefix-face ((t (:background "green" :foreground "black")))))

;; Use ido to list tags, but then select via etags-select (best of both worlds!)
(defun ido-find-tag ()
  "Find a tag using ido"
  (interactive)
  (tags-completion-table)
  (let (tag-names)
    (mapatoms (lambda (x)
                (push (prin1-to-string x t) tag-names))
              tags-completion-table)
    (find-tag (ido-completing-read "Tag: " tag-names))))
(global-set-key (kbd "M-,") 'ido-find-tag)
(global-set-key (kbd "M-n") (kbd "C-u M-."))


(defun find-file-upwards (file-to-find)
  "Recursively searches each parent directory starting from the default-directory.
looking for a file with name file-to-find.  Returns the path to it
or nil if not found."
  (labels
      ((find-file-r (path)
                    (let* ((parent (file-name-directory path))
                           (possible-file (concat parent file-to-find)))
                      (cond
                       ((file-exists-p possible-file) possible-file) ; Found
                       ;; The parent of ~ is nil and the parent of / is itself.
                       ;; Thus the terminating condition for not finding the file
                       ;; accounts for both.
                       ((or (null parent) (equal parent (directory-file-name parent))) nil) ; Not found
                       (t (find-file-r (directory-file-name parent))))))) ; Continue
    (find-file-r default-directory)))
(let ((my-tags-file (find-file-upwards "TAGS")))
  (when my-tags-file
    (message "Loading tags file: %s" my-tags-file)
    (visit-tags-table my-tags-file)))
