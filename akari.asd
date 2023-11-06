(defsystem "akari"
  :depends-on (#:usocket #:bordeaux-threads)
  :components ((:file "package")
	       (:file "server")
	       (:file "markup")
	       (:file "http")
	       (:file "explorer")
	       (:file "akari"))
  :build-operation "program-op"
  :build-pathname "akari"
  :entry-point "akari:main")
