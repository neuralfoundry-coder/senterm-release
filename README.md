# Senterm Release

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

To use AI features, you need to set up API keys as **system environment variables**.

### macOS / Linux

Add the following to your shell profile (`~/.zshrc` or `~/.bashrc`):

```bash
export OPENAI_API_KEY="your-openai-key"
export GEMINI_API_KEY="your-gemini-key"
```

Then reload your shell:
```bash
source ~/.zshrc  # or source ~/.bashrc
```

### Alternative: In-App Setup

You can also configure API keys within the app. Keys will be securely stored in:
- **macOS**: Keychain
- **Linux**: Secret Service (libsecret)

> ⚠️ **Note**: `.env` files are NOT supported for security reasons.

## Manual Installation

1. Download the archive:
   ```bash
   # macOS
   curl -LO https://raw.githubusercontent.com/neuralfoundry-coder/senterm-release/main/<version>/senterm-macos-universal.tar.gz
   
   # Linux
   curl -LO https://raw.githubusercontent.com/neuralfoundry-coder/senterm-release/main/<version>/senterm-linux-x86_64.tar.gz
   ```

2. Extract and install:
   ```bash
   tar -xzf senterm-*.tar.gz
   sudo cp senterm /usr/local/bin/x
   ```

## Uninstall

```bash
sudo rm /usr/local/bin/x
```

## Supported Platforms

- **macOS**: Universal binary (Intel x86_64 + Apple Silicon arm64)
- **Linux**: x86_64 (static binary)
