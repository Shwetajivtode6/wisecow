#!/bin/bash

# Define thresholds
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80

# Log file
LOGFILE="/var/log/system_health.log"

# Get current metrics
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
DISK_USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')

# Function to log messages
log_message() {
    local message=$1
    echo "$(date): $message" >> $LOGFILE
}

# Check CPU usage
if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
    log_message "CPU usage is high: ${CPU_USAGE}%"
fi

# Check memory usage
if (( $(echo "$MEMORY_USAGE > $MEMORY_THRESHOLD" | bc -l) )); then
    log_message "Memory usage is high: ${MEMORY_USAGE}%"
fi

# Check disk usage
if (( $DISK_USAGE > $DISK_THRESHOLD )); then
    log_message "Disk usage is high: ${DISK_USAGE}%"
fi

# Check running processes
RUNNING_PROCESSES=$(ps aux | wc -l)
PROCESS_THRESHOLD=200

if (( $RUNNING_PROCESSES > $PROCESS_THRESHOLD )); then
    log_message "High number of running processes: ${RUNNING_PROCESSES}"
fi
