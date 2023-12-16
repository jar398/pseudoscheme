;;; -*- Mode: Lisp -*-

;;;; Pseudoscheme
;;;; System Definitions

(cl:defpackage :pseudoscheme-system
  (:use :common-lisp :asdf))

(cl:in-package :pseudoscheme-system)

(defclass pso-file (cl-source-file) ())

(defmethod source-file-type ((component pso-file) system)
  (declare (ignore component system))
  "pso")

(defsystem :pseudoscheme-rts
  :author "Jonathan Rees"
  :components
    (
     (:file "pack")
     (:file "spack" :depends-on ("pack"))
     ;; I don't remember what was in this file, but it doesn't seem to
     ;; have been necessary anyway!
     ;;   (:file "pathnames" :depends-on ("pack"))
     (:file "core" :depends-on ("pack"))
     (pso-file "closed" :depends-on ("spack" "core"))
     (:file "rts" :depends-on ("pack" "spack" "core"))
     (:file "readwrite" :depends-on ("pack" "core"))
     #+(or) (pso-file "read" :depends-on ("spack" "core"))
     #+(or) (pso-file "write" :depends-on ("spack" "core"))
     ))

(defsystem :pseudoscheme-translator
  :author "Jonathan Rees"
  :depends-on (:pseudoscheme-rts)
  :serial t                        ;[No time to figure out the deps... --TRC]
  :components
  (
   (pso-file "p-record")                ; record package
   (pso-file "p-utils")                 ; tables and fluids
   (pso-file "list")                    ; list utilities
   (pso-file "classes")                 ; expression classes
   (pso-file "form")                    ; expression stuff used by classifier
   (pso-file "classify")                ; expression classifier
   (pso-file "node")                    ; budding node abstraction
   (pso-file "module")                  ; signatures and structures
   (pso-file "ssig")                    ; Scheme signature
   (pso-file "alpha")                   ; front end
   (pso-file "rules")                   ; the (syntax-rules ...) macro
   (pso-file "derive")                  ; derived expression types
   (pso-file "strategy")                ; LETREC strategy anaylzer
   (pso-file "version")
   (pso-file "schemify")                ; degenerate back end

   ;; Common Lisp back end
   (pso-file "emit")                    ; code emission utilities
   (pso-file "generate")                ; CL code generator
   (pso-file "builtin")                 ; CL info about scheme built-ins
   (pso-file "translate")               ; phase coordination and file transducer
   (pso-file "reify")                   ; miscellaneous

   ;; ASDF Support (not yet implemented)
   ;;   (:file "asdf")
   ))

(defsystem :pseudoscheme-evaluator
  :author "Jonathan Rees"
  :depends-on (:pseudoscheme-rts :pseudoscheme-translator)
  :components ((:file "eval")))

(defsystem :pseudoscheme
  :author "Jonathan Rees"
  :depends-on
    (:pseudoscheme-rts :pseudoscheme-translator :pseudoscheme-evaluator))
