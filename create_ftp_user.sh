root@3ws:~# cat do_not_delete_sftp.sh 
#!/bin/bash

# Check if the script is being run as root
#if [[ $EUID -ne 0 ]]; then
#   echo "This script must be run as root" 
#   exit 1
#fi

# Prompt for username and password
read -p "Enter username for FTP user: " username
read -p "Enter password for FTP user: " password
read -p "Enter upload directory path: e.g : <<< /var/www/nebhub.com/product_images/milltekcorp/ftp_uploads/ >>> : " path

# Create a new system user for FTP
useradd -d /home/chroot/$username -s /usr/sbin/nologin -m -G sftponly $username

# Set the password for the FTP user
echo "$username:$password" | chpasswd

# Set ownership and permissions for the home directory
chown root:root /home/chroot/$username/

# Create a home directory for the FTP user
mkdir -p /home/chroot/$username/ftp_uploads


#mount ftp_user home directory with user's upload directory
mount --bind $path /home/chroot/$username/ftp_uploads/

#add entry in fstab
echo "$path        /home/chroot/$username/ftp_uploads/  none    bind    0       0" >> /etc/fstab

#Set ownership and permissions for the ftp_upload directory
chown $username:sftponly -R $path

echo "FTP user $username created successfully."

echo ":: VERIFICATIONS ::"
id $username
cat /etc/passwd | grep $username
#ls -l $path | grep $username
#removing old files from ftp_uploads directory.
rm -rf $path*


You have new mail in /var/mail/root
root@3ws:~# 
