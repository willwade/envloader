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

# Join multiple lines if output is an array
if ($output -is [array]) {
    $output = $output -join "`n"
}

# Handle each line separately to properly escape special characters
$output -split "`n" | ForEach-Object {
    if ($_ -match '^(\$env:[^=]+)\s*=\s*(.*)$') {
        $varName = $matches[1]
        $value = $matches[2].Trim()
        
        # If value is a JSON string (contains escaped quotes)
        if ($value -match '^\s*".*\\".+"$') {
            # Remove outer quotes and set directly
            $actualValue = $value.Substring(1, $value.Length - 2)
            Set-Item -Path "Env:$($varName.Replace('$env:', ''))" -Value $actualValue
        }
        # If value starts with a quote, assume it's already properly quoted
        elseif ($value -match '^\s*"') {
            Invoke-Expression "$varName = $value"
        } else {
            # Otherwise, ensure proper quoting
            Invoke-Expression "$varName = `"$value`""
        }
    }
}

Write-Host "Environment variables applied successfully."