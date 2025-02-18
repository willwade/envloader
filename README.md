# envloader

A minimal, standalone tool for loading `.env` and `.envrc` files with no dependencies. Works across platforms (Windows, Linux, Mac) and can be used either as a standalone executable or with helper scripts.


## Why use this instead of direnv?

Well, I'll be honest - use direnv if you can. It's a great tool and I use it myself. I built this because I had an absolute headache trying to get direnv working on a windows machine - and with uv. It was likely a very specific problem due to a locked down machine. (And profile being on onedrive which was set by a group policy). So :shrug: this is what I came up with.


## Features

- Zero dependencies
- Cross-platform support (Windows, Linux, macOS)
- Supports both `.env` and `.envrc` files
- Includes helper scripts for easy environment variable loading
- Minimal installation requirements

## Installation

### macOS
```bash
brew tap willwade/envloader
brew install envloader
```

### Windows
```powershell
scoop bucket add envloader https://github.com/willwade/envloader
scoop install envloader/scoop/envloader
```

After installation, you can use `envload` to load environment variables in both PowerShell and CMD. If you want to use the `envloader` executable directly, you can do so by running `envloader` in your terminal. It should be in your path if using scoop. 

### Manual Installation

For Linux/macOS (x86_64):
```bash
# Download and extract
curl -L https://github.com/willwade/envloader/releases/latest/download/envloader_Linux_x86_64.tar.gz | tar xz

# Move files to a location in your PATH
sudo mkdir -p /usr/local/bin
sudo mv envloader envload envloader.sh /usr/local/bin/
```

For macOS ARM (M1/M2):
```bash
# Download and extract
curl -L https://github.com/willwade/envloader/releases/latest/download/envloader_Darwin_arm64.tar.gz | tar xz

# Move files to a location in your PATH
sudo mkdir -p /usr/local/bin
sudo mv envloader envload envloader.sh /usr/local/bin/
```

Download and extract to your user profile:

```powershell
# Create directory in your user profile
New-Item -ItemType Directory -Path "$env:USERPROFILE\.envloader" -Force

# Download and extract
Invoke-WebRequest -Uri https://github.com/willwade/envloader/releases/latest/download/envloader_Windows_x86_64.zip -OutFile envloader.zip
Expand-Archive envloader.zip -DestinationPath "$env:USERPROFILE\.envloader" -Force

# Add to user's PATH (no admin required)
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
$envloaderPath = "$env:USERPROFILE\.envloader"
[Environment]::SetEnvironmentVariable("Path", "$userPath;$envloaderPath", "User")
```

After installation, you can use the `envload.ps1` command to load environment variables from any directory. You may need to restart your terminal for the PATH changes to take effect.

## Usage

The simplest way to use envloader is with the `envload` command, which will automatically detect your shell and set the environment variables:

```bash
# In bash/zsh:
envload

# In PowerShell:
envload.ps1

# In CMD:
envload
```

This will:
1. Find the nearest `.env` or `.envrc` file
2. Load its environment variables into your current shell session
3. Support uv environments if detected

Advanced options:
```bash
# Load from a specific file
envload -f path/to/.env

# Search up to specific depth for .env files
envload --depth 3
```

### How it works

Under the hood, envloader consists of:
1. A core executable that finds and parses environment files
2. Shell-specific scripts that apply the variables to your session

You can also run the core executable directly with `envloader` to see the commands it would run, without applying them.

## Building from source

Requires Go 1.x or higher and goreleaser to be installed.

```bash
git clone https://github.com/willwade/envloader
cd envloader
goreleaser build --snapshot --skip-publish
```

## License

[MIT License](LICENSE)

---

Note: To use the GitHub releases, you'll need to set up a `GITHUB_TOKEN` with appropriate permissions if you're downloading from private repositories.