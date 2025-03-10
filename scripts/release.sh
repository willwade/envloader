#!/bin/bash
set -e  # Exit on any error

if [ -z "$1" ]; then
    echo "Usage: $0 <version>"
    echo "Example: $0 0.1.2"
    exit 1
fi

# Ensure version starts with 'v'
version=$1
[[ $version != v* ]] && version="v$version"

echo "Creating release for $version..."

# 0. Commit any pending changes first
echo "Checking for pending changes..."
if [[ -n $(git status -s) ]]; then
    echo "Committing pending changes..."
    git add .
    git commit -m "chore: prepare for release $version"
    git push
fi

# 1. Create and push the tag
echo "Creating and pushing tag..."
git tag "$version"
git push origin "$version"

# 2. Run goreleaser to create the release
echo "Running goreleaser..."
goreleaser release --clean

# 3. Wait for GitHub to process the release
echo "Waiting for GitHub release to be processed..."
sleep 10  # Add a delay to ensure files are available

# 4. Get SHA256 hashes for all artifacts
echo "Getting SHA256 hashes..."
# macOS hashes
darwin_arm64_hash=$(curl -sL "https://github.com/willwade/envloader/releases/download/$version/envloader_Darwin_arm64.tar.gz" | shasum -a 256 | cut -d' ' -f1)
darwin_x86_64_hash=$(curl -sL "https://github.com/willwade/envloader/releases/download/$version/envloader_Darwin_x86_64.tar.gz" | shasum -a 256 | cut -d' ' -f1)

# Windows hashes for all architectures
windows_x86_64_hash=$(curl -sL "https://github.com/willwade/envloader/releases/download/$version/envloader_Windows_x86_64.zip" | shasum -a 256 | cut -d' ' -f1)
windows_i386_hash=$(curl -sL "https://github.com/willwade/envloader/releases/download/$version/envloader_Windows_i386.zip" | shasum -a 256 | cut -d' ' -f1)
windows_arm64_hash=$(curl -sL "https://github.com/willwade/envloader/releases/download/$version/envloader_Windows_arm64.zip" | shasum -a 256 | cut -d' ' -f1)

# Linux hashes
linux_x86_64_hash=$(curl -sL "https://github.com/willwade/envloader/releases/download/$version/envloader_Linux_x86_64.tar.gz" | shasum -a 256 | cut -d' ' -f1)

# Print hashes for verification
echo "Hashes:"
echo "Windows x86_64: $windows_x86_64_hash"
echo "Windows i386: $windows_i386_hash"
echo "Windows ARM64: $windows_arm64_hash"
echo "Darwin ARM64: $darwin_arm64_hash"
echo "Darwin x86_64: $darwin_x86_64_hash"
echo "Linux x86_64: $linux_x86_64_hash"

# 5. Update Formula/envloader.rb
echo "Updating Homebrew formula..."
version_no_v=${version#v}

# First update all version numbers in URLs and version field
sed -i '' \
    -e "s|/v[0-9][^/]*/|/v$version_no_v/|g" \
    -e "s/version \".*\"/version \"$version_no_v\"/" \
    Formula/envloader.rb

# Then update hashes with more specific patterns
sed -i '' \
    -e "/Darwin_arm64\.tar\.gz/,/sha256/s/sha256 \"[^\"]*\"/sha256 \"$darwin_arm64_hash\"/" \
    -e "/Darwin_x86_64\.tar\.gz/,/sha256/s/sha256 \"[^\"]*\"/sha256 \"$darwin_x86_64_hash\"/" \
    -e "/Linux_x86_64\.tar\.gz/,/sha256/s/sha256 \"[^\"]*\"/sha256 \"$linux_x86_64_hash\"/" \
    Formula/envloader.rb

# 6. Update scoop/envloader.json with all architectures
echo "Updating Scoop manifest..."
version_no_v=${version#v}
jq --arg ver "$version_no_v" \
   --arg url64 "https://github.com/willwade/envloader/releases/download/$version/envloader_Windows_x86_64.zip" \
   --arg hash64 "$windows_x86_64_hash" \
   --arg url32 "https://github.com/willwade/envloader/releases/download/$version/envloader_Windows_i386.zip" \
   --arg hash32 "$windows_i386_hash" \
   --arg urlarm "https://github.com/willwade/envloader/releases/download/$version/envloader_Windows_arm64.zip" \
   --arg hasharm "$windows_arm64_hash" \
   '.version = $ver | 
    .architecture."64bit".url = $url64 | 
    .architecture."64bit".hash = $hash64 |
    .architecture."32bit".url = $url32 |
    .architecture."32bit".hash = $hash32 |
    .architecture."arm64".url = $urlarm |
    .architecture."arm64".hash = $hasharm' \
   scoop/envloader.json > scoop/envloader.json.tmp && mv scoop/envloader.json.tmp scoop/envloader.json

# 7. Commit and push changes
echo "Committing and pushing changes..."
git add Formula/envloader.rb scoop/envloader.json
git commit -m "chore: update formula and manifest for $version"
git push

echo "Release $version completed!"
echo "Please verify the changes and run 'brew upgrade envloader' and 'scoop update envloader' to test." 