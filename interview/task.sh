#!/bin/bash
LOG_FILE="/path/to/your/logfile.log"
OUTPUT_FILE="extracted_ips.txt"
grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' "$LOG_FILE" | sort | uniq > "$OUTPUT_FILE"
echo "IP addresses have been extracted to $OUTPUT_FILE"
--------or-------------
grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' logs.txt
!bin/bash/
grep -oE "([0-9]{1,3}\.){3}[0-9]{1,3}" logs.txt #==> getting IP's from logs
grep -oE "([0-9]{1,3}\.){3}[0-9]{1,3}" logs.txt | sort | uniq -c  #==> unique IP count
grep -oE "([0-9]{1,3}\.){3}[0-9]{1,3}" logs.txt | sort | uniq    #==> unique IP's
grep " 200 " logs.txt | grep -oE "([0-9]{1,3}\.){3}[0-9]{1,3}" | sort | uniq  #==> Extract Unique IPs from Lines with "200":
grep " 200 " logs.txt | grep -oE "([0-9]{1,3}\.){3}[0-9]{1,3}" | sort | uniq | wc -l  #==> Count Unique IPs with 200 Responses:
---------------------------
Write a script to check if a process is running and restart it if it’s not.
#!/bin/bash

PROCESS_NAME="nginx"
if ! pgrep -x "$PROCESS_NAME" > /dev/null; then
    echo "$PROCESS_NAME is not running. Starting it now..."
    systemctl start "$PROCESS_NAME"
else
    echo "$PROCESS_NAME is running."
fi

----------------------------
How would you write a script that compresses log files older than 7 days?
#!/bin/bash

find /var/log/myapp -name "*.log" -mtime +7 -exec gzip {} +

gzip -d <filename>  ==> to unzip file
-----------------------------
 How do you extract the IP addresses from a log file and count unique occurrences?
#!/bin/bash

LOG_FILE="access.log"
grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' "$LOG_FILE" | sort | uniq -c | sort -nr

-------------------------------
Write a script to swap the contents of two files.
#!/bin/bash

FILE1="file1.txt"
FILE2="file2.txt"

temp=$(mktemp)
mv "$FILE1" "$temp"
mv "$FILE2" "$FILE1"
mv "$temp" "$FILE2"
-------------------------------
#!/bin/bash

# Read input
echo "Enter a number between 1 and 3:"
read number

# Switch case logic
case $number in
  1)
    echo "You selected option 1"
    ;;
  2)
    echo "You selected option 2"
    ;;
  3)
    echo "You selected option 3"
    ;;
  *)
    echo "Invalid option"
    ;;
esac
----------------------------
How can you delete all empty files in a directory recursively?
find /path/to/directory -type f -empty -delete

----------------------------
How do you replace all occurrences of a string in multiple files within a directory?
#!/bin/bash

DIRECTORY="/path/to/directory"
OLD_STRING="old_text"
NEW_STRING="new_text"

find "$DIRECTORY" -type f -name "*.txt" -exec sed -i "s/$OLD_STRING/$NEW_STRING/g" {} \;
------------------------------
 How do you extract the last N lines from a log file every minute using a cron job?
 #!/bin/bash

LOG_FILE="/var/log/mylog.log"
OUTPUT_FILE="/path/to/extracted_logs.txt"
N=10

tail -n "$N" "$LOG_FILE" >> "$OUTPUT_FILE"

* * * * * /path/to/extract_logs.sh

------------------------

a=5.5
b=10.2
sum=$(echo "$a + $b" | bc)
echo "The sum is: $sum"
--------------------------
a=1
b=3
sum=$((a + b))
echo "the sum: $sum"
---------------------------------
Check if a Given String is a Palindrome

read -p "Enter a string: " str
reversed=$(echo "$str" | rev)

if [ "$str" == "$reversed" ]; then
  echo "The string is a palindrome."
else
  echo "The string is not a palindrome."
fi
-----------------------------------
Count Files in a Directory Including Subdirectories
read -p "Enter directory path: " dir
file_count=$(find "$dir" -type f | wc -l)
echo "Total files: $file_count"

List Top 5 Processes by Memory Usage
#!/bin/bash
echo "Top 5 processes by memory usage:"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6

Ping a List of Servers and Report if Any are Down
#!/bin/bash
servers=("server1.example.com" "server2.example.com" "server3.example.com")

for server in "${servers[@]}"; do
  if ping -c 1 "$server" &> /dev/null; then
    echo "$server is up"
  else
    echo "$server is down"
  fi
done
--------------------------------------
servers=("dev.myjar.app" "uat.myjar.app" "prod.myjar.app")
for server in "${servers[@]}"
do
if ping -c 1 "$server" &> /dev/null/; then
echo "server is up $server"
else
echo "server is down $server"
fi
done
--------------------------
how to check file exists or not
if [ -e namespace.yaml ]; then
echo "file exist"
else
echo "file doesnit exists"
fi
--------------------------
you can use to save output of a file "ls /nonexistance &> error.txt"
-------------------------
cronetab -e
-----------------------
sed -i 's/old/new/g' filename
-------------------------
read -p "can you tell me your name: " name
echo "myname is $name"
------------------------
to check the last execute command status
ls
if [ $? -eq 0 ]; then
echo "success"
else
echo "failed"
fi
------------------------
how to execute the function
my_function () {
    echo "this is a function"
}
my_function
-------------------------
echo "this is my data" > output.txt #this will delete privious data and it will write
--------------------------
set -e # used to exit the shell script if there is an error in script
--------------------------
while IFS=, read -r colume1 colume2 colume3
do
echo "colume1: $colume1, colume2: $colume2, colume3: $colume3"
done < practice.csv

#file  practice.csv
1,2,3
one,two,three
-------------------------
bash -x script.sh   # to debug entire script
------------------------
array in shell scripting
my_array=(element1 element2 element3)

echo ${array[0]}

echo ${array[@]}
for element in "${my_array[@]}"
do
echo $element
done
-----------------------------
result=$(expr 3 + 4)
echo $result

result=$(( 3 + 9))
echo $result
---------------------------
cmd="ls -al"
eval $cmd
----------------------------
THRESHOLD=80
EMAIL="neeraj.kumar#changejar.in"

DISKUSAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g' )
if [ "$DISKUSAGE" -gt "$THRESHOLD"]; then
echo "" $THRESHOLD | mail -s $EMAIL
fi
--------------
Servers=("192.2.3.2" "192.2.2.2" "192.5.5.5")
for server in "${Servers[@]}"
  do
     ssh ubuntu@$server << EOF
      apt update
      apt upgrade -y
      apt install nginx -y 
EOF
    echo "nginx installed and started the server"
done
--------------
---
- name: install nginx in server
  hosts: all
  become: true
  tasks:
    - name: install the nginx
      apt:
        name: nginx
        state: present
    - name: status
      service:
        name: nginx
        state: started
        enabled: true
-------------------
find / -type f -size +100M
