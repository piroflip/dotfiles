#!/bin/bash
SESSION=main
tmux="tmux "

# if the session is already running, just attach to it.
$tmux has-session -t $SESSION
if [ $? -eq 0 ]; then
  echo "Session $SESSION already exists. Attaching."
  sleep 1
  $tmux attach -t $SESSION
  exit 0;
fi
# create a new session, named $SESSION, and detach from it
$tmux new-session -d -s $SESSION

$tmux new-window    -t $SESSION:0 -k -n i686     'sudo chroot /opt/arch32 sudo su piroflip'
$tmux new-window    -t $SESSION:1 -k -n vm       'cd /mnt/disk/devel/fpsu/asyn/access/makefres/x86;mc'
$tmux new-window    -t $SESSION:2 -k -n f32bit   'cd /mnt/disk/devel/fpsu/asyn/access/makefres/x86;mc'
$tmux new-window    -t $SESSION:3 -k -n f64bit   'cd /mnt/disk/devel/fpsu64/asyn/access/makefres/x86;mc'
$tmux new-window    -t $SESSION:4

$tmux select-window -t $SESSION:4
$tmux attach -t $SESSION
