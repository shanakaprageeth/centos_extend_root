#!/bin/bash -e
# author Shanaka
# require root access to run this script
# tested only in centos
# use following to set other user automatically
#OTHER_USER="$(whoami)"
OTHER_USER="YOURNAME"

# system dev name
SYS_NAME="centos"

# hard disk size to shrink use 3G in case of swap
NEW_SHINKED_SZ="400G"

#select drive to extend "swap" or "home"
RM_AND_CR_MOUNT="home"

# show system drive details
lsblk

printf "ARE YOU SURE TO CONTINUE THIS PROCESS?[y/n]:"
read $INPUT
if [$INPUT!="y"] ; then
	exit
fi

# store home directory
tar -czvf /root/home.tgz -C /home .

# unmount and create a new partitions
# if home
if [$RM_AND_CR_MOUNT == "home"]; then
	umount -fl "/dev/mapper/${SYS_NAME}-home"
	lvremove "/dev/mapper/${SYS_NAME}-home"
	lvcreate -L $NEW_SHINKED_SZ -n home $SYS_NAME
	mkfs.xfs "/dev/${SYS_NAME}/home"
	mount "/dev/mapper/${SYS_NAME}-home"
fi

#if swap
if [$RM_AND_CR_MOUNT == "swap"]; then
	swapoff -v /dev/${SYS_NAME}/swap
	lvreduce "/dev/${SYS_NAME}/swap -L -${NEW_SHINKED_SZ}"
	mkswap /dev/${SYS_NAME}/swap
	swapon-va
fi

# extend size of logical volume
lvextend -r -l +100%FREE "/dev/mapper/${SYS_NAME}-root"
if [$RM_AND_CR_MOUNT == "home"]; then
	tar -xzvf /root/home.tgz -C /home
fi

# increase size of xfs file system
xfs_growfs "/dev/${SYS_NAME}/root"
