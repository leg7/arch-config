#!/bin/sh

stow -R --no-folding --dir config-files -t /home home
doas stow -R --no-folding --dir config-files -t /etc etc
doas stow -R --no-folding --dir config-files -t /root root

