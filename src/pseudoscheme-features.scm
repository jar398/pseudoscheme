; -*- Mode: Scheme; Syntax: Scheme; Package: Scheme; -*-
; Copyright (c) 1993, 1994 by Richard Kelsey and Jonathan Rees.
; Copyright (c) 1996 by NEC Research Institute, Inc.    See file COPYING.


; This is file pseudoscheme-features.scm.
; Synchronize any changes with all the other *-features.scm files.

(define *load-file-type* #f) ;For fun


; SIGNALS

(define error #'ps:scheme-error)

(define warn #'ps:scheme-warn)

(define (signal type . stuff)
  (apply warn "condition signalled" type stuff))

(define (syntax-error . rest)		; Must return a valid expression.
  (apply warn rest)
  ''syntax-error)

(define (call-error message proc . args)
  (error message (cons proc args)))


; FEATURES

(define force-output #'cl:force-output)

(define (string-hash s)
  (let ((n (string-length s)))
    (do ((i 0 (+ i 1))
         (h 0 (+ h (cl:char-code (string-ref s i)))))
        ((>= i n) h))))

(define (make-immutable! thing) thing)
(define (immutable? thing) thing #f)
(define (unspecific) (if #f #f))


; BITWISE

(define arithmetic-shift #'cl:ash)
(define bitwise-and #'cl:logand)
(define bitwise-ior #'cl:logior)
(define bitwise-not #'cl:lognot)


; ASCII

(define char->ascii #'cl:char-code)
(define ascii->char #'cl:code-char)
(define ascii-limit cl:char-code-limit)
(define ascii-whitespaces '(32 10 9 12 13))


; CODE-VECTORS

(define (make-code-vector len . fill-option)
  (cl:make-array len
		 :element-type '(cl:unsigned-byte 8)
		 :initial-element (if (null? fill-option)
				      0
				      (car fill-option))))

(define (code-vector? obj)
  (ps:true? (cl:typep obj
		      (cl:quote (cl:simple-array (cl:unsigned-byte 8)
						 (cl:*))))))

(define (code-vector-ref bv k)
  (cl:aref (cl:the (cl:simple-array (cl:unsigned-byte 8) (cl:*))
		   bv)
	   k))

(define (code-vector-set! bv k val)
  (cl:setf (cl:aref (cl:the (cl:simple-array (cl:unsigned-byte 8)
					     (cl:*))
			    bv)
		    k)
	   val))

(define (code-vector-length bv)
  (cl:length (cl:the (cl:simple-array (cl:unsigned-byte 8) (cl:*))
		     bv)))


; The rest is unnecessary in Pseudoscheme versions 2.8d and after.

;(define eval #'schi:scheme-eval)
;(define (interaction-environment) schi:*current-rep-environment*)
;(define scheme-report-environment
;  (let ((env (scheme-translator:make-program-env
;              'rscheme
;              (list scheme-translator:revised^4-scheme-module))))
;    (lambda (n)
;      n ;ignore
;      env)))

; Dynamic-wind.
;
;(define (dynamic-wind in body out)
;  (in)
;  (cl:unwind-protect (body)
;    (out)))
;
;(define values #'cl:values)
;
;(define (call-with-values thunk receiver)
;  (cl:multiple-value-call receiver (thunk)))
