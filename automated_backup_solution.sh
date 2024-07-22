#!/bin/bash

# Configuration
SOURCE_DIR="/path/to/source"
REMOTE_USER="username"
REMOTE_HOST="remote.server.com"
REMOTE_DIR="/path/to/remote/backup"
LOGFILE="/var/log/backup.log"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_NAME="backup_${DATE}.tar.gz"

# Function to log messages
log_message() {
    local message=$1
    echo "$(date): $message" >> $LOGFILE
}

# Create backup
log_message "Starting backup of ${SOURCE_DIR}"
tar -czf /tmp/${BACKUP_NAME} -C ${SOURCE_DIR} .

# Transfer backup to remote server
if rsync -avz /tmp/${BACKUP_NAME} ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}; then
    log_message "Backup successfully transferred to ${REMOTE_HOST}:${REMOTE_DIR}"
else
    log_message "Backup transfer failed"
fi

# Clean up
rm /tmp/${BACKUP_NAME}
