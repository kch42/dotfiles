#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

xset fp rehash

# Windows button is now compose key
setxkbmap -option compose:lwin
setxkbmap -option compose:rwin

# Start godoc server
godoc -http=":6060" &

# exec gnome-session
# exec startkde

#exec startxfce4

if test -e "$BAR_FIFO"; then
	rm -f "$BAR_FIFO"
	mkfifo "$BAR_FIFO"
fi

if test $(hostname) = "kch42-notebook"; then
	synclient TapButton1=0
	synclient VertTwoFingerScroll=0
	synclient VertEdgeScroll=1
fi

start-pulseaudio-x11 &
xsetroot -cursor_name left_ptr &
hsetroot -fill ~/"Bilder/backgrounds/earthporn/1q1tk1 - milky way behind fuji.jpg"
dunst &
sxhkd &
compton &
myredshift daemon &
exec bspwm 2> ~/.bspwm.log

# ...or the Window Manager of your choice
