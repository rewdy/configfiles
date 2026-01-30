# How to install stuff

1. Run `./install.sh` first. This will install brew packages and symlink config into place.

2. If you're using the vim config, you will need Vundle. Get it like this:

```bash
# Clone vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Run the vundle command to install plugins
vim +PluginInstall +qall
```

That's all.
