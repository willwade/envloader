#!/bin/bash
# Wrapper script for the Go app (Bash/Zsh)

# Run the envloader binary and capture its output
output=$(envloader 2>&1)
exit_code=$?

# Check if envloader succeeded
if [ $exit_code -ne 0 ]; then
    echo "Error running envloader:"
    echo "$output"
    exit 1
fi

# Apply the environment variables
eval "$output"
echo "Environment variables applied successfully."