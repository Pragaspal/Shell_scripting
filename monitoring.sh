#!/bin/bash

# Define the email settings
TO="your_email@example.com"
SUBJECT="New Listening Port Detected"
FROM="your_server@example.com"

# Log file to keep track of existing ports
LOG_FILE="/path/to/port_monitor.log"

# Function to send an email
send_email() {
  local message="$1"
  echo "$message" | mail -s "$SUBJECT" -r "$FROM" "$TO"
}

# Check if the log file exists; if not, create it
if [ ! -e "$LOG_FILE" ]; then
  touch "$LOG_FILE"
fi

# Get the list of currently listening ports
netstat -tuln | awk '$1 == "tcp" {print $4}' | cut -d: -f2 | sort -u > "$LOG_FILE"

# Check for new ports
while true; do
  netstat -tuln | awk '$1 == "tcp" {print $4}' | cut -d: -f2 | sort -u > /tmp/current_ports.txt
  new_ports=$(comm -23 /tmp/current_ports.txt "$LOG_FILE")
   
  if [ -n "$new_ports" ]; then
    message="New listening ports detected: $new_ports"
    send_email "$message"
  fi

  # Update the log file with the current ports
  mv /tmp/current_ports.txt "$LOG_FILE"
   
  # Sleep for a while before checking again (e.g., every 5 minutes)
  sleep 300
done
hashtag