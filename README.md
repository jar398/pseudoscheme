# Pseudoscheme - Scheme to Common Lisp

Pseudoscheme is an implementation of Scheme on top of Common Lisp.  It
lacks upward continuations and full tail recursion (some special cases
are supported for loops) - thus the "pseudo".  Otherwise the language
implemented is [Revised^4 Scheme report
Scheme](https://dspace.mit.edu/handle/1721.1/6424).

Pseudocheme consists primarily of a Scheme to Common Lisp translator
that is written in Scheme.  To obtain a version of the translator that
runs in Common Lisp, it is applied to itself.  That is the origin of
the `.pso` (Pseudoscheme output or object) files in the distribution.

## How to use

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
Then use slime eval functions in the buffer you are editing in. 
`slime-load-file` doesn't work (yet).

(Looks like `ps:enter-scheme` should work to set `*package*` and
`*readtable*`, and `ps:exit-scheme` to restore them to their 
previous values.  See `eval.lisp`.)

## Acknowledgments

Thanks to
 * Alan Ruttenberg for updates in 2019
 * Zach Beane for prodding in 2011 (version 2.13b)
 * Oleg Trott for updates in 2005? (version 2.13a)
 * Hannu Koivisto for updates in ... when, maybe 2001? (2.13)
 * many others over the years

## History

This repository was initially populated in December 2019 from version
2.13b, accessed from https://mumble.net/~jar/pseudoscheme/ - see that
page for more information.

The code was originally written around 1985 by Jonathan Rees.  It ran
on the [Symbolics Lisp Machines](https://en.wikipedia.org/wiki/Lisp_machine),
and later in [VAX LISP](https://en.wikipedia.org/wiki/Vax_Common_Lisp),
[Lucid Common Lisp](https://en.wikipedia.org/wiki/Lucid_Inc.),
and other Common
Lisp implementations.  Pseudoscheme incubated 
[Scheme 48](http://s48.org/) (1986),
standard [Scheme macros](http://3e8.org/pub/pdf-t1/macros_that_work.pdf)
(1989), and 
[CSRVL Mobot Scheme](https://mumble.net/~jar/pubs/scheme-mobile-robots.pdf)
(1991).

## To do

 * It needs to be updated for modern Common Lisp implementations. Much of the system building and bootstrap infrastructure could probably be replaced by features provided by [ASDF](https://common-lisp.net/project/asdf/).
 * The `.pso` files ought to be moved out of the `src` directory because they are not really source files.
