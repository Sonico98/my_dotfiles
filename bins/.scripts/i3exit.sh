#!/bin/bash

# Prevents exiting i3 abruptly, avoiding possible data loss

# Command to run before doing any other action
sysclose=$(killall -w telegram-desktop; killall -w qbittorrent; mpc pause; systemctl --user stop mpd.service)

case "$1" in
    exit)
	sysclose; i3-msg exit
	;;
    reboot)
	sysclose; systemctl reboot
	;;
    shutdown)
	sysclose; systemctl poweroff -i
	;;
esac
