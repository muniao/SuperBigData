#!/bin/bash
yum update -y
yum install epel-release -y
yum install tmux wget lrzsz vim net-tools zsh bind-utils yum-utils ctags git htop -y
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
