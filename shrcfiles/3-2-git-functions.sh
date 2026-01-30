############################################################
# GIT FUNCTIONS
############################################################

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
	notify-start "Git back to master (v2)"

	# Parse flags
	force_stash=0
	force_clear=0
	force_run=0
	while [[ $# -gt 0 ]]; do
		case $1 in
			--stash)
				force_stash=1
				shift
				;;
			--clear)
				force_clear=1
				shift
				;;
			--force|-f)
				force_run=1
				shift
				;;
			*)
				notify-fail "Unknown option: $1"
				return 1
				;;
		esac
	done

	# Get current branch and default branch
	current_branch=$(git rev-parse --abbrev-ref HEAD)
	default_branch=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')

	# Check if we're already on default branch
	if [ "$current_branch" = "$default_branch" ]; then
		notify-fail "Already on $default_branch. Nothing to do."
		return 1
	fi

	# Safety confirmation (unless --force or -f is used)
	if [ $force_run -eq 0 ]; then
		git status
		printf "\n"
		notify-warn "This will:"
		echo "  1. Handle uncommitted changes (stash or clear)"
		echo "  2. Checkout $default_branch"
		echo "  3. Pull latest changes"
		echo "  4. DELETE branch '$current_branch'"
		printf "\n"
		read -r answer"?Continue?"$'\n\n'"y|n? "
		case ${answer:0:1} in
			y|Y)
				notify "Proceeding...\n"
				;;
			*)
				notify-calm "🤷‍♀️ Okay. Not doing anything."
				return 1
				;;
		esac
	fi

	# Check for uncommitted changes
	if ! git diff-index --quiet HEAD --; then
		notify "You have uncommitted changes."

		# Handle uncommitted changes based on flags or user input
		if [ $force_stash -eq 1 ]; then
			action="stash"
		elif [ $force_clear -eq 1 ]; then
			action="clear"
		else
			git status
			printf "\n"
			read -r answer"?What would you like to do with uncommitted changes?"$'\n'"  s) Stash them"$'\n'"  c) Clear them (git-boom)"$'\n'"  q) Quit"$'\n\n'"s|c|q? "
			case ${answer:0:1} in
				s|S)
					action="stash"
					;;
				c|C)
					action="clear"
					;;
				*)
					notify-calm "🤷‍♀️ Okay. Not doing anything."
					return 1
					;;
			esac
		fi

		# Execute the chosen action
		if [ "$action" = "clear" ]; then
			git-boom -y
			stash_applied=0
		elif [ "$action" = "stash" ]; then
			git stash push -m "git-back-to-master-2 auto-stash"
			notify-success "Stashed changes...\n"
			stash_applied=1
		fi
	else
		stash_applied=0
	fi

	# Save current branch name for deletion
	branch_to_delete="$current_branch"

	# Checkout default branch
	notify "Checking out $default_branch..."
	git checkout "$default_branch"
	notify-success "Checked out $default_branch...\n"

	# Pull latest changes
	notify "Pulling latest changes..."
	git pull
	notify-success "Pulled latest and greatest...\n"

	# Delete the previous branch
	notify "Deleting branch $branch_to_delete..."
	git branch -D "$branch_to_delete"
	notify-success "Working branch removed...\n"

	# Apply stash if we created one
	if [ $stash_applied -eq 1 ]; then
		notify "Applying stashed changes..."
		git stash pop
		notify-success "Applied stash...\n"
	fi

	notify-success "All done! 🎉\n"
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

git-fetch-and-rebase-main() {
  # Parse flags
  do_stash=0
  while [[ $# -gt 0 ]]; do
    case $1 in
      --stash) do_stash=1; shift ;;
      *) notify-fail "Unknown option: $1"; return 1 ;;
    esac
  done

  main=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
  current_branch=$(git rev-parse --abbrev-ref HEAD)

  # Fail early if we're on the main branch
  if [ "$current_branch" = "$main" ]; then
    notify-fail "You are on $main. Just call git pull --rebase instead."
    return 1
  fi

  # Notify we're starting
  message="Fetch and rebase on $main"
  if [ $do_stash -eq 1 ]; then
    message+=" (with stash)"
  fi
  notify-start "$message"

  # Do the stuff
  [ $do_stash -eq 1 ] && git stash push -m "git-fetch-and-rebase-main auto-stash"
  git fetch
  git rebase origin/"$main"
  [ $do_stash -eq 1 ] && git stash pop

  notify-success "All done.\n"
}

alias gfr='git-fetch-and-rebase-main'

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
