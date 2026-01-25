function g --wraps=git --description 'alias g=git'
	wget --hsts-file="$XDG_CACHE_HOME/wget-hsts" $argv
end
