
; Scheme 48's table package, replicated for Pseudoscheme.
; Somewhat redundant with p-utils.scm.

(define (make-table) (cl:make-hash-table))

(define (table-ref table key)
  (let ((probe (cl:gethash key table)))
    (cl:if probe
	   probe
	   #f)))

(define (table-set! table key val)
  (cl:setf (cl:gethash key table) val))

(define (table-walk proc table)
  (cl:maphash proc table))
