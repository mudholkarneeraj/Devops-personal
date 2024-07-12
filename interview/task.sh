#!/bin/bash

# Define the log file
LOG_FILE="/path/to/your/logfile.log"

# Extract IP addresses and save them to a file
grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' "$LOG_FILE" > extracted_ips.txt

echo "IP addresses have been extracted to extracted_ips.txt"
