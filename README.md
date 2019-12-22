# Pseudoscheme - Scheme to Common Lisp

This repository was initially populated from version 2.13b, accessed
from https://mumble.net/~jar/pseudoscheme/ - see that page for more
information.

This code was originally written around 1985 by Jonathan Rees.  It
incubated work that later became Scheme 48 (1986), standard Scheme
macros (`syntax-rules`) (1989 or so), and Mobot Scheme (1991).

## To do

It needs to be updated for modern Common Lisp implementations.  Much
of the system building architecture could probably be replaced by
ASDF.

The .pso files ought to be moved out of the `src` directory because
they are not really source files.
