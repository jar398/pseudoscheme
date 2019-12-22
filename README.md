# pseudoscheme
Scheme to Common Lisp

Using pseudoscheme:

To load, assuming cwd is the pseudoscheme src dir.

```lisp
(load "loadit.lisp")
(load-pseudoscheme)
```

The main issue running it in slime is the readtable. To make it work, 
change to the scheme package in the listener then use the scheme package.

```lisp
(setq *readtable* ps::roadblock-readtable)
(in-package :scheme)
```
Then use slime eval functions. in the buffer you are editing in. 
slime-load-file doesn't work (yet).
