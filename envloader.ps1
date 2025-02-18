# Wrapper script for envloader (PowerShell)

# Run envloader and capture its output
$output = envloader 2>&1
$exitCode = $LASTEXITCODE

# Check if envloader succeeded
if ($exitCode -ne 0) {
    Write-Host "Error running envloader:"
    Write-Host $output
    exit 1
}

# Apply the environment variables
Invoke-Expression $output
Write-Host "Environment variables applied successfully."