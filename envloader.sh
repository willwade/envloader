#!/bin/bash
# Wrapper script for the Go app (Bash/Zsh)

# Run the Go app and capture its output
output=$(./my-env-app 2>&1)
exit_code=$?

# Check if the Go app succeeded
if [ $exit_code -ne 0 ]; then
    echo "Error running my-env-app:"
    echo "$output"
    exit 1
fi

# Apply the environment variables
eval "$output"
echo "Environment variables applied successfully."