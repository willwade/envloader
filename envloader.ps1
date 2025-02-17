# Wrapper script for the Go app (PowerShell)

# Run the Go app and capture its output
$output = .\my-env-app 2>&1
$exitCode = $LASTEXITCODE

# Check if the Go app succeeded
if ($exitCode -ne 0) {
    Write-Host "Error running my-env-app:"
    Write-Host $output
    exit 1
}

# Apply the environment variables
Invoke-Expression $output
Write-Host "Environment variables applied successfully."