;; =======================================================================================
;; Lückentext
;; Written by Brian Sanders 2016
;; =======================================================================================

(require 'widget)

(setq my-name "Brian")

(defun brian/initialize-sample(buff_file_n)
  ;;(insert "In einem groß[en] Haus lebten eine grau[e] Katze und eine braun[e] Maus.")
  (insert-file-contents buff_file_n)
  )

(defun brian/check-answer-correct (widget &rest ignore)
  "Check the value of the widget for right or wrong."
  (cond
   ((string= (widget-value widget) "?")
    ;; Asking for hint
    (message "%s" (widget-get widget :correct))
    (widget-value-set widget ""))
   ;; Use string-match to obey case-fold-search 
   ((string-match 
     (concat "^"
             (regexp-quote (widget-get widget :correct))
             "$")
     (widget-value widget))
    (message "Correct!")
    (goto-char (widget-field-start widget))
    (goto-char (- (line-end-position) 1))    
    (insert "✓")
    (widget-forward 1)
    )
   (t (message "Wrong!"))))

(defun brian/tabulate-quiz()
  (widget-move 1)
  (while (widget-forward(1))
    message("hello")))

(defun brian/make-luekentext (&optional context)
  "Create fill-in quiz"
  (interactive)
  ;;  (with-current-buffer (get-buffer-create "*test3*")
  (setq my_buffer_name buffer-file-name)
  (switch-to-buffer-other-window "*test1*")
  (kill-all-local-variables)
  (let ((inhibit-read-only t))
    (erase-buffer))
  (remove-overlays)
  (brian/initialize-sample my_buffer_name)
  (goto-char (point-min))
  (while (re-search-forward "[\[]" nil t)
    (progn 
      (let (beg end answer)
        (setq beg (point))
        (re-search-forward "[\]]" nil 2)
        (setq end (- (point) 1))
        (setq answer (buffer-substring beg end))
        (goto-char beg)
        (delete-char (length answer))
        
        (widget-create 'editable-field
                       :size (+ (length answer) 1)
                       :format "%v"
                       :action 'brian/check-answer-correct
                       :correct answer
                       ;;:notify 'brian/check-widget-value
                       )
        )))
  (use-local-map widget-keymap)
  (widget-setup)
  (goto-char (point-min))
  (widget-forward 1)
  ;; (widget-insert "\n\n")
  ;; (widget-create 'push-button
  ;;                :notify (lambda (&rest ignore)
  ;;                          (message "I'm not sure what to do here.")
  ;;                          (brian/tabulate-quiz))
  ;;                "Submit")
  )


