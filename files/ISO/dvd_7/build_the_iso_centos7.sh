#!/bin/sh 
cp /ISO/dvd_7/centos/isolinux/isolinux.cfg /root/beng-rely/files/ks_7/cent_isolinux.cfg 
cd /ISO/dvd_7 && mkisofs -o kickstart_lab_centos7.iso -b isolinux.bin -c boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -R -J -v -T centos/isolinux
