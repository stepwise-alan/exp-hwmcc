#!/usr/bin/zsh

PROG=@Z3@
TIMEOUT=@TIMEOUT@

"$PROG" -T:$TIMEOUT -st -v:1 fp.engine=spacer fp.print_statistics=true "$1"
