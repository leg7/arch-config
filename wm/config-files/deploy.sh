#!/bin/sh
fd -t f -X rm -I /{}
stow -R --no-folding -t / .
