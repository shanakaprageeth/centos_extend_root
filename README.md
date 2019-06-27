# centos_shrink_root

## Description
This script allows you to resize root or swap partition on a cent OS device. You could try it other Linux hosts with  lvm partitioning.

Execute centos_change_root_part.sh under administrative privilages.
Edit following accordiing to your system
```
#OTHER_USER="$(whoami)"
OTHER_USER="YOURNAME"

# system dev name
SYS_NAME="centos"

# hard disk size to shrink use 3G in case of swap
NEW_SHINKED_SZ="400G"

#select drive to extend "swap" or "home"
RM_AND_CR_MOUNT="home"
```
