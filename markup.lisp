(in-package :markup)

(defun markup-sanitize (string)
  ;; TODO
  (string string))

(defun attribute-sanitize (string)
  ;; TODO
  (string string))

(defun generate-attribute-list (attr-plist)
  (loop for (name value) on attr-plist by #'cddr
	collect (format nil "~A=\"~A\""
			name
			(attribute-sanitize value))))

(defun generate-markup (markup)
  (cond ((stringp markup) (markup-sanitize markup))
	((not (listp markup)) (error "Invalid markup, ~S" markup))
	((keywordp (car markup))
	 (cond ((eq (car markup) :doctype)
		(format nil "<!~A ~A>"
			(car markup)
			(cadr markup)))))
	((symbolp (car markup))
	 (destructuring-bind (tag content &rest attr-plist) markup
	   (if (eq content :empty)
	       (format nil "<~A~@[ ~{~A~^ ~}~]/>"
		       tag
		       (generate-attribute-list attr-plist))
	       (format nil "<~A~@[ ~{~A~^ ~}~]>~A</~A>"
		       tag
		       (generate-attribute-list attr-plist)
		       (generate-markup content)
		       tag))))
	(t (format nil "~{~A~}"
		   (loop for item in markup
			 collect (generate-markup item))))))
