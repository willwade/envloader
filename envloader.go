package main

import (
	"bufio"
	"flag"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

// findEnvFile searches for a .envrc or .env file recursively up to the root directory.
func findEnvFile(startDir string, maxDepth int) (string, error) {
	currentDir, err := filepath.Abs(startDir)
	if err != nil {
		return "", fmt.Errorf("failed to resolve absolute path: %w", err)
	}

	depth := 0
	for {
		for _, filename := range []string{".envrc", ".env"} {
			envPath := filepath.Join(currentDir, filename)
			if _, err := os.Stat(envPath); err == nil {
				return envPath, nil
			}
		}

		parentDir := filepath.Dir(currentDir)
		if parentDir == currentDir || (maxDepth > 0 && depth >= maxDepth) {
			break
		}
		currentDir = parentDir
		depth++
	}

	return "", fmt.Errorf("no .envrc or .env file found within %d levels", maxDepth)
}

// parseEnvFile reads and parses key=value pairs from an environment file.
func parseEnvFile(envPath string) (map[string]string, error) {
	file, err := os.Open(envPath)
	if err != nil {
		return nil, fmt.Errorf("failed to open environment file: %w", err)
	}
	defer file.Close()

	envVars := make(map[string]string)
	scanner := bufio.NewScanner(file)

	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}

		parts := strings.SplitN(line, "=", 2)
		if len(parts) != 2 {
			fmt.Printf("Warning: Skipping invalid line (expected key=value): %s\n", line)
			continue
		}

		key := strings.TrimSpace(parts[0])
		value := strings.TrimSpace(parts[1])
		value = strings.Trim(value, "'\"")

		envVars[key] = value
	}

	if err := scanner.Err(); err != nil {
		return nil, fmt.Errorf("error reading environment file: %w", err)
	}

	return envVars, nil
}

// detectUV checks if running under `uv`.
func detectUV() bool {
	return os.Getenv("VIRTUAL_ENV") != "" && exec.Command("uv", "--version").Run() == nil
}

// getShell detects the current shell based on environment variables.
func getShell() string {
	if os.Getenv("PSModulePath") != "" {
		return "powershell"
	}
	if os.Getenv("COMSPEC") != "" && strings.Contains(os.Getenv("COMSPEC"), "cmd.exe") {
		return "cmd.exe"
	}
	return "bash" // Default to Bash/Zsh
}

// formatEnvVar formats an environment variable for the current shell.
func formatEnvVar(key, value string) string {
	shell := getShell()
	switch shell {
	case "powershell":
		return fmt.Sprintf("$env:%s = \"%s\"", key, value)
	case "cmd.exe":
		return fmt.Sprintf("set %s=%s", key, value)
	default: // Bash/Zsh
		return fmt.Sprintf("export %s=%s", key, value)
	}
}

func main() {
	envFile := flag.String("env", "", "Path to the environment file")
	maxDepth := flag.Int("depth", 0, "Maximum search depth for .env files (0 means no limit)")
	flag.Parse()

	var envPath string
	var err error
	if *envFile != "" {
		envPath = *envFile
	} else {
		startDir, err := os.Getwd()
		if err != nil {
			fmt.Println("Error getting current directory:", err)
			os.Exit(1)
		}
		envPath, err = findEnvFile(startDir, *maxDepth)
		if err != nil {
			fmt.Println(err)
			os.Exit(1)
		}
	}

	envVars, err := parseEnvFile(envPath)
	if err != nil {
		fmt.Println("Error reading environment file:", err)
		os.Exit(1)
	}

	isUV := detectUV()

	if isUV {
		if err := exec.Command("uv", "--version").Run(); err != nil {
			fmt.Println("Error: uv is not installed:", err)
			os.Exit(1)
		}

		for key, value := range envVars {
			cmd := exec.Command("uv", "env", "--set", fmt.Sprintf("%s=%s", key, value))
			if err := cmd.Run(); err != nil {
				fmt.Println("Error setting environment variable via uv:", err)
				os.Exit(1)
			}
		}
		fmt.Println("Environment variables applied inside uv session.")
	} else {
		// Print formatted environment variables for the detected shell
		for key, value := range envVars {
			fmt.Println(formatEnvVar(key, value))
		}
	}
}