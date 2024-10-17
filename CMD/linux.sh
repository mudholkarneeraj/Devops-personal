1. sudo apt-get install cron
    systemctl status cron
    crontab -e
    crontab -l
2. glances ==> to measure the network socket
3.  atq   ==> to check running scripts in jenkins
    at -c <job_id>. ==> to check
    atrm 1   ==> to remove

---------------------------------------------------------------------
cut ==> command is used for extracting a portion
ifconfig ==> show network interface
tail -n 3 state.txt or tail -3 state.txt => -n for no. of lines
grep -i ==> Returns the results for case insensitive strings
grep -n ==> Returns the matching strings along with their line number
grep -c ==> Returns the number of lines in which the results matched the search string
cat -n ==> This adds line numbers to all lines
sudo useradd <username> ==> Adding a new user ---or---  sudo adduser <newuser>
sudo passwd <username> ==> Setting a password for the new user
sudo userdel <username> ==> Deleting the user
sudo groupadd <groupname> ==> Adding a new group
sudo groupdel <groupname> ==> Deleting the  group
sudo usermod -g <groupname> <username> ==> Adding a user to a primary group
2. sudo deluser --remove-home user ==> user directory also deleted 
3. du -h -t 100M /  ==> to check file size
4. gdu ==> to check the discspace
sudo growpart /dev/nvme0n1 1 ==> to mount ext4
sudo resize2fs /dev/nvme0n1p1 ==> to mount ext4
sudo resize2fs /dev/nvme0n1p1
sudo xfs_growfs -d
Ss -plant ==> to check port
sudo resize2fs /dev/nvme0n1p1
sudo xfs_growfs -d
sudo xfs_growfs /dev/nvme1n1 
./restart-instance.sh > /dev/null 2>&1 &
grep -r "<text>" /var/lib/text.txt
-------------certboat--------
sudo certbot certonly --manual -d *.dev.myjar.app -d dev.myjar.app --agree-tos --no-bootstrap --manual-public-ip-logging-ok --preferred-challenges dns-01 --server https://acme-v02.api.letsencrypt.org/directory
——————————MAC-RESIZE-----------
MAC instance resize PDISK=$(diskutil list physical external | head -n1 | cut -d" " -f1)
APFSCONT=$(diskutil list physical external | grep "Apple_APFS" | tr -s " " | cut -d" " -f8)
sudo diskutil repairDisk $PDISK

Accept the prompt with "y", then paste this command

sudo diskutil apfs resizeContainer $APFSCONT 0
Since the EBS volume was resized after boot, an instance reboot is required before the additional disk size is available for your use.
———————————————————————————————


