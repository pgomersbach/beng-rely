#!/bin/sh
cp ~root/beng-rely/files/isolinux.cfg /ISO/dvd/isolinux/isolinux.cfg
cd /ISO/dvd && mkisofs -o kickstart_lab.iso -b isolinux.bin -c boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -R -J -v -T isolinux/
