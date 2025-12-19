# Senterm Release

Binary distribution repository for [Senterm](https://github.com/neuralfoundry-coder/senterm).

## One-Line Installation

### macOS (Universal: Intel + Apple Silicon)

```bash
curl -sSfL https://raw.githubusercontent.com/neuralfoundry-coder/senterm-release/main/install.sh | bash
```

### Linux (x86_64)

```bash
curl -sSfL https://raw.githubusercontent.com/neuralfoundry-coder/senterm-release/main/install-linux.sh | bash
```

### With specific version

```bash
# macOS
curl -sSfL https://raw.githubusercontent.com/neuralfoundry-coder/senterm-release/main/install.sh | bash -s -- --version 20251218

# Linux
curl -sSfL https://raw.githubusercontent.com/neuralfoundry-coder/senterm-release/main/install-linux.sh | bash -s -- --version 20251218
```

## Usage

After installation, run:
```bash
x              # Start in current directory
x <path>       # Start in specified path
```

## API Key Configuration

To use AI features, set up API keys as **system environment variables**.

### macOS / Linux

Add to your shell profile (`~/.zshrc` or `~/.bashrc`):

```bash
export OPENAI_API_KEY="your-openai-key"
export GEMINI_API_KEY="your-gemini-key"
```

Then reload: `source ~/.zshrc`

## Uninstall

```bash
sudo rm /usr/local/bin/x
```

## Supported Platforms

- **macOS**: Universal binary (Intel x86_64 + Apple Silicon arm64)
- **Linux**: x86_64 (static binary)
