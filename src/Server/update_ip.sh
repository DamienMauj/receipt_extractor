#!/bin/bash
current_ip=$(ifconfig en0 | awk '/inet /{print $2}')

# Path to your .env file
env_file="../MobileApp/receipt_extraction_project/receipt_extractor/lib/.env"

# Check if .env file exists
if [ ! -f "$env_file" ]; then
    echo "Warning: .env file not found at $env_file"
    echo "Creating .env file..."
    touch "$env_file"
fi

# Update or Add CURRENT_IP in .env file
if grep -q "CURRENT_IP=" "$env_file"; then
    # .env contains CURRENT_IP, so update it
    perl -pi -e "s/CURRENT_IP=.*/CURRENT_IP=$current_ip/" $env_file
else
    # .env does not contain CURRENT_IP, so add it
    echo "CURRENT_IP=$current_ip" >> $env_file
fi

echo "Updated .env with CURRENT_IP=$current_ip"
