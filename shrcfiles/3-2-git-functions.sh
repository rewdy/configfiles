############################################################
# GIT FUNCTIONS
############################################################

# All git functions now use git-multi-tool

alias git-revert-to="git-multi-tool restore-snapshot"
alias git-boom="git-multi-tool boom"
alias gbm="git-multi-tool back-to-main"
alias gfr="git-multi-tool sync"

############################################################
# Clone
############################################################

define "git-clone-cd" "Clones a repo and cds into it"
git-clone-cd() {
	if [ -z "$1" ]; then
		notify-fail "Please provide a repo to clone!"
		return 1
	fi
	# Use the given target dir if there is one; otherwise derive it from the url.
	local target="$2"
	if [ -z "$target" ]; then
		target=$(basename "${1%/}")
		target="${target##*:}"
		target="${target%.git}"
	fi
	git clone "$@" || return 1
	cd "$target" || notify-fail "Cloned, but could not cd to $target"
}
define "gcd" "alias for git-clone-cd"
alias gcd=git-clone-cd

############################################################
# Gitignore
############################################################

gi() {
	if [ $# -eq 0 ]; then
		notify-fail "Pls specify some params"
	else
		notify-start "Fetching gitignore"
		notify "This is what would get created:"
		echo "---------"
		curl -sLw "\n" "https://www.toptal.com/developers/gitignore/api/${*}"
		echo "---------"
		read -r answer"?You like?"$'\n\n'"y|n? "
		case ${answer:0:1} in
		y|Y)
			notify "Ok. Creating .gitignore file..."
			curl -sLw "\n" "https://www.toptal.com/developers/gitignore/api/${*}" >> .gitignore
			notify-success "\n✅ Done\n"
		;;
		* )
			notify "🤷‍♀️ Okay. Not doing anything."
		;;
	esac
	fi
}
