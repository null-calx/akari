(in-package :explorer)

(defun ls (pathname)
  (let ((file (probe-file pathname)))
    (when file
      (if (pathname-name file)
	  (directory file)
	  (directory (make-pathname :name :wild
				    :type :wild
				    :defaults file))))))

(defun file-properties (file)
  (let* ((file (probe-file file))
	 (filep (pathname-name file))
	 (fullname (if filep
		       (file-namestring file)
		       (car (last (pathname-directory file)))))
	 (type (when filep
		 (pathname-type file))))
    (list :filep filep
	  :fullname fullname
	  :type type)))

(defun explore (pathname)
  (let ((file (probe-file pathname)))
    (unless file
      (return-from explore nil))
    (when (pathname-name file)
      (return-from explore file))
    (mapcar #'(lambda (pathname)
		(file-properties pathname))
	    (ls file))))
