#! /bin/sh

die () {
  exit 4
}

HOST=$(hostname)
eselect kernel list
curr_kr=$(make kernelrelease)
curr_kv=linux-$(make kernelversion)
latest_kv=$(eselect kernel list | sed -rne '$ s/^.*(linux-[^ ]+).*$/\1/p')
pwd

################################# kernel version:
if [ $latest_kv != $curr_kv ]; then
  echo "$latest_kv != $curr_kv, fucking right off"
  exit 1
fi

eselect kernel set $latest_kv || die # don't do that
eselect kernel list

echo fixme dracut firmware
echo "are you sure? ${curr_kr}?"
read ans


if [[ ! ( "$ans" = "" || "$ans" = yes || "$ans" = y ) ]]; then
  exit 1
fi

################################# firmware:
fm_file=$(ls -1 /var/cache/distfiles/linux-firmware-* | sort | tail -n 1)

# FIXME nostromo!
case $HOST in
  enterprise|rocinante)
    firmware='FIXME'
    ;;
  nostromo)
    firmware='iwlwifi-6000'
    ;;
  daban-urnud)
    firmware='iwlwifi-7265D|i915'
    #echo 'tart $tree/distfiles/linux-firmware-20170622.tar.gz | sed -nre "/(iwlwifi-7265D|i915)/ { s:^.*linux-firmware[^/]*/::g; s/ ->.*//g; p }" | sudo tee $portage/savedconfig/sys-kernel/linux-firmware && emerge -1 linux-firmware'
    ;;
  yggdrasill)
    firmware='i915|ath10k|qca'
    ###echo 'tart $tree/distfiles/linux-firmware-20181026.tar.gz | sed -nre "/(i915|ath10k|qca)/ { s:^.*linux-firmware[^/]*/::g; s/ ->.*//g; p }" | sudo tee $portage/savedconfig/sys-kernel/linux-firmware && emerge -1 linux-firmware'
    ;;
esac
echo you might want to update firmware:
echo $fm_file with ${firmware}?
read ans

if [[ ( "$ans" = "" || "$ans" = yes || "$ans" = y ) ]]; then
  saved_config=/etc/portage/savedconfig/sys-kernel/linux-firmware
  tar -tavf $fm_file                                                            \
    | sed -nre "/($firmware)/ { s:^.*linux-firmware[^/]*/::g; s/ ->.*//g; p }"  \
    | tee $saved_config                                           || die
  chown portage:portage $saved_config
  emerge -1 linux-firmware                                        || die
fi

################################# save config:
cp .config /home/wjc/conf/private/kernel/$HOST/config-$curr_kr     || die
chown wjc:wjc /home/wjc/conf/private/kernel/$HOST/config-$curr_kr  || die

mount /boot
#chmod og+rX -R /usr/src/linux
chown -RL portage:portage /usr/src/linux
make modules_install                                              || die
make install                                                      || die

# FIXME/TODO:
# add hostname config for jobs & module rebuild, firmware.

#emerge @module-rebuild                                            || die
#genkernel --install --no-ramdisk-modules --firmware initramfs
#genkernel --install --firmware initramfs
dracut -a crypt -a resume --hostonly '' $curr_kr                  || die
grub-mkconfig -o /boot/grub/grub.cfg                              || die
