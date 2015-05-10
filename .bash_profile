# Source bashrc
. .bashrc

# Set PS1
export PS1="[\[\e[33m\]\A\[\e[0m\]] \h \[\e[33m\]\$(__git_ps1 '%s ')\[\033[32m\]\W\[\e[0m\]$ "

# Mac OS fix
function __git_ps1() {
	local branch=$(git branch 2>/dev/null | grep '*' | sed 's/* \(.*\)/(\1)/')
	if [ -n "$branch" ]; then
		echo "$branch "
	fi
}
