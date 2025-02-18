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

# Process each line carefully
while IFS= read -r line; do
    if [[ $line =~ ^export\ (.*)$ ]]; then
        # Extract the variable assignment without 'export'
        assignment="${BASH_REMATCH[1]}"
        
        # Split into name and value
        if [[ $assignment =~ ^([^=]+)=(.*)$ ]]; then
            name="${BASH_REMATCH[1]}"
            value="${BASH_REMATCH[2]}"
            
            # Remove outer quotes if present
            value="${value#\"}"
            value="${value%\"}"
            
            # Set the environment variable directly
            export "$name=$value"
        fi
    fi
done <<< "$output"

echo "Environment variables applied successfully."