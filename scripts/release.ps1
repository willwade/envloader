param(
    [Parameter(Mandatory=$true)]
    [string]$version
)

# Ensure version starts with 'v'
if (!$version.StartsWith("v")) {
    $version = "v$version"
}

# 1. Create and push the tag
Write-Host "Creating and pushing tag $version..."
git tag $version
git push origin $version

# 2. Run goreleaser to create the release
Write-Host "Running goreleaser..."
goreleaser release --clean

# 3. Get SHA256 hashes for all artifacts
Write-Host "Getting SHA256 hashes..."
$darwin_arm64_hash = (curl -L "https://github.com/willwade/envloader/releases/download/$version/envloader_Darwin_arm64.tar.gz" | shasum -a 256).Split(' ')[0]
$darwin_x86_64_hash = (curl -L "https://github.com/willwade/envloader/releases/download/$version/envloader_Darwin_x86_64.tar.gz" | shasum -a 256).Split(' ')[0]
$linux_x86_64_hash = (curl -L "https://github.com/willwade/envloader/releases/download/$version/envloader_Linux_x86_64.tar.gz" | shasum -a 256).Split(' ')[0]
$windows_x86_64_hash = (curl -L "https://github.com/willwade/envloader/releases/download/$version/envloader_Windows_x86_64.zip" | shasum -a 256).Split(' ')[0]

# 4. Update Formula/envloader.rb
Write-Host "Updating Homebrew formula..."
$formula_content = Get-Content "Formula/envloader.rb" -Raw
$formula_content = $formula_content -replace 'version "[^"]+"', "version `"$($version.TrimStart('v'))`""
$formula_content = $formula_content -replace '(?<=Darwin_arm64.tar.gz"\n\s+sha256 ")[^"]+', $darwin_arm64_hash
$formula_content = $formula_content -replace '(?<=Darwin_x86_64.tar.gz"\n\s+sha256 ")[^"]+', $darwin_x86_64_hash
$formula_content = $formula_content -replace '(?<=Linux_x86_64.tar.gz"\n\s+sha256 ")[^"]+', $linux_x86_64_hash
Set-Content "Formula/envloader.rb" $formula_content

# 5. Update scoop/envloader.json
Write-Host "Updating Scoop manifest..."
$scoop_content = Get-Content "scoop/envloader.json" -Raw | ConvertFrom-Json
$scoop_content.version = $version.TrimStart('v')
$scoop_content.architecture."64bit".url = "https://github.com/willwade/envloader/releases/download/$version/envloader_Windows_x86_64.zip"
$scoop_content.architecture."64bit".hash = $windows_x86_64_hash
$scoop_content | ConvertTo-Json -Depth 10 | Set-Content "scoop/envloader.json"

# 6. Commit and push changes
Write-Host "Committing and pushing changes..."
git add Formula/envloader.rb scoop/envloader.json
git commit -m "chore: update formula and manifest for $version"
git push

Write-Host "Release $version completed!"
Write-Host "Please verify the changes and run 'brew upgrade envloader' and 'scoop update envloader' to test." 