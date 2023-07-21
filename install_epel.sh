#!/bin/bash

# Check if the script is being run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. Exiting..."
   exit 1
fi

# Function to check if the EPEL repository is already installed
is_epel_installed() {
    if yum repolist | grep -q 'epel'; then
        return 0 # EPEL repository is installed
    else
        return 1 # EPEL repository is not installed
    fi
}

# Install EPEL repository if it's not already installed
if ! is_epel_installed; then
    echo "Installing EPEL repository..."
    if yum install -y epel-release; then
        echo "EPEL repository installation successful."
    else
        echo "Failed to install EPEL repository."
        exit 1
    fi
else
    echo "EPEL repository is already installed."
fi

exit 0
