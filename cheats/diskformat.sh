#!/bin/bash 

# Simple tool to optimally format drive for Entropy Linux installation
# Creates 512mb for booloader, 10GB for swap, and remaining space is split 30%/70% between root and home partitions

clear
figlet WARNING!
echo "This script will format entire drive to a optimal format for Entropy Linux installation"
echo ""
echo "- 512MB FAT32 ESP"
echo "- 10GB linux-swap SWAP"
echo "- 30% ext4 ROOT"
echo "- 70% ext4 HOME"
echo ""
sleep 3

# Function to display error and exit
error_exit() {
    echo "Error: $1"
    exit 1
}

# Ensure the script is run with sudo
if [[ $EUID -ne 0 ]]; then
    error_exit "This script must be run as root. Please use sudo."
fi

# List available drives
echo "Available drives:"
lsblk -dpno NAME,SIZE | grep -E "/dev/sd|nvme|vd"

# Ask user to select a drive
echo
read -p "Select the drive to format (e.g., /dev/sdX): " DRIVE

# Validate the drive exists
if [[ ! -b "$DRIVE" ]]; then
    error_exit "Invalid drive selected."
fi

# Confirm the operation
read -p "Are you sure you want to erase all data on $DRIVE? (yes/no): " CONFIRM
if [[ "$CONFIRM" != "yes" ]]; then
    echo "Operation cancelled."
    exit 0
fi

# Begin partitioning
echo "Erasing and partitioning $DRIVE..."

# Create a new partition table
parted -s "$DRIVE" mklabel msdos || error_exit "Failed to create partition table."

# Create ESP partition
parted -s "$DRIVE" mkpart primary fat32 1MiB 513MiB || error_exit "Failed to create ESP partition."
parted -s "$DRIVE" set 1 boot on || error_exit "Failed to set boot flag on ESP."
mkfs.fat -F32 -n ESP "${DRIVE}1" || error_exit "Failed to format ESP partition."

# Create SWAP partition
parted -s "$DRIVE" mkpart primary linux-swap 513MiB 10.5GiB || error_exit "Failed to create SWAP partition."
mkswap -L SWAP "${DRIVE}2" || error_exit "Failed to format SWAP partition."

# Calculate drive size and partitions
DRIVE_SIZE=$(lsblk -bnd -o SIZE "$DRIVE") # Size in bytes
REMAINING_SIZE=$((DRIVE_SIZE - 10 * 1024 * 1024 * 1024)) # Exclude first 10GB
ROOT_SIZE=$((REMAINING_SIZE / 10 * 3)) # 30% of remaining
ROOT_SIZE=$((ROOT_SIZE > 200 * 1024 * 1024 * 1024 ? 200 * 1024 * 1024 * 1024 : ROOT_SIZE)) # Max 200GB
HOME_SIZE=$((REMAINING_SIZE - ROOT_SIZE)) # 70% of remaining

ROOT_END=$((10 * 1024 + ROOT_SIZE / 1024 / 1024))MiB
HOME_END=$((10 * 1024 + REMAINING_SIZE / 1024 / 1024))MiB

# Create root partition
parted -s "$DRIVE" mkpart primary ext4 10.5GiB "$ROOT_END" || error_exit "Failed to create root partition."
mkfs.ext4 -L ROOT "${DRIVE}3" || error_exit "Failed to format root partition."

# Create home partition
parted -s "$DRIVE" mkpart primary ext4 "$ROOT_END" 100% || error_exit "Failed to create home partition."
mkfs.ext4 -L HOME "${DRIVE}4" || error_exit "Failed to format home partition."

echo "Partitioning complete. The drive is now ready with the following layout:"
lsblk "$DRIVE"
