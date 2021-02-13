#!/bin/bash

# wm-theme [night|day]
# Sets dark mode on or off on i3wm

# Theme names ########################
light_gtk_theme="Materia-light-compact"
dark_gtk_theme="Adapta-Nokto-Eta"
light_gtk_icon="McMojave-circle-pink"
dark_gtk_icon="McMojave-circle-pink-dark"

# Hex colors #########################
# Background #########################
rofi_bg_light="#FFFFFFB5"
rofi_bg_dark="#000000B5"
twmn_bg_light="#CCFFFFFF"
twmn_bg_dark="#BE000000"
# Foreground #########################
rofi_fg_light="#000000FF"
rofi_fg_dark="#EFEFEF"
twmn_fg_light="#212121"
twmn_fg_dark="#C8C8C8"

# Configuration paths ################
kitty_conf_path="$HOME/.config/kitty"
rofi_conf_path="$HOME/.config/rofi"
plb_conf_path="$HOME/.config/polybar"


# Script start
case "$1" in
    day)
        # Light mode
	new_gtk_theme="$light_gtk_theme"
	prev_gtk_theme="$dark_gtk_theme"
	new_gtk_icon="$light_gtk_icon"
	kitty_theme="theme_light.conf"
	new_rofi_bg="$rofi_bg_light"
	new_rofi_fg="$rofi_fg_light"
	prev_rofi_bg="$rofi_bg_dark"
	prev_rofi_fg="$rofi_fg_dark"
	new_plb_theme='${colors-light'
	prev_plb_theme='${colors-dark'
	new_twmn_bg="$twmn_bg_light"
	new_twmn_fg="$twmn_fg_light"
	prev_twmn_bg="$twmn_bg_dark"
	prev_twmn_fg="$twmn_fg_dark"
	;;
    night)
	# Dark mode
	new_gtk_theme="$dark_gtk_theme"
	prev_gtk_theme="$light_gtk_theme"
	new_gtk_icon="$dark_gtk_icon"
	kitty_theme="theme_dark.conf"
	new_rofi_bg="$rofi_bg_dark"
	new_rofi_fg="$rofi_fg_dark"
	prev_rofi_bg="$rofi_bg_light"
	prev_rofi_fg="$rofi_fg_light"
	new_plb_theme='${colors-dark'
	prev_plb_theme='${colors-light'
	new_twmn_bg="$twmn_bg_dark"
	new_twmn_fg="$twmn_fg_dark"
	prev_twmn_bg="$twmn_bg_light"
	prev_twmn_fg="$twmn_fg_light"
	;;
esac

# Change polybar's colors
# This should always be the first thing to change theme, to prevent
# some problems with the tray
sed -i "s/$prev_plb_theme/$new_plb_theme/" "$plb_conf_path"/config

# Change GTK and QT themes
sed -i "s#Net/ThemeName .*#Net/ThemeName \"$new_gtk_theme\"#" $HOME/.xsettingsd
sed -i "s#Net/IconThemeName .*#Net/IconThemeName \"$new_gtk_icon\"#" $HOME/.xsettingsd 
sed -i "s#icon_theme=.*#icon_theme=$new_gtk_icon#" $HOME/.config/qt5ct/qt5ct.conf

## Apply the change using xsettingsd
killall xsettingsd
xsettingsd &

# Change kitty terminal's colors
rm -rf "$kitty_conf_path"/theme.conf
ln -s "$kitty_conf_path"/Themes/"$kitty_theme" "$kitty_conf_path"/theme.conf

# Change rofi's colors
sed -i "s/$prev_rofi_bg/$new_rofi_bg/" "$rofi_conf_path"/config.rasi
sed -i "s/$prev_rofi_fg/$new_rofi_fg/" "$rofi_conf_path"/config.rasi

# Change twmn's colors
sed -i "s/$prev_twmn_bg/$new_twmn_bg/" $HOME/.config/twmn/twmn.conf
sed -i "s/$prev_twmn_fg/$new_twmn_fg/" $HOME/.config/twmn/twmn.conf
kill -9 $(pidof twmnd) && twmnd &

# Send a little notification
sleep 1		# So the daemon has time to start
twmnc -t "We're now during the '$1'!"
