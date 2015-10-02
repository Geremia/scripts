# post installation tasks

post_install () {
	# Copying gparted.desktop
	install -Dm 755 /usr/share/applications/gparted.desktop "$WORKDIR/$PROFILE/$ARCH/livecd-image/home/manjaro/Desktop/gparted.desktop" || exit 1
	sed 's|/usr/bin/gparted_polkit %f|gksudo gparted|g' -i "$WORKDIR/$PROFILE/$ARCH/livecd-image/home/manjaro/Desktop/gparted.desktop" || exit 1
	echo "GParted.desktop copied to livecd image."

	# Copying cli-installer.desktop and beginner's guide
	cp -p /home/aaditya/iso/installer-launcher-cli.desktop "$WORKDIR/$PROFILE/$ARCH/livecd-image/home/manjaro/Desktop/"
	cp -p /home/aaditya/iso/Beginner_User_Guide.pdf "$WORKDIR/$PROFILE/$ARCH/livecd-image/home/manjaro/Desktop/"
	echo "cli-installer.desktop and Beginner_User_Guide.desktop copied to livecd."

	# Disabling automatic swap partition mounting in livecd
	sed 's|swapon ${swapdev}|#swapon ${swapdev}|' -i "$WORKDIR/$PROFILE/$ARCH/livecd-image/opt/livecd/util-livecd.sh" || exit 1
	echo "Automatic swap partition commented out."

	# Copying modified setup
	cp /mnt/datalinux/git/manjaro-tools-livecd/livecd-cli-installer/opt/livecd/setup-0.9 "$WORKDIR/$PROFILE/$ARCH/livecd-image/opt/livecd/setup-0.9" || exit 1
	echo "Copied modified setup."

	# Changing log location in setup
	sed 's|LOG="/dev/tty8"|LOG="/var/log/setup.log"|' -i "$WORKDIR/$PROFILE/$ARCH/livecd-image/opt/livecd/setup-0.9" || exit 1
	echo "Log location in setup changed."

	# Revert Packages file
	sed '/## ucode for new cpus/ a\
intel-ucode' -i "${PROFILEDIR}/shared/Packages" || exit 1
	echo "shared/Packages reverted."

	# Reverting pacman.conf for live system
	sed '/XferCommand = \/usr\/bin\/wget -Nc -q --show-progress --passive-ftp -O %o %u/ d' -i "${PROFILEDIR}/${PROFILE}/pacman-default.conf" -i "${PROFILEDIR}/${PROFILE}/pacman-multilib.conf" || exit 1
	echo "pacman.conf reverted for live."
}