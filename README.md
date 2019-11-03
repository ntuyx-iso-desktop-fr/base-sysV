## NuTyX-Systemd, please following these commands to install the base

## on a normal Nutyx in root

`cards install cards.devel git`

`wget https://raw.githubusercontent.com/YaoLinux/base-sysd/master/scripts/install-nutyx.in -O install-nutyx `

## You can continue
`chmod -v 755 install-nutyx` \
`mv -v install-nutyx /usr/bin/install-nutyx`

## If you've already make the installation process, you have to remove the LFS user from the nutyx base by
`userdel lfs` \
`rm -r /home/lfs` \
`rm -r /mnt/lfs` \
`groupdel lfs`

## After that or if you didn't make an installation process, you have to run these following commands
`export LFS=/mnt/lfs` \
`mkdir -pv $LFS`

## Please note that you have to choose your partition in the next command, here /dev/sdb2
`mount /dev/sdb2 $LFS`

## It's time to begin pass1
## make sure the LFS variable is set by
`echo $LFS` 

## If nothing is in the output, make
`export LFS=/mnt/lfs`

## Now, create the directories
`mkdir -vp $LFS/{sources,tools}` \
`ln -svf $LFS/tools /` \
`ln -svf $LFS/sources /`

## Create the LFS user
`groupadd lfs` \
`useradd -s /bin/bash -g lfs -m -k /dev/null lfs` \
`passwd lfs` \
`chown -v lfs $LFS/{tools,sources}` \
`chmod -v a+wt $LFS/sources` \
`chown -v lfs $LFS`

## Now go in the LFS user

`su - lfs`

## Set the LFS variable in LFS User

`export LFS=/mnt/lfs`

## Set the correct profile for LFS User
`cat > /home/lfs/.bash_profile << "EOF"` \
`exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash` \
`EOF` \
`echo "set +h` \
`umask 022` \
`LFS=$LFS` \
`LC_ALL=POSIX` \
`LFS_TARGET=$(uname -m)-lfs-linux-gnu` \
`PATH=/home/lfs/bin:/tools/bin:/bin:/usr/bin` \
`export LFS LC_ALL LFS_TARGET PATH" > /home/lfs/.bashrc`



## You are in the LFS user, now continue the installation with
`git clone https://github.com/rems28/base-systemd.git development` \
`cd development` \
`scripts/runmebeforepass1` 

## Normally, all will be good with the message above
"====> Successfull configured"

## Do the first pass
`cd chroot` \
`pass`

## All will be ok with the message after a long time, which depends of your machine
"=======> Building '/home/lfs/development/chroot/cards/Pkgfile' succeeded. \
/home/lfs/development/chroot"

## Go to pass2 :

## The rest of installation will be done in root
`exit`

## check the LFS variable
`echo $LFS`

## will return 
"/mnt/lfs"

## if the result is correct continue with
`chown -R root:root $LFS` \
`install -dv -m0750  $LFS/root` \
`ln -sv development/scripts $LFS/root/bin` \
`mv /home/lfs/development $LFS/root/` \
`cd $LFS/root/development/base/yaolinux`

## make the first package
`/tools/bin/pkgmk -cf ../../../bin/pkgmk.conf.passes`

## install it
`/tools/bin/pkgadd -r $LFS yaolinux1*` \
`/tools/bin/pkgadd -r $LFS yaolinux.man1*`

## check if it's present
`/tools/bin/pkginfo -r $LFS -i`

## It's have to return 
"(base) yaolinux 1.0-RC1-1... \
(base) nutyx.man 1.0-RC1-1..."

## make the configuration
`VERSION="development" install-nutyx -ic`

## We mount the folders 
`mount -v --bind /dev $LFS/dev` \
`mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620` \
`mount -vt proc proc $LFS/proc` \
`mount -vt sysfs sysfs $LFS/sys` \
`mount -vt tmpfs tmpfs $LFS/run` \
`if [ -h /dev/shm ]; then mkdir -pv $LFS/$(readlink $LFS/dev/shm);fi` \
`chmod 1777 /dev/shm` \
`cp -v /etc/resolv.conf $LFS/etc`

## We check the correct mount
`mount|grep $LFS`

## will normally return if it's on /dev/sda2
"/dev/sda2 on /mnt/lfs type ext4 (rw) \
/devtmpfs on /mnt/lfs/dev type devtmpfs (rw,nosuid,relatime,size=16300988k,nr_inodes=4075247,mode=755) \
devpts on /mnt/lfs/dev/pts type devpts (rw,relatime,gid=5,mode=620,ptmxmode=000) \
proc on /mnt/lfs/proc type proc (rw,relatime) \
sysfs on /mnt/lfs/sys type sysfs (rw,relatime) \
tmpfs on /mnt/lfs/run type tmpfs (rw,relatime)"

## continue in chroot
`chroot "$LFS" /usr/bin/env -i HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \` \
`/bin/bash --login +h`

## Some "command not found" will appears, but not important here

## continue with
`export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin:/root/bin` \
`cd /root/development/base` \
`pass`

## After a moment the scripts says you have to install bash manually, go with the commands
`exit` \
`cd $LFS/root/development/base/bash` \
`for PACK in *.xz; do /tools/bin/pkgadd -r $LFS $PACK;done` \
`/tools/bin/pkginfo -r $LFS -i|grep bash`

## The last command will return that if succeeds
"(base) bash 4.4-1 \
(base) bash.da 4.4-1 \
(base) bash.de 4.4-1 \
(base) bash.devel 4.4-1 \
(base) bash.doc 4.4-1 \
..."

## return in chroot
`chroot "$LFS" /usr/bin/env -i HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \` \
`/bin/bash --login +h` \
`export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin:/root/bin` \
`cd /root/development/base` \
`pass`

## The last pass will return at end
"ADD: ca-certificates-20150725, 1282 files: 100% \
=======> Installing 'ca-certificates1418739487x86_64.cards.tar' succeeded. \
=======> compress ca-certificates1418739487x86_64.cards.tar" 

## Now, follow few commands to configure your nutyx-systemd
`exit` \
`echo $LFS`

## The ouptput have to be "/mnt/lfs "

## Go back in chroot
`chroot $LFS /usr/bin/env -i HOME=/root TERM="$TERM" PS1='\u: \w\$' \` \
`/bin/bash --login`

## No "command not found" have to appears here

something will coming

## To boot, you have to compile the kernel with 
cd /usr/ports/base/base/kernel-lts \
pkgmk -d -i

## make a grub, if you don't have a working linux on an other partition or harddrive, with 
cards depcreate grub \
grub-install /dev/sda \
cat > /boot/grub/grub.cfg << "EOF" \
#Begin /boot/grub/grub.cfg \
set default=0 \
set timeout=5 \
insmod ext2 \
set root=(hd0,2) \
menuentry "GNU/Linux, NuTyX-systemd" { \
        linux   /boot/kernel root=/dev/sda2 ro \
} \
EOF

## make a /etc/hostname
echo "nutyx-systemd" > /etc/hostname

## make a /etc/hosts like that if you have a network with DHCP
cat > /etc/hosts << "EOF" \
#Begin /etc/hosts \
\
127.0.0.1 localhost \
127.0.1.1 nutyx-systemd.home nutyx-systemd \
::1       localhost ip6-localhost ip6-loopback \
ff02::1   ip6-allnodes \
ff02::2   ip6-allrouters \
\
#End /etc/hosts \
EOF
  
## make a working network with dhcpcd
cards depcreate dhcpcd

## after compiling dhcpcd, you have to enable a systemd service. you have to know your network interface with
ip a \
systemctl enable dhcpcd@"your network interface"

## make a text editor
cards depcreate vim

## make a link for /etc/resolv.conf
ln -sfv /run/systemd/resolve/resolv.conf /etc/resolv.conf

## make a fstab like that if you have your partition in /dev/sda2
cat > /etc/fstab << "EOF" \
#Begin /etc/fstab \
\
#file system  mount-point  type     options             dump  fsck order \
\
/dev/sda2     /            ext4    defaults            1     1 \
#/dev/<yyy>     swap         swap     pri=1               0     0 \
\
#End /etc/fstab \
EOF 

## make a file for time
cat > /etc/adjtime << "EOF" \
0.0 0 0.0 \
0 \
LOCAL \
EOF

## make a /etc/vconsole.conf like that il you're french
cat > /etc/vconsole.conf << "EOF" \
KEYMAP=fr-latin9 \
FONT=Lat2-Terminus16 \
EOF 

## make a /etc/locale.conf for example in french
cat > /etc/locale.conf << "EOF" \
LANG=fr_FR.utf8 \
EOF

## make a /etc/os-release
cat > /etc/os-release << "EOF" \
NAME="Linux From Scratch" \
VERSION="nutyx-systemd" \
ID=lfs \
PRETTY_NAME="nutyx-systemd" \
VERSION_CODENAME="<your name here>" \
EOF 

## Have a password on root
passwd

## make a new unprivileged user
nu

## Umount all the filesystems
To known what to umount \
mount | grep $LFS \
and \
unmount the filesystems \
```umount /mnt/lfs/{run,proc,sys,dev/pts,dev,}```

## After that you will normally have to reboot on your new NuTyX-systemd and enjoy to start a build-collection
