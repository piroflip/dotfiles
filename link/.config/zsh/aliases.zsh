#█▓▒░ aliases
alias ll="ls -lah --color=auto"
alias ls="ls --color=auto"
alias lsl="ls -lh --color=auto"
alias c="make clean"
alias m="make"
#alias mc="ranger"

# radio
radio(){
 case $1 in
 1) mplayer -nolirc -playlist http://www.radiotunes.com/mp3/urbanjamz.pls ;;
 2) mplayer -nolirc -playlist http://www.radiotunes.com/mp3/classicrap.pls ;;
 3) mplayer -nolirc -playlist http://www.radiotunes.com/mp3/urbanpophits.pls ;;
 4) mplayer -nolirc -playlist http://www.radiotunes.com/mp3/90srnb.pls ;;
 5) mplayer -nolirc -playlist http://www.radiotunes.com/mp3/romantic.pls ;;
 6) mplayer -nolirc -playlist http://www.radiotunes.com/mp3/altrock.pls ;;
 esac
}
