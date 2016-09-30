#!/bin/sh
#cp ~root/beng-rely/files/isolinux.cfg /ISO/dvd_7/isolinux/isolinux.cfg
cd /ISO/dvd_7 && mkisofs -o kickstart_lab_7.iso -b isolinux.bin -c boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -R -J -v -T isolinux/
