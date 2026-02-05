# claude-env

Run [Claude Code](https://claude.ai/code) with environment variables loaded from `.env` files.

## Installation

### Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/jordanburke/claude-env/main/install.sh | bash
```

### From Source

```bash
git clone https://github.com/jordanburke/claude-env.git
cd claude-env && ./install.sh
```

## Usage

```bash
# Run Claude with .env from current directory
claude-env

# Check which .env file would be used
claude-env --check

# Use a specific .env file
claude-env --env ~/projects/myapp/.env

# Edit the .env file
claude-env --edit

# View .env contents
claude-env --view

# Update to latest version
claude-env --upgrade

# Show help
claude-env --help

# Pass arguments to Claude
claude-env -- -p "fix the bug"
```

## How It Works

1. Searches for `.env` files (see discovery order below)
2. If found, exports all variables from the file
3. Launches Claude Code with the loaded environment

### .env File Discovery

The tool finds your .env file in this order (first match wins):

1. `CLAUDE_ENV_FILE` environment variable
2. `--env FILE` command flag
3. `.env` in current directory or parents (up to git root)
4. `~/.config/claude-env/.env` (global fallback)

## Example .env

```bash
# API Keys
ANTHROPIC_API_KEY=sk-ant-...
OPENAI_API_KEY=sk-...
GITHUB_TOKEN=ghp_...

# Database
DATABASE_URL=postgres://user:pass@localhost:5432/db

# MCP Server config
PANEL_DEFAULT_MODELS=openai/gpt-4o
```

## Commands

| Option | Description |
|--------|-------------|
| `--help` | Show help |
| `--version` | Show version |
| `--verbose` | Show which .env is loaded |
| `--check` | Validate setup (doesn't run Claude) |
| `--edit` | Edit .env with $EDITOR |
| `--view` | View .env contents |
| `--upgrade` | Update to latest |
| `--env FILE` | Use specific .env file |

All other flags (like `-c`, `-p`, `-r`) pass through to Claude.

## Security

- **Never commit `.env` files** - add to `.gitignore`
- Use `.env.example` to document required variables
- Consider [claude-sops](https://github.com/jordanburke/claude-sops) for encrypted secrets

## Related Projects

| Project | Description |
|---------|-------------|
| [claude-sops](https://github.com/jordanburke/claude-sops) | Run Claude with SOPS-encrypted secrets (more secure than plain .env) |
| [claude-sudo](https://github.com/jordanburke/claude-sudo) | Run Claude with temporary sudo privileges and audit logging |

## Uninstall

```bash
./uninstall.sh
# or manually:
rm ~/.local/bin/claude-env
rm -rf ~/.local/share/claude-env
```

## License

MIT
