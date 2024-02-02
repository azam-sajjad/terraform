#!/bin/bash

# vgchange -ay # refreshes lvm state
# DEVICE_FS=`blkid -o value -s TYPE ${DEVICE}`
# if [ "`echo -n DEVICE_FS`" -eq "" ]
# then
#     pvcreate ${DEV}
#     vgcreate data ${DEV}
#     lvcreate --name vol -l 100%FREE data
#     mkfs.ext4 /dev/data/vol
# fi
# mkdir -p /data_vol
# echo '/dev/data/vol /data_vol ext4 defaults 0 0' >> /etc/fstab
# mount /data
