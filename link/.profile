if [ $TERM = "screen" ]; then
    export TERM=screen-256color
fi
if [ -n "$TMUX" ]; then
    export COLORTERM=rxvt
fi