(defun ylissp/construct-guard-name (filename guard-prefix)
  (let ((prefixname (or guard-prefix "DEFAULT_PREFIX")))
    (concat prefixname
            "_"
            (upcase
             (replace-regexp-in-string
              "include/"
              ""
              (replace-regexp-in-string
              "\\."
              "_"
              filename))) )))

(defun is-C-header (filename)
  (string-match ".*\\.h\\(pp\\)?$" filename))

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; new C expand function ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ylissp/org-babel-C-expand-C (body params)
  "Expand a block of C or C++ code with org-babel according to
its header arguments.

ylissp version can also deal with header files (.h) and
automatically generates an include guard."
  (message "the arguments are: %s" params)
  (let ((vars (org-babel--get-vars params))
	(colnames (cdr (assq :colname-names params)))
	(main-p (not (string= (cdr (assq :main params)) "no")))

        ;;;;;;;;;;;;;;;;;;;
        ;; include-guard ;;
        ;;;;;;;;;;;;;;;;;;;
        (tangle-file (org-babel-read
                      (cdr (assq :tangle params))
                      nil))
        (guard-prefix (org-babel-read
                       (cdr (assq :guard-prefix params))
                       nil))

	(includes (org-babel-read
		   (cdr (assq :includes params))
		   nil))
	(defines (org-babel-read
		  (cdr (assq :defines params))
		  nil))
	(namespaces (org-babel-read
		     (cdr (assq :namespaces params))
		     nil)))
    (setq guard-name (ylissp/construct-guard-name tangle-file guard-prefix))
    (when (stringp includes)
      (setq includes (split-string includes)))
    (when (stringp namespaces)
      (setq namespaces (split-string namespaces)))
    (when (stringp defines)
      (let ((y nil)
	    (result (list t)))
	(dolist (x (split-string defines))
	  (if (null y)
	      (setq y x)
	    (nconc result (list (concat y " " x)))
	    (setq y nil)))
	(setq defines (cdr result))))
    (mapconcat 'identity
	       (seq-filter
                (lambda (x) (not (string= "" x)))
                ;(apply-partially #'string= "")
                (list
                 ;; guard
                 (when (is-C-header tangle-file)
                   (concat (format "#ifndef %s\n" guard-name)
                           (format "#define %s\n" guard-name)) )
		 ;; includes
		 (mapconcat
		  (lambda (inc)
                    (if (string-prefix-p "<" inc)
                        (format "#include %s" inc)
                      (format "#include \"%s\"" inc)))
		  includes "\n")
		 ;; defines
		 (mapconcat
		  (lambda (inc) (format "#define %s" inc))
		  (if (listp defines) defines (list defines)) "\n")
		 ;; namespaces
		 (mapconcat
		  (lambda (inc) (format "using namespace %s;" inc))
		  namespaces "\n")
		 ;; variables
		 (mapconcat 'org-babel-C-var-to-C vars "\n")
		 ;; table sizes
		 (mapconcat 'org-babel-C-table-sizes-to-C vars "\n")
		 ;; tables headers utility
		 (when colnames
		   (org-babel-C-utility-header-to-C))
		 ;; tables headers
		 (mapconcat 'org-babel-C-header-to-C colnames "\n")
		 ;; body
                 (cond ((is-C-header tangle-file)
                        (concat body (format "\n#endif//%s\n" guard-name)))
                       (main-p (org-babel-C-ensure-main-wrap body))
                       (t body))
                 "\n")) "\n")))


;;(fset 'org-babel-C-expand-C 'ylissp/org-babel-C-expand-C)
(advice-add 'org-babel-C-expand-C :override
            #'ylissp/org-babel-C-expand-C)

;; preserve indentation for makefiles
(setq org-src-preserve-indentation t)
