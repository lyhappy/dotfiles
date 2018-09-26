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
