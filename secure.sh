read -p "Does the server have MySQL installed? " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    mysql_secure_installation
    echo "Disabling MySQL remote access."
    echo "bind-address=127.0.0.1" > /etc/my.cnf
    echo "Restarting MySQL."
    service mysql restart
fi
echo "Check the sudoers file for invalid configurations."
sudo visudo
echo "Check the Groups file for invalid groups/users."
nano /etc/group
echo "Check users file for invalid users."
nano /etc/passwd

echo "Check the apache directory for backdoors. Open EVERY file if appicable. Look for anything that's suspicious."
nautilus /var/www

echo "Disabling guest login."
echo "allow-guest=false" > /etc/lightdm/lightdm.conf
echo "Restarting lightdm."
sudo restart lightdm

read -p "Do you want to disable root login via SSH?" -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	echo "PermitRootLogin no" > /etc/ssh/sshd_config
	echo "Done. Restarting SSH."
	sudo /etc/init.d/sshd restart
fi

read -p "Do you want to enable automatic updates?" -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	sudo dpkg-reconfigure unattended-upgrades
	echo "Done."
fi

read -p "Do you want to lock the root account? Note: You can still use sudo." -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	sudo passwd -l root
	echo "Done."
fi

echo "Updating the Installation."
sudo apt-get update
sudo apt-get upgrade

read -p "Do you want to restart the computer to finish updating?" -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	sudo reboot
fi