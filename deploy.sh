#!/bin/sh

deployables=$(fd -t d --max-depth 2 'config-files' -x echo {//})

usage() {
	printf "Please pass a config to deploy\n\nYou can deploy one of these:\n"
	for d in $deployables; do
		printf "\t%s\n" "$d"
	done
	printf "\nFor example do \`%s ./live-iso\` to deploy the config files with gnu stow in ./live-iso/config-files\n" "$0"
}

if test -z "$1"; then
	usage
fi

valid_argument=false
for d in $deployables; do
	if test "$1" = "$d"; then
		valid_argument=true
		break
	fi
done

if ! $valid_argument; then
	printf "ERROR: Could not deploy \`$1\` because it doesn't have a config-files dir to deploy\n\n"
	usage
else
	doas stow -R --no-folding --dir "$1"/config-files -t / . && echo "$1 deployed"
fi
