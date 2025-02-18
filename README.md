# envloader

A minimal, standalone .env and .envrc loader with no dependencies.

## Why use this instead of direnv?

Well, I'll be honest - use direnv if you can. It's a great tool and I use it myself. I built this because I had an absolute headache trying to get direnv working on a windows machine. It was likely a very specific problem due to a locked down machine. (And profile being on onedrive which was set by a group policy). So :shrug: this is what I came up with.

## Features

- Zero dependencies
- Cross-platform support (Windows, Linux, macOS)
- Supports both `.env` and `.envrc` files
- Simple shell integration


## Installation

### Using Homebrew
```bash
brew install willwade/envloader/envloader
```

### Using Scoop
```powershell
scoop bucket add envloader https://github.com/willwade/envloader
scoop install envloader
```

## Usage

Due to how shell environments work, the way you use envloader depends on your shell:

### PowerShell

```powershell
# Either:
Invoke-Expression $(envloader)
# Or:
. envloader
```

### Bash/Zsh

```bash
# Either:
eval "$(envloader)"
# Or:
source envloader
```

This will:
1. Find the nearest `.env` or `.envrc` file
2. Load its environment variables into your current shell session
3. Variables will be available to all processes run in that shell session

Advanced options:
```bash
# Load from a specific file
envloader -f path/to/.env

# Search up to specific depth for .env files
envloader --depth 3
```

## Shell Integration

For a more convenient experience, you can add a shell function to your profile:

### PowerShell
Add to your `$PROFILE` (eg. `notepad $PROFILE`):

```powershell
function envload { 
    # Join multiple lines into a single string and pipe to Invoke-Expression
    envloader | Out-String | Invoke-Expression
}
```

### Bash
Add to your `~/.bashrc`:
```bash
envload() {
    eval "$(envloader)"
}
```

### Zsh
Add to your `~/.zshrc`:
```zsh
envload() {
    eval "$(envloader)"
}
```

### Fish
Add to your `~/.config/fish/functions/envload.fish`:
```fish
function envload
    eval (envloader)
end
```

After adding to your profile and restarting your shell, you can simply use:
```bash
envload
```

This will load environment variables from the nearest `.env` or `.envrc` file.


### How it works

The `envloader` binary:
1. Finds and reads `.env`/`.envrc` files
2. Outputs shell-appropriate commands for evaluation
3. Variables are set in your shell when commands are evaluated


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