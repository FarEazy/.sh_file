
#!/bin/bash

# Check if the script is being run as root
if [[ $EUID -ne 0 ]]; then
   echo "Sudo jangan lupa yee..."
   exit 1
fi

# Function to check if a package is already installed
is_package_installed() {
    if dnf list installed "$1" >/dev/null 2>&1; then
        return 0 # Package is installed
    else
        return 1 # Package is not installed
    fi
}

# Function to install Apache web server
install_apache() {
    if ! is_package_installed httpd; then
        echo "Installing Apache web server...sabar tu kan separuh dari iman"
        if dnf install -y httpd; then
            echo "Apache web server installation successful...mantapp"
	    echo "Starting and Enabling Apache"
    sleep 1
            if systemctl start httpd && systemctl enable httpd; then
            echo "Apache WebServer have been start and enable"
        systemctl status httpd
        else
            echo "Apache WebServer failed to start"
            exit 1

        fi
        else
            echo "Failed to install Apache web server.....adoiii"
            exit 1
        fi
    else
        echo "Sudah la tu nak install apa lagi"
   fi
#
#	echo "Starting and Enabling Apache"
#	if systemctl start httpd && systemctl enable httpd; then
#	    echo "Apache WebServer have been start and enable"
#	systemctl status httpd
#	else
#	    echo "Apache WebServ"
#	    exit 1
#
#	fi
}

# Function to install Nginx web server
install_nginx() {
    if ! is_package_installed nginx; then
        echo "Installing Nginx web server...sabajap ehh..tak lama pon"
        if dnf install -y nginx; then
            echo "Nginx web server installation successful....yahoooo"
	      echo "Starting and Enabling Nginx"
    sleep 1
            if systemctl start nginx && systemctl enable nginx; then
            echo "Nginx WebServer have been start and enable"
        systemctl status nginx
        else
            echo "Nginx WebServer failed to start"
            exit 1

        fi
        else
            echo "Failed to install Nginx web server.....adoiii"
            exit 1
        fi
    else
        echo "Sudah la tu nak install apa lagi"
   fi
}

# Function to install Caddy web server
install_caddy() {
    if ! is_package_installed caddy; then
        echo "Installing Caddy web server...sabar yee"
        if dnf install -y caddy; then
            echo "Caddy web server installation successful....Mantap Pak Abu"
          echo "Starting and Enabling Caddy"
    sleep 1
            if systemctl start caddy && systemctl enable caddy; then
            echo "Caddy WebServer have been start and enable"
        systemctl status caddy
        else
            echo "Caddy WebServer failed to start"
            exit 1

        fi
        else
            echo "Failed to install Caddy web server.....adoiii"
            exit 1
        fi
    else
        echo "Sudah la tu nak install apa lagi"
   fi
}

# Function to install MariaDB
install_mariadb() {
    if ! is_package_installed mariadb; then
        echo "Installing mariadb...sabar yee"
        if dnf install -y mariadb-server; then
            echo "Mariadb installation successful....Mantap Pak Abu"
          echo "Starting and Enabling MariaDB"
    sleep 1
            if systemctl start mariadb && systemctl enable mariadb; then
            echo "MariaDB WebServer have been start and enable"
        systemctl status mariadb
        else
            echo "MariaDB failed to start"
            exit 1

        fi
        else
            echo "Failed to install MariaDB.....adoiii"
            exit 1
        fi
    else
        echo "Sudah la tu nak install apa lagi"
   fi
}


# Function to uninstall Apache web server
uninstall_apache() {
    if is_package_installed httpd; then
        echo "Uninstalling Apache web server...sabarjapp"
        if dnf remove -y httpd; then
            echo "Apache web server successfully uninstalled...semua setell"
        else
            echo "Failed to uninstall Apache web server.ada error nii"
            exit 1
        fi
    else
        echo "Bende tak intall kau nak uninstall apa??"
    fi
}

# Function to uninstall Nginx web server
uninstall_nginx() {
    if is_package_installed nginx; then
        echo "Uninstalling Nginx web server...sabarjapp"
        if dnf remove -y nginx; then
            echo "Nginx web server successfully uninstalled...semua sirna setell"
        else
            echo "Failed to uninstall Nginx web server.alamakkkk"
            exit 1
        fi
    else
        echo "Bende tak intall kau nak uninstall apa??"
    fi
}

# Function to uninstall caddy web server
uninstall_caddy() {
    if is_package_installed caddy; then
        echo "Uninstalling caddy web server...sabarjapp"
        if dnf remove -y caddy; then
            echo "Caddy web server successfully uninstalled...semua sirna setell"
        else
            echo "Failed to uninstall caddy web server.alamakkkk"
            exit 1
        fi
    else
        echo "Bende tak intall kau nak uninstall apa??"
    fi
}

# Function to uninstall EPEL repository
uninstall_epel() {
    if is_package_installed epel-release; then
        echo "Uninstalling EPEL repository...sabarjapp"
        if dnf remove -y epel-release; then
            echo "EPEL repository successfully uninstalled...sirnaa selesaii"
        else
            echo "Failed to uninstall EPEL repository...parahh nii"
            exit 1
        fi
    else
        echo "Bende tak intall kau nak uninstall apa??"
    fi
}

# Function to uninstall MariaDB
uninstall_mariadb() {
    if is_package_installed mariadb; then
        echo "Uninstalling MariaDB...sabar yee"
        if dnf remove -y mariadb-server; then
            echo "Mariadb uninstallation successful....Mantap Pak Abu"
        else
            echo "Failed to uninstall Mariadb...adoiii"
            exit 1
        fi
    else
        echo "Sudah la tu nak uninstall apa lagi"
    fi
}

# Function to remove swapfile
remove_swapfile() {

    echo "Input your swapfile name"
    read name

    echo"Remove swapfile"
    if swapoff -v $name; then
      echo"Swapfile successfuly remove"
    else
      echo "Failed to remove swapfile"
      exit 1
    fi
}

# Prompt the user to choose a web server
echo "Nak Pakai Servis apa ye?"
echo "1. Install Apache"
echo "2. Install Nginx"
echo "3. Install Caddy"
echo "4. Install Mariadb"
echo "5. Uninstall Apache"
echo "6. Uninstall Nginx"
echo "7. Unistall Epel Release"
echo "8. Uninstall Caddy"
echo "9. Uninstall Mariadb"
echo "10. Remove SwapFile"
echo "0. Exit"

read -r choice

case $choice in
    1)
        install_apache
        ;;
    2)
        install_nginx
        ;;
    3)
        install_caddy
        ;;
    4)
        install_mariadb
        ;;
    5)
        uninstall_apache
        ;;
    6)
        uninstall_nginx
        ;;
    7)
        uninstall_epel
        ;;
    8)
        uninstall_caddy
        ;;
    9)
        uninstall_mariadb
        ;;
    10)
        remove_swapfile
        ;;
    0)
        echo "Bye kawan!"
        exit 0
        ;;
    *)
        echo "Dah mengarut ni, gerak dulu..."
        exit 1
        ;;
esac


exit 0

