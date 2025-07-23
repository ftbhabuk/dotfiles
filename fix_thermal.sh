#!/bin/bash

# This script configures thermal management for Intel 12th Gen laptops
# to mitigate freezing and read-only filesystem issues due to high temperatures.

# --- 1. Install Essential Thermal Tools ---
echo "Installing essential thermal management packages..."
sudo pacman -S --noconfirm dmidecode thermald tlp lm_sensors stress || { echo "Error installing packages. Exiting."; exit 1; }
echo "Packages installed."

# --- 2. Enable Thermal Daemons ---
echo "Enabling and starting thermald and tlp services..."
sudo systemctl enable --now thermald || { echo "Error enabling thermald. Exiting."; exit 1; }
sudo systemctl enable --now tlp || { echo "Error enabling tlp. Exiting."; exit 1; }
echo "Services enabled."

# --- 3. Detect Sensors (if not done) ---
echo "Detecting system sensors (answer 'yes' to prompts)..."
sudo sensors-detect --auto # Use --auto to automate 'yes' responses, or remove if you prefer manual prompts
echo "Sensor detection complete."

# --- 4. Update Kernel Parameters in systemd-boot Entries ---
echo "Updating kernel boot parameters for thermal management..."
BOOT_ENTRIES_DIR="/boot/loader/entries"
KERNEL_PARAMS="thermal.off=0 processor.max_cstate=1 intel_pstate=active"

# Find all relevant kernel boot entries
BOOT_FILES=$(find "$BOOT_ENTRIES_DIR" -type f -name "*linux.conf" -o -name "*linux-fallback.conf")

if [ -z "$BOOT_FILES" ]; then
    echo "No systemd-boot entries found. Cannot update kernel parameters."
    exit 1
fi

for BOOT_FILE in $BOOT_FILES; do
    echo "Processing $BOOT_FILE..."
    # Check if the parameters already exist to prevent duplication
    if grep -q "$KERNEL_PARAMS" "$BOOT_FILE"; then
        echo "Parameters already present in $BOOT_FILE. Skipping."
    else
        # Use sed to add the parameters to the 'options' line
        # This regex looks for a line starting with 'options ' and appends the parameters.
        sudo sed -i "/^options / s/$/ $KERNEL_PARAMS/" "$BOOT_FILE"
        echo "Added parameters to $BOOT_FILE."
    fi
done

echo "Kernel parameter update complete."
echo "Configuration applied. A system reboot is recommended for full effect."
echo "You can check current temperatures with 'watch -n 1 sensors' after rebooting."