#WELLCOME TO REPOSITORY REMOVE HOME DIRECTORY OF TRUNGNC

# Backup /home
mkdir -p /temp
cp -a /home /temp/
# Unmount the /home directory
umount -fl /home
# Remove /home directory in LVM
fileHome=/dev/$(lvs | grep home | awk '{print $2}')/home
fileRoot=/dev/$(lvs | grep root | awk '{print $2}')/root
fizeSize=$(lvs | grep home | awk '{print $4}')
echo y | lvremove $fileHome
lvextend -L+$fizeSize $fileRoot
xfs_growfs $fileRoot
# Copy the /home contents back into the /home directory
cp -a /temp/home /
rm -rf /temp
# Comment line /home from /etc/fstab
linkFstab=$(cat /etc/fstab | grep home)
sed -i "s|$linkFstab|#$linkFstab|g" /etc/fstab
# Sync systemd up with the changes.
dracut --regenerate-all --force
