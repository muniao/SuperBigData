#!/bin/bash

git config --global user.name mritd
git config --global user.email mritd1234@gmail.com
git config --global core.editor vim
git config --global push.default simple
git config --global core.excludesfile ~/.global_gitignore
git config --global user.signingkey 1C78FD62CEA2C04B79EA459F7CB6F1DA9030B819
git config --global commit.gpgsign true
git config --global gpg.program gpg
git config --global core.quotepath false
echo ".idea" >> ~/.global_gitignore
