(in-package :http)

(defun read-til (stream char)
  (with-output-to-string (s)
    (loop for c = (read-char stream nil)
	  while c
	  if (char= char c)
	    do (return)
	  else
	    do (write-char c s))))

(defun read-line-with-return (stream)
  (let ((string (read-line stream nil)))
    (if (and (not (zerop (length string)))
	     (char= (char string (1- (length string))) (code-char 13)))
	(subseq string 0 (1- (length string)))
	string)))

#+nil
(defun read-line-with-return (stream)
  (let ((string (read-til stream (code-char 13))))
    (read-char stream "")
    string))

(defun parse-header-line (header-line)
  (let ((position (position #\: header-line)))
    (when position
      (cons (intern (string-upcase (subseq header-line 0 position)) :keyword)
	    (subseq header-line (1+ position))))))

(defun receive (stream)
  (let ((method (read-til stream #\Space))
	(url (read-til stream #\Space))
	(version (read-line-with-return stream))
	(headers (loop for header-line = (read-line-with-return stream)
		       while (and header-line
				  (not (zerop (length header-line))))
		       for header = (parse-header-line header-line)
		       while header
			 collect header))
	#+nil(body (with-output-to-string (s)
		(loop for char = (read-char stream nil)
		      while char
		      do (print `(read ,char))
		      do (write-char char s)))))
    (format t "~A~%" (list method url version headers))
    (list :method method
	  :url url
	  :version version
	  :headers headers
	  ;;:body body)))
	  )))

(defun send (stream &key
		      (version "HTTP/1.1")
		      (status "200")
		      (message "OK")
		      headers
		      dont-add-server-header
		      body)
  (unless dont-add-server-header
    (setf headers (cons (cons :server "akari/0.0.1")
			headers)))
  (format stream "~A ~A ~A~%~{~{~A: ~A~}~%~}~&~%~A"
	  version status message
	  (loop for header in headers
		collect (list (car header) (cdr header)))
	  body)
  (force-output stream))
