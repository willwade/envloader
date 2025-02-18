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
# Join multiple lines if output is an array
if ($output -is [array]) {
    $output = $output -join "`n"
}
Invoke-Expression $output
Write-Host "Environment variables applied successfully."