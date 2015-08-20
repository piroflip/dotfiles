set AWESOME_IGNORE_LGI=1
/usr/bin/start-pulseaudio-x11
xmodmap ~/.Xmodmap
#exec awesome &>~/awesome.log

#redshift -l 55.6:37.6 -t 5500:4500

unclutter -idle 1 &
xsetroot -cursor_name left_ptr
xset +fp /usr/share/fonts/local
nitrogen --restore &
urxvtd -q -f -o &
firefox &
#sxhkd &
#exec bspwm &>~/bspwm.log
exec herbstluftwm &>~/herbstluft.log
