#! /bin/sh

cd $(dirname $0)
pwd


sed conkyrc -re s/@FONT_SIZE/22/g \
            -re s/@FONT_DATE_SIZE/15/g \
            -re s/@V_CLOCK/220/g \
            -re s/@VDELTA/68/g \
            -re s/@VDDELTA/48/g \
            -re s/@VMINILINE/15/g \
            -re s/@WLAN/wlp2s0/g \
            > yggdrasill.conkyrc

sed conkyrc -re s/@FONT_SIZE/10/g \
            -re s/@FONT_DATE_SIZE/9/g \
            -re s/@V_CLOCK/122/g \
            -re s/@VDELTA/60/g \
            -re s/@VDDELTA/40/g \
            -re s/@VDELTA/60/g \
            -re s/@VMINILINE/10/g \
            -re s/@WLAN/wlp4s0/g \
            > daban-urnud.conkyrc
