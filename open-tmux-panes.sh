#!/bin/bash

# start a tmux session
tmux

# open 4 ssh sessions using the xpanes tool to create 4 panes in the current tmux window
# https://github.com/greymd/tmux-xpanes
xpanes -x -e -R 4 \
"ssh -i $HOME/.ssh/id_rsa admin@myserver1.mycompany.com" \ 
"ssh -i $HOME/.ssh/id_rsa admin@myserver2.mycompany.com" \ 
"ssh -i $HOME/.ssh/id_rsa admin@myserver3.mycompany.com" \ 
"ssh -i $HOME/.ssh/id_rsa admin@myserver4.mycompany.com"

# turn on keystroke synchronization so I can type into all panes at once
tmux set-window-option synchronize-panes on

# kill the left over pane as we no longer need it
tmux kill-pane