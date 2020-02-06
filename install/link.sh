#!/usr/bin/env bash

DOTFILES=$HOME/code/dotfiles


echo -e '\\nCreating symlinks'
echo '================================='
linkables=$( find -H ${DOTFILES} -maxdepth 3 -name '*.symlink' )

echo $linkables
for file in $linkables; do
  target="$HOME/.$( basename "$file" '.symlink' )"
  echo $target
  if [ -e "$target" ]; then
    echo '~${target#HOME} already exists... Skipping.'
  else
    echo "Creating symlink for $file"
    ln -s "${file}" "${target}"
  fi
done

echo -e "\\n\\ninstalling to ~/.config"
echo "=============================="
if [ ! -d "$HOME/.config" ]; then
  echo "Creating ~/.config"
  mkdir -p "$HOME/.config"
fi

config_files=$( find "$DOTFILES/config" -d 1 2>/dev/null )
for config in $config_files; do
  target="$HOME/.config/$( basename "$config" )"
  if [ -e "$target" ]; then
    echo "~${target#$HOME} already exists... Skipping."
  else
    echo "Creating symlink for $config"
    ln -s "$config" "$target"
  fi
done

# create vim symlinks
# As I have moved off of vim as my full time editor in favor of neovim,
# I feel it doesn't make sense to leave my vimrc intact in the dotfiles repo
# as it is not really being actively maintained. However, I would still
# like to configure vim, so lets symlink ~/.vimrc and ~/.vim over to their
# neovim equivalent.
echo -e "\\n\\nCreating vim symlinks"
echo "=============================="
VIMFILES=( "$HOME/.vim:$DOTFILES/config/vim"
        "$HOME/.vimrc:$DOTFILES/config/vim/init.vim"
        "$HOME/.ideavimrc:$DOTFILES/config/vim/init.ideavimrc")

for file in "${VIMFILES[@]}"; do
    KEY=${file%%:*}
    VALUE=${file#*:}
    if [ -e "${KEY}" ]; then
        echo "${KEY} already exists... skipping."
    else
        echo "Creating symlink for $KEY"
        ln -s "${VALUE}" "${KEY}"
    fi
done

# create emacs symlinks
echo -e "\\n\\nCreating emacs symlinks"
echo "=============================="
EMACSFILES=("$HOME/.emacs.d/init.el:$DOTFILES/config/emacs/init.el"
            "$HOME/.emacs.d/myinit.org:$DOTFILES/config/emacs/myinit.org")

for file in "${EMACSFILES[@]}"; do
    KEY=${file%%:*}
    VALUE=${file#*:}
    if [ -e "${KEY}" ]; then
        echo "${KEY} alread exists.. skipping."
    else
        echo "Creating symlink for $KEY"
        ln -s "${VALUE}" "${KEY}"
    fi
done
