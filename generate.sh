#! /bin/dash

cd $(dirname $0)

# so this won't scale
# yggdrasill:
y_border=40
y_conky_width=250
# daban-urnud:
d_border=20
d_conky_width=150
# rocinante:
r_border=20
r_conky_width=150


for i in $@; do
  case $i in
    --git)   generate_git=1;;
    --conky) generate_conky=1;;
    --dunst) generate_dunst=1;;
  esac
done

if [ -z "$generate_dunst$generate_conky$generate_git" ]; then
  generate_dunst=1
  generate_conky=1
  generate_git=1
fi

if [ ! -z $generate_conky ]; then
  echo conky!
  sed conky/conky.conf \
    -re s/@WIDTH/$y_conky_width/g \
    -re s/@GAP_X/$y_border/g \
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

  sed conky/conky.conf \
    -re s/@WIDTH/$d_conky_width/g \
    -re s/@GAP_X/$d_border/g \
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

  sed conky/conky.conf \
    -re s/@WIDTH/$r_conky_width/g \
    -re s/@GAP_X/$r_border/g \
    -re s/@TOP_WIDTH/14/g \
    -re s/@FONT_SIZE/9/g \
    -re s/@FONT_DATE_SIZE/8/g \
    -re s/@FONT_DESKTOP_SIZE/9/g \
    -re s/@V_CLOCK/122/g \
    -re s/@VDELTA/38/g \
    -re s/@VDDELTA/28/g \
    -re s/@VDDDELTA/28/g \
    -re s/@H_TOP/110/g \
    -re s/@VMINILINE/10/g \
    -re s/@WLAN/wlp4s0/g \
    > generated/rocinante.conkyrc
fi

make_dunst ()
{
  ## example for yggdrasill:
  ## xmonad border = 20 + 20 = 40. (between conky and first window)
  ## conky's gap_x = 40. (between screen and conky)

  host=$1
  conky_width=$2
  border=$3
  font_size=$4

  half_border=$(( border / 2 ))
  quarter_border=$(( border / 4 ))
  total_conk=$(( border * 2 + conky_width ))
  dunst_width=$(( total_conk - border ))
  echo "xmonad for $host: (Border $half_border $half_border $half_border $half_border)"

  sed dunstrc \
    -re s/@GEOM/${dunst_width}x0+${half_border}+${half_border}/g \
    -re s/@SEP/${half_border}/g \
    -re s/@PAD/${quarter_border}/g \
    -re s/@FONT_SIZE/${font_size}/g \
    > generated/$host.dunstrc
}

if [ ! -z $generate_dunst ]; then
  echo dunst!
  make_dunst daban-urnud $d_conky_width $d_border 13
  make_dunst rocinante   $r_conky_width $r_border 13
  make_dunst yggdrasill  $y_conky_width $y_border 20
fi

if [ ! -z $generate_git ]; then
  echo git!
  cp git/gitconfig generated/sign.gitconfig
  sed git/gitconfig -re 's/.*gpg|sign/#\0/' > generated/gitconfig
fi
