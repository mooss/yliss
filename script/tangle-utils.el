;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Allow evaluation of bash code blocks ;;
(setq yls/evaluate-without-asking '("sh"))

(defun yls/org-confirm-babel-evaluate (lang body)
  (not (seq-contains yls/evaluate-without-asking
                     lang
                     'string=)))

(setq org-confirm-babel-evaluate 'yls/org-confirm-babel-evaluate)

;;;;;;;;;;;;;;;;;;;;;
;; Tangle function ;;
(defun yls/tangle()
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((shell . t)))
  (org-babel-tangle))
