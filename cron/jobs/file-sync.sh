#!/bin/sh

BACKUP_SOURCE_DRIVE_UUID=""
BACKUP_TARGET_DRIVE_UUID=""

warn () 
{
	echo "WARNING: $@" >&1
}

info () 
{
	echo "$@" >&1
}

error () 
{
	echo "ERROR: $@" >&2
}

if_error ()
{ 
	if [ $1 -ne 0 ]; then
		error $3
		exit $1
	else
		info $2
	fi
} 

info "Searching backup target disk..."
BACKUP_TARGET_DEVICE=$(findfs UUID=${BACKUP_TARGET_DRIVE_UUID})
if_error $? "Device found in ${BACKUP_TARGET_DEVICE}" "Device not found"

BACKUP_TARGET_MOUNT_POINT=$(findmnt -n -S UUID=${BACKUP_TARGET_DRIVE_UUID} -o TARGET) 
if [ -z ${BACKUP_TARGET_MOUNT_POINT} ]; then
	info "Mounting backup drive..."
	# mount -t ntfs-3g UUID=${BACKUP_TARGET_DRIVE_UUID} /media/BACKUP/
	udisksctl mount -b ${BACKUP_TARGET_DEVICE} --filesystem-type ntfs
	if_error $? "Mount success" "Error mounting device"
	sleep 1
fi

info "Getting backup drive mount point..."
BACKUP_TARGET_MOUNT_POINT=$(findmnt -n -S UUID=${BACKUP_TARGET_DRIVE_UUID} -o TARGET)
if_error $? "Backup drive mounted on ${BACKUP_TARGET_MOUNT_POINT}" "Mount point not found"

info "Getting source drive mount point..."
BACKUP_SOURCE_MOUNT_POINT=$(findmnt -n -S UUID=${BACKUP_SOURCE_DRIVE_UUID} -o TARGET)
if_error $? "Source drive mounted on ${BACKUP_SOURCE_MOUNT_POINT}" "Mount point not found"

info "Starting backup \"${BACKUP_SOURCE_MOUNT_POINT}\" to \"${BACKUP_TARGET_MOUNT_POINT}\""

rsync -av --delete --omit-dir-times --no-perms ${BACKUP_SOURCE_MOUNT_POINT}/ ${BACKUP_TARGET_MOUNT_POINT}/ #--dry-run

info "Preparing backup drive for unmount..."
sleep 7

info "Unmounting backup drive..."
# umount UUID=${BACKUP_TARGET_DRIVE_UUID}
udisksctl unmount -b ${BACKUP_TARGET_DEVICE}
if_error $? "Unmount success" "Error unmounting backup drive"
