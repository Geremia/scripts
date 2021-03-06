#!/bin/bash
# chroot.sh

# Exit if location not specified
if [ -z "$1" ]; then
	echo "chroot folder not specified"
	exit 1
elif [ "$1" = -h ]; then
	echo "./chroot.sh <chroot-folder>"
	exit 1
fi

location=$1
cd "$location"

# Mounting, basic
sudo mount -t proc proc "$1"/proc || exit 1
sudo mount -o bind /sys "$1"/sys || exit 1
sudo mount -o bind /dev "$1"/dev || exit 1

# Mounting extra partition which is already mounted on host
# first one is host mount path, second is chroot mount 
#sudo mount -B /mnt/datalinux2 "$1"/mnt/data

# For internet access
sudo cp /etc/resolv.conf "$1"/etc/resolv.conf

# Finally, chroot
# Need to ensure correct variables
# http://www.iitk.ac.in/LDP/LDP/lfs/5.0/html/chapter06/chroot.html
sudo chroot "$location" \
	/usr/bin/env -i \
	HOME=/root TERM=$TERM PS1='\u:\w\$ ' \
	PATH=/bin:/usr/bin:/sbin:/usr/sbin \
	/bin/bash --login

# Unmounting after exit from chroot
#sudo umount "$1"/mnt/data
sudo umount "$1"/{proc,sys,dev}/ || exit 1

echo "Done"
