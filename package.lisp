(defpackage :server
  (:use :cl :usocket :bordeaux-threads)
  (:export :init :die))

(defpackage :markup
  (:use :cl)
  (:export :generate-markup))

(defpackage :http
  (:use :cl)
  (:export :send :receive))

(defpackage :explorer
  (:use :cl)
  (:export :explore))

(defpackage :akari
  (:use :cl :server :markup :http :explorer)
  (:export :main))
