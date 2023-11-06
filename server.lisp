(in-package :server)

;;;; https://github.com/nathanvy/protohax
;;;; /blob/master/00-smoketest/smoketest.lisp

(defparameter *halt* nil)

(defun handle-client (socket handler)
  (let ((stream (usocket:socket-stream socket)))
    (funcall handler stream)
    (usocket:socket-close socket)))

(defun listen-for-connections (host port handler)
  (let ((listener (usocket:socket-listen host port
					 :reuse-address t)))
    (loop until *halt*
	  do (let ((new-clients (usocket:wait-for-input listener
							:ready-only t)))
	       (loop for client in new-clients
		     for socket = (usocket:socket-accept client)
		     do (bt:make-thread
			 (lambda () (handle-client socket handler))))))
    (usocket:socket-close listener)))

(defun init (handler &optional (host "0.0.0.0") (port 54321))
  (bt:make-thread
   (lambda ()
     (format t "Listening for connections on ~A:~A~%" host port)
     (listen-for-connections host port handler))
   :name "tcp-listener"))

(defun die ()
  (setf *halt* t))
