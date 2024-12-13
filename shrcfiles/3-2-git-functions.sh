#!/bin/bash

git-first-push() {
	notify-start "Git: First push"
	current_branch=$(git rev-parse --abbrev-ref HEAD)
	cmd="git push --set-upstream origin ${current_branch} --follow-tags"
	eval "$cmd"
}

alias gfp='git-first-push'

git-revert-to() {
	if [ -z "$1" ]; then
		notify-fail "Pls specify a commit hash to revert to"
	else
		git diff HEAD "$1" | git apply
	fi
}

git-boom() {
	notify-start "BOOM 💥"
	cmd="git reset --hard HEAD && git clean -f"
	if [ "$1" = "-y" ]; then
		echo "💥 Clearing all uncommitted 💥"
		eval "$cmd"
	else
		read -r answer"?Want to clear all uncommitted, including untracked files?:"$'\n\t'"${cmd}"$'\n\n'"y|n? "
		case ${answer:0:1} in
			y|Y )
				echo "💥 Clearing all uncommitted 💥"
				eval "$cmd"
			;;
			* )
				echo "Doing nothing..."
				exit
			;;
		esac
	fi
}

git-back-to-master() {
	notify-start "Git back to master"
	current_branch=$(git rev-parse --abbrev-ref HEAD)
	master_branch=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
	if [ $# -eq 0 ]
	then
		stash=0
		confirm_msg="⭐️ Should I: 1.) checkout $master_branch, 2.) pull updates, and 3.) delete current branch?"$'\n\n'"y|n?"
	elif [ "$1" = "--stash" ]
	then
		stash=1
		confirm_msg="⭐️ Should I: 1.) stash changes 2.) checkout $master_branch, 3.) pull updates, and 4.) delete current branch 5. ) apply stash?"$'\n\n'"y|n?"
	fi

	case $current_branch in
		"$master_branch" )
			notify-fail "Can't do this on $master_branch. Checkout the branch you want to remove and try again."
		;;
		* )
			git status
			printf "\n"
			read -r answer"?$confirm_msg "
			case ${answer:0:1} in
				y|Y)
					notify "Here we go...\n"
					if [ $stash -eq 1 ]; then
						git stash
						notify-success "Stashed changes...\n"
					fi
					git checkout "$master_branch"
					notify-success "Checked out $master_branch...\n"
					git pull
					notify-success "Pulled latest and greatest...\n"
					git branch -D "$current_branch"
					notify-success "Working branch removed. All done.\n\n"
					if [ $stash -eq 1 ]; then
						git stash apply
						notify-success "Applied stash...\n"
					fi
				;;
				* )
					notify "🤷‍♀️ Okay. Not doing anything."
				;;
			esac
		;;
	esac
}

alias gbm='git-back-to-master'

git-clear-branches() {
	notify-start "Clear all branches"
	read -r answer"?Remove all local branches except master?"$'\n\n'"y|n? "
	case ${answer:0:1} in
		y|Y)
			notify "kk..."
			git branch | grep -v "master" | xargs git branch -D
			notify-success "Everything gone but master. I love you.\n"
		;;
		* )
			notify "🤷‍♀️ Okay. Not doing anything."
		;;
	esac
}

gi() {
	if [ $# -eq 0 ]; then
		notify-fail "Pls specify some params"
	else
		notify-start "Fetching gitignore"
		notify "This is what would get created:"
		echo "---------"
		curl -sLw "\n" https://www.toptal.com/developers/gitignore/api/$@
		echo "---------"
		read -r answer"?You like?"$'\n\n'"y|n? "
		case ${answer:0:1} in
		y|Y)
			notify "Ok. Creating .gitignore file..."
			curl -sLw "\n" https://www.toptal.com/developers/gitignore/api/$@ >> .gitignore
			notify-success "\n✅ Done\n"
		;;
		* )
			notify "🤷‍♀️ Okay. Not doing anything."
		;;
	esac
	fi
}
