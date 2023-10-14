# ConfigFiles

This repo provides a setup for managing your "config files" (also called "dot files") with source control.
This gives you the ability to use the same config across machines and to potentially share your config with
others as needed.

## Assumptions/Prerequisites

* You have [homebrew](https://brew.sh/) installed
* You have [oh-my-zsh](https://ohmyz.sh/) installed

## Steps

1. [Fork This Repo](#ADD). You can make it a gitlab personal project (will live in your user namespace).
1. Clone your forked copy to `~/.configfiles`. It needs to be places there or else things won't work right.
    * You'll want to run something like this: `git glone git@your-clone-url ~/.configfiles`
1. Update the [0-base.sh](shrcfiles/0-base.sh) with your one login username
1. Optionally, add a `~/.private-config.sh` file to include secrets of config you don't want committed in source control. (Reminder: never put passwords, private keys, or anything sensitive in source control)
1. Update `.gitconfig`:
    1. Copy in your own `.gitconfig` if you have an existing preferred config
    1. **OR** update the included [`.gitconfig`](.gitconfig#L3-4) with your user info
1. If you have an existing/preferred `.zshrc`, copy it in here
   * :warning: If you use your own, you will want to [add these lines yourself](.zshrc#L106-124) or else the `./shrcfiles` won't be loaded into your session
1. Finally, run `./install.sh` to create symlinks for `.zshrc`, `.gitconfig`, and `.gitignore_global`
    * This lets you manage these files via source control, but your system will be able to find them in the expected locations

## ✨ Repo Features

* A patterned way to source control your config files when you update them
* The use of symlinks to make sure when you or some random command updates your config files make it to the repo
* The base `.zshrc` is a direct copy from oh-my-zsh with few modifications
* A folder `shrcriles` that loads alphabetically. Recommend using numbers to control the order that files load. All files are meant to be modified and added to based on user's need or taste
  * [0-base.sh](shrcfiles/0-base.sh) contain your ONELOGIN USERNAME
  * [2-alias.sh](shrcfiles/2-alias.sh) contains some simple ls alias and functions
  * [4-1-aws.sh](shrcfiles/4-1-aws.sh) contains tooling to allow for easy setting of `AWS_PROFILE` from onelogin cli tooling
    * example: `aws-profile-developer granappdevelopment` to get the DeveloperSSO in granappdevelopment
    * requires pipx installs of `onelogin-granular-cli` and `granularaccountmap` to function completely
  * [4-2-docker.sh](shrcfiles/4-2-docker.sh) contains alias for docker including ability to request arm vs intel containers and starting and stopping docker on a Mac from command line
  * [4-3-python.sh](shrcfiles/4-3-python.sh) contains shell setup for `direnv`, `pyenv`, `pyenv-virutalenv`, and `pipx`
  * [4-6-node.sh](shrcfiles/4-6-node.sh) sets up nvm
  * [9-other.sh](shrcfiles/9-other.sh) whatever else you want :P
