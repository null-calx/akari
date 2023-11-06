(in-package :akari)

(defun time-string ()
  (multiple-value-bind (sec min hr
			day mon yr
			week
			day-time-saving-flag
			timezone-offset)
      (decode-universal-time (get-universal-time))
    (declare (ignore timezone-offset day-time-saving-flag))
    (format nil "~A ~4,'0D-~2,'0D-~2,'0D ~2,'0D:~2,'0D:~2,'0D"
	    (nth week '(mon tue wed thr fri sat sun))
	    yr mon day
	    hr min sec)))

(defun make-li (file-details)
  (let ((filep (getf file-details :filep))
	(fullname (getf file-details :fullname)))
    `(li (a ,fullname
	    :href ,(format nil "~A~@[/~]" fullname (not filep))))))

(defun handler (stream)
  (destructuring-bind (&key method url version
			 headers body)
      (receive stream)
    (declare (ignore headers body))
    (format t "Connection received: ~A ~A ~A~%" method url version)
    (let ((file-details (explore (format nil "~A~A"
					 (uiop:getcwd)
					 url))))
      (cond ((null file-details)
	     (send stream
		   :status 404
		   :message "Not Found"
		   :body "Not Found"))
	    ((pathnamep file-details)
	     (send stream
		   :body (with-open-file (stream file-details
						 :direction :input)
			   (with-output-to-string (file-string)
			     (loop for char = (read-char stream nil)
				   while char
				   do (write-char char file-string))))))
	    (t (send stream
		     :body (generate-markup
			    `((:doctype html)
			      (html
			       ((head (title ,(format nil "AKARI | ~A"
						      url)))
				(body
				 ((h1 "AKARI directory server")
				  (h2 ,(format nil "Index of ~A"
					       url))
				  (hr :empty)
				  (div
				   (ul
				    ,(loop for file-detail in file-details
					   collect (make-li file-detail)))
				   :id root)
				  (div
				   ((span "Created on: ")
				    (span ,(time-string))))))))))))))))

(defun main ()
  (init #'handler)
  (loop))
