#!/bin/bash
set -euo pipefail

LOCKSCREEN_DIR=/tmp # this dir must contain a dir called 'lockscreen'
BLURTYPE="15"

export XSECURELOCK_FONT="Kosefont JP"
export XSECURELOCK_AUTH_BACKGROUND_COLOR=black
export XSECURELOCK_AUTH_FOREGROUND_COLOR=white
export XSECURELOCK_PASSWORD_PROMPT=kaomoji
export XSECURELOCK_COMPOSITE_OBSCURER=0
export XSECURELOCK_AUTH_TIMEOUT=5
export XSECURELOCK_BLANK_TIMEOUT=10
export XSECURELOCK_BLANK_DPMS_STATE=off
export XSECURELOCK_SAVER=/home/sonico/.bins/.scripts/lockscreen/saver.sh

if [ -z ${LOCKSCREEN_DIR+x} ]; then exit 1; fi # bail if lockscreen dir is not set

rm -rf ${LOCKSCREEN_DIR}/lockscreen; mkdir ${LOCKSCREEN_DIR}/lockscreen
scrot -q 50 ${LOCKSCREEN_DIR}/lockscreen-plain.jpg --overwrite -e "
$HOME/.bins/.scripts/blur -s ${BLURTYPE} ${LOCKSCREEN_DIR}/lockscreen-plain.jpg ${LOCKSCREEN_DIR}/lockscreen-blurred.jpg"
mv ${LOCKSCREEN_DIR}/lockscreen-blurred.jpg ${LOCKSCREEN_DIR}/lockscreen/lockscreen.jpg &
xset dpms force off
xsecurelock
rm -rf ${LOCKSCREEN_DIR}/lockscreen
