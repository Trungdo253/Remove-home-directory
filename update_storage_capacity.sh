echo 1 >/sys/class/scsi_device/0\:0\:0\:0/device/rescan
parted -l
fix
fix
diskSize=$(parted -l /dev/sda | grep 'Disk /dev/sda:' | awk '{printf $3}')
parted /dev/sda resizepart 3 $diskSize
pvresize /dev/sda3
lvresize /dev/mapper/centos-root /dev/sda3
xfs_growfs /dev/centos/root