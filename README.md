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

### Using curl (Linux/macOS)

For Linux/macOS (x86_64):
```bash
curl -L https://github.com/willwade/envloader/releases/latest/download/envloader_Linux_x86_64.tar.gz | tar xz
sudo mv envloader /usr/local/bin/
```

For macOS ARM (M1/M2):
```bash
curl -L https://github.com/willwade/envloader/releases/latest/download/envloader_Darwin_arm64.tar.gz | tar xz
sudo mv envloader /usr/local/bin/
```


## Using PowerShell (Windows)

Download and extract the latest release:

```powershell
# Create a directory in your user profile
New-Item -ItemType Directory -Path "$env:USERPROFILE\.envloader" -Force

# Download and extract
Invoke-WebRequest -Uri https://github.com/willwade/envloader/releases/latest/download/envloader_Windows_x86_64.zip -OutFile envloader.zip
Expand-Archive envloader.zip -DestinationPath "$env:USERPROFILE\.envloader" -Force
```

You can now run envloader from: `%USERPROFILE%\.envloader\envloader.exe`

## Usage

### Standalone Executable

By default, envloader will:
1. Search for `.envrc` or `.env` files in the current directory and parent directories
2. Print environment variables in the correct format for your shell (bash/PowerShell/CMD)
3. Support uv environments if detected

Basic usage:
```bash
# Print environment variables from nearest .env or .envrc file
envloader

# Print environment variables from a specific file
envloader -f path/to/.env

# Search for .env files up to specific depth
envloader --depth 3
```

The output will automatically format for your shell:
- Bash/Zsh: `export KEY=value`
- PowerShell: `$env:KEY = "value"`
- CMD: `set KEY=value`

### Helper Scripts

The helper scripts automatically capture and apply the environment variables:

#### Shell
```bash
source envloader.sh
```

#### PowerShell
```powershell
. .\envloader.ps1
```

#### Windows CMD
```batch
call envloader.cmd
```

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