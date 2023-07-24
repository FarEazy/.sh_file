#!/bin/bash

# Check if the script is being run as root
if [[ $EUID -ne 0 ]]; then
   echo "Hey Hey sudoo tuu jngan lupaa"
   exit 1
fi

# Function to update the system using dnf
update_system() {
    echo "Sabarjap update ni lama sikit"
    if dnf update -y; then
        echo "Mantap..selesai update sudah."
    else
        echo "Failed to update the system."
        exit 1
    fi
}

# Function to disable root login in SSH configuration
disable_root_login() {
    local ssh_config="/etc/ssh/sshd_config"

    # Check if the SSH configuration file exists
    if [ ! -f "$ssh_config" ]; then
        echo "SSH configuration file ($ssh_config) not found. Exiting..."
        exit 1
    fi

    # Backup the original sshd_config file
    cp "$ssh_config" "$ssh_config.bak"

    # Disable direct root login by modifying the sshd_config file
    if sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' "$ssh_config"; then
        echo "Root login disabled in SSH configuration."
    else
        echo "Failed to disable root login in SSH configuration."
        exit 1
    fi

    # Restart the SSH service to apply the changes
    if systemctl restart sshd; then
        echo "SSH service restarted successfully."
    else
        echo "Failed to restart SSH service. Please restart it manually to apply changes."
    fi
}

# Function to install the EPEL repository
install_epel() {
    if ! dnf list installed epel-release >/dev/null 2>&1; then
        echo "Installing EPEL repository..."
        if dnf install -y epel-release; then
            echo "EPEL repository installation successful.yahoo"
        else
            echo "Failed to install EPEL repository.Gagalll"
            exit 1
        fi
    else
        echo "EPEL repository is already installed...mantap pak abu krincaf"
    fi
}

# Function to create a 4GB swap file
create_swap_file() {
    local swap_file="/swapfile"
    local swap_size="4G"

    # Check if a swap file already exists
    if [ -f "$swap_file" ]; then
        echo "Swap file ($swap_file) already exists. Exiting..."
        exit 1
    fi

    echo "Creating a 4GB swap file..."
    if fallocate -l "$swap_size" "$swap_file" && chmod 600 "$swap_file"; then
        mkswap "$swap_file"
        swapon "$swap_file"
        echo "Swap file creation successful."
    else
        echo "Failed to create the swap file."
        exit 1
    fi
}

# Function to isntall htop the system using dnf
install_htop() {
    echo "Sabarjap install htop tak lama pon"
    if dnf install htop -y; then
        echo "Mantap..selesai install sudah."
    else
        echo "Failed to update the system...sakitnya hati ini suiii"
        exit 1
    fi
}

# Function to install Fail2Ban
install_fail2ban() {
    echo "Installing Fail2Ban..."
    if dnf install -y fail2ban; then
        echo "Fail2Ban installation successful."
    else
        echo "Failed to install Fail2Ban."
        exit 1
    fi
}

# Function to configure Fail2Ban
configure_fail2ban() {
    local config_file="/etc/fail2ban/jail.local"

    echo "Configuring Fail2Ban..."
    cat <<EOL > "$config_file"
[DEFAULT]
maxretry = 5
bantime = 1d

[sshd]
enabled = true
EOL

    echo "Fail2Ban configuration completed."

}

# Run system update and install EPEL repository
update_system
disable_root_login
install_epel
create_swap_file
install_htop
install_fail2ban
configure_fail2ban
exit 0
