; File bootit.scm / -*- Mode: Scheme; Syntax: Scheme; Package: Scheme; -*-
; Copyright (c) 1991-1994 Jonathan Rees / See file COPYING

; Bootstrapping a new Pseudoscheme

; You must do (SETQ *USE-SCHEME-READ* NIL) before loading Pseudoscheme
; in order for this to work!

; In a Scheme-in-Common-Lisp implementation, load this file and do
; (bootit).  This compiles and loads the translator, then invokes
; the translator to translate itself.

; Ultimately it would be nice to be able to boot from a Scheme that's
; not Common-Lisp based, but that would require a fair amount of
; hacking: e.g. all the routines in p-utils.scm would have to be rewritten.

(define *pseudoscheme-directory* #f)

(define (bootit . dir-option)
  (cond ((not (null? dir-option))
	 (set! *pseudoscheme-directory* (cl:pathname (car dir-option))))
	((not *pseudoscheme-directory*)
	 (set! *pseudoscheme-directory*
	       (cl:make-pathname :name 'cl:nil
				 :type 'cl:nil
				 :defaults cl:*default-pathname-defaults*))))
  (boot-initialize)
  (load-untranslated-translator)
  (fix-reader-if-necessary)
  (translate-run-time)
  (translate-translator))

(define clever-load #f)

(define (boot-initialize)
  ;; For CL:LOAD to work, we need for *PACKAGE* to be bound to
  ;; something other than the SCHEME package.  Since all these files start
  ;; with IN-PACKAGE forms, it doesn't matter which package in particular, as
  ;; long as it contains IN-PACKAGE and DEFPACKAGE.
  (cl:let ((cl:*package* (or (cl:find-package "CL-USER")
			     (cl:make-package "CL-USER"))))

    ;; Create the PS package
    (cl:load (pseudo-pathname "pack"))

    ;; Get clever file loader
    ;; (cl:load (pseudo-pathname "clever") :verbose 'cl:nil)
    ;; (set! clever-load
    ;;       (cl:symbol-function
    ;;        (cl:intern "CLEVER-LOAD"
    ;;                   (cl:find-package "CLEVER-LOAD"))))

    ;; Fix SCHEME package if necessary
;    (clever-load (pseudo-pathname "purify") :compile-if-necessary #t)
;    (cl:funcall (cl:symbol-function
;                 (cl:intern "FIX-SCHEME-PACKAGE-IF-NECESSARY"
;                            (cl:find-package "SCHEME-PURIFY")))
;                (cl:symbol-package 'askdjfh))
          ))


(define (pseudo-pathname name)
  (cl:make-pathname :name (filename-preferred-case name)
		    :defaults *pseudoscheme-directory*))

(define (filename-preferred-case name)
  #+unix (cl:string-downcase name)
  #-unix (cl:string-upcase name)
  )

(define *scheme-file-type*     (filename-preferred-case "scm"))
(define *translated-file-type* (filename-preferred-case "pso"))
(define *boot-file-type*       (filename-preferred-case "boot"))

; Make sure the host system understands that files foo.boot are
; compiled.

#+Lucid
(if (not (member *boot-file-type*
		 lucid::*load-binary-pathname-types*))
    (lisp:setq lucid::*load-binary-pathname-types*
	       (append lucid::*load-binary-pathname-types*
		       (list *boot-file-type*))))

#+Symbolics
(begin
  (fs:define-canonical-type :boot-bin #,*boot-file-type*)

  (lisp:setq fs:*auxiliary-loadable-file-types*
	(cons '(:boot-bin :load-stream-function
			  si:load-binary-file-internal)
	      (lisp:remove :boot-bin fs:*auxiliary-loadable-file-types*
			   :key #'car)))

  (lisp:setf (lisp:get :boot-bin :binary-file-byte-size)
	     (lisp:get :bin :binary-file-byte-size)))

(define translator-files #f)

; ----- Load the translator into Scheme

(define (load-untranslated-translator)
  ;; Make sure we perform integrations!
  (cl:if (cl:fboundp 'benchmark-mode)
	 (benchmark-mode))
  (set! translator-files
	(call-with-input-file (pseudo-pathname "translator.files") read))
  (for-each (lambda (spec)
	      (load (cl:make-pathname :defaults (cl:merge-pathnames spec)
				       :type *scheme-file-type*)))
            translator-files)
  'done)

; ----- Translating the run-time system

(define (translate-run-time)
  ;; In principle, there could be more stuff here.
  (write-closed-definitions
     revised^4-scheme-structure
     (cl:make-pathname :type *translated-file-type*
		       :defaults (pseudo-pathname "closed")))
  (for-each (lambda (f)
	      (translate-a-file f revised^4-scheme-env))
	    '(;; These are both optional.  Cf. load-run-time in loadit.scm.
	      "read"
	      "write"
	      )))

; ----- Translating the translator

(define (translate-translator)
  (let ((env (make-program-env 'scheme-translator
			       (list revised^4-scheme-structure))))
    (for-each (lambda (f)
		(translate-a-file f env))
	      translator-files)

    (write-defpackages (list revised^4-scheme-structure
			     scheme-translator-structure)
		       "spack.lisp")
    'done))

(define (translate-a-file f env)
  (let ((f (pseudo-pathname f)))
    (really-translate-file
     (cl:make-pathname :type *scheme-file-type* :defaults f)
     (cl:make-pathname :type *translated-file-type* :defaults f)
     env)))


; Make sure that quote and backquote read in properly.  Careful, this
; may cause them to stop working in the Scheme from which we're
; bootstrapping.  It should be done after the translator is loaded,
; but before the translator starts to read any files.

; This is probably no longer needed.

(define (fix-reader-if-necessary)
  (if (not (eq? (car ''foo) 'quote))
      (cl:set-macro-character
        #\'
	(lambda (stream c)
	  (list ''quote (cl:read stream 'cl:t 'cl:nil 'cl:t)))))
  (if (not (eq? (car '`(foo)) 'quasiquote))
      (begin (cl:set-macro-character
	      #\`
	      (lambda (stream c)
		(list ''quasiquote
		      (cl:read stream 'cl:t 'cl:nil 'cl:t))))
	     (cl:set-macro-character
	      #\,
	      (lambda (stream c)
		(let* ((following-char
			(cl:peek-char 'cl:nil stream
                                      'cl:t 'cl:nil 'cl:t))
		       (marker (cond ((char=? following-char #\@)
				      (cl:read-char stream)
				      'unquote-splicing)
				     (else
				      'unquote))))
		  (list marker
			(cl:read stream 'cl:t 'cl:nil 'cl:t))))))))
