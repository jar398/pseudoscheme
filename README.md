# Pseudoscheme - Scheme to Common Lisp

This repository was initially populated from version 2.13b, accessed
from https://mumble.net/~jar/pseudoscheme/ - see that page for more
information.

This code was originally written around 1985 by Jonathan Rees.  It ran
on the [Symbolics Lisp Machines](https://en.wikipedia.org/wiki/Lisp_machine),
and later in [VAX LISP](https://en.wikipedia.org/wiki/Vax_Common_Lisp)
and other Common
Lisp implementations.  It incubated [Scheme 48](http://s48.org/) (1986),
standard [Scheme macros](http://3e8.org/pub/pdf-t1/macros_that_work.pdf)
(1989), and [Mobot Scheme](https://mumble.net/~jar/pubs/scheme-mobile-robots.pdf)
(1991).

## To do

It needs to be updated for modern Common Lisp implementations.  Much
of the system building architecture could probably be replaced by
[ASDF](https://common-lisp.net/project/asdf/).

The `.pso` files ought to be moved out of the `src` directory because
they are not really source files.
