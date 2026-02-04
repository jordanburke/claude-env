# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

`claude-env` is a shell wrapper that loads environment variables from a `.env` file before launching Claude Code. This allows per-project environment configuration without polluting your global shell environment.

## Installation

### Remote Install (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/jordanburke/claude-env/main/install.sh | bash
```

### Local Install

```bash
git clone https://github.com/jordanburke/claude-env.git
cd claude-env && ./install.sh
```

### Manual Install

```bash
# Clone and symlink
git clone https://github.com/jordanburke/claude-env.git ~/.local/share/claude-env
ln -s ~/.local/share/claude-env/bin/claude-env ~/.local/bin/claude-env

# Or add to PATH
export PATH="$PATH:/path/to/claude-env/bin"
```

## Usage

```bash
# Run Claude with auto-discovered .env
claude-env

# Check which .env file would be used
claude-env --check

# Use a specific .env file
claude-env --env ~/projects/myapp/.env

# Edit the .env file
claude-env --edit

# Show version
claude-env --version

# Update to latest version
claude-env --upgrade

# Pass arguments through to Claude
claude-env -- -p "fix the bug"
```

## Commands

| Command | Description |
|---------|-------------|
| `-h, --help` | Show help message |
| `-V, --version` | Show version information |
| `-v, --verbose` | Show which .env file is being used |
| `-c, --check` | Validate setup without running Claude |
| `-e, --edit` | Edit .env file with $EDITOR |
| `--view` | View .env contents (careful with secrets!) |
| `--upgrade` | Update claude-env to latest version |
| `--env FILE` | Override .env file path |

## .env File Discovery

The tool automatically finds your .env file (first match wins):

1. `CLAUDE_ENV_FILE` environment variable (explicit override)
2. `--env FILE` flag (explicit override)
3. `.env` in current directory or parent directories (up to git root)
4. Global fallback: `~/.config/claude-env/.env`

## Project Structure

```
claude-env/
├── bin/
│   └── claude-env      # Main executable
├── install.sh          # Installation script
├── uninstall.sh        # Uninstallation script
├── CLAUDE.md           # This file
└── README.md           # User documentation
```

## Use Cases

- **MCP Server Development**: Load API keys for providers (OpenRouter, OpenAI, etc.)
- **Project-specific Configuration**: Different API keys or settings per project
- **Sensitive Data**: Keep secrets in `.env` files (gitignored) rather than shell config

## Example .env File

```bash
# API Keys for LLM providers
OPENROUTER_API_KEY=sk-or-...
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...

# Database
DATABASE_URL=postgres://user:pass@localhost:5432/db

# MCP Server config
PANEL_DEFAULT_MODELS=openai/gpt-4o,anthropic/claude-sonnet-4-20250514
```

## Security Notes

- Never commit `.env` files to version control
- Add `.env` to your global `.gitignore`
- Use `.env.example` files to document required variables without values
- Use `--view` carefully as it displays secret values
