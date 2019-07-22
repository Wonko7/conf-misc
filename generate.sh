#! /bin/sh

cd $(dirname $0)
pwd

sed conky/conkyrc \
  -re s/@WIDTH/250/g \
  -re s/@TOP_WIDTH/9/g \
  -re s/@FONT_SIZE/22/g \
  -re s/@FONT_DATE_SIZE/15/g \
  -re s/@FONT_DESKTOP_SIZE/18/g \
  -re s/@V_CLOCK/220/g \
  -re s/@VDELTA/68/g \
  -re s/@VDDELTA/48/g \
  -re s/@VDDDELTA/68/g \
  -re s/@H_TOP/180/g \
  -re s/@VMINILINE/15/g \
  -re s/@WLAN/wlp2s0/g \
  > generated/yggdrasill.conkyrc

sed conky/conkyrc \
  -re s/@WIDTH/150/g \
  -re s/@TOP_WIDTH/14/g \
  -re s/@FONT_SIZE/10/g \
  -re s/@FONT_DATE_SIZE/9/g \
  -re s/@FONT_DESKTOP_SIZE/10/g \
  -re s/@V_CLOCK/122/g \
  -re s/@VDELTA/68/g \
  -re s/@VDDELTA/48/g \
  -re s/@VDDDELTA/58/g \
  -re s/@H_TOP/120/g \
  -re s/@VMINILINE/10/g \
  -re s/@WLAN/wlp4s0/g \
  > generated/daban-urnud.conkyrc

sed dunstrc \
  -re s/@WIDTH/150/g \
  > generated/daban-urnud.dunstrc

sed dunstrc \
  -re s/@WIDTH/250/g \
  > generated/yggdrasill.dunstrc
