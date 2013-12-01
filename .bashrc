#
# ~/.bashrc
#

export GOPATH="$HOME/go"
export PATH=$HOME/bin:$GOPATH/bin:$PATH
export TEXMFHOME="$HOME/texmf"
export EDITOR="nano"
export BLOGROOT="$HOME/blog"
export PLAN9=/opt/plan9

export BAR_FIFO=$HOME/mybar/fifo
export REDSHIFT_FIFO=$HOME/.redshift_fifo

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Aliases
alias ls='ls --color=auto'
alias xo='exo-open'
alias la='ls -lah --color=auto'
alias cb='xclip -i -selection clipboard'

PS1="[ \[\e[1m\]\W\[\e[0m\] ]$ "

mkcd() {
	mkdir "$1"
	cd "$1"
}

unlatin1() {
	mv "$1"  /tmp/unlatin1.data
	iconv --from=latin1 --to=utf8 /tmp/unlatin1.data > "$1"
	rm -f /tmp/unlatin1.data
}

relatin1() {
	cp "$1" /tmp/relatin1.data
	iconv --from=utf8 --to=latin1 /tmp/relatin1.data > "$1"
	rm /tmp/relatin1.data
}
