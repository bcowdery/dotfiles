# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a macOS dotfiles repository for machine provisioning and configuration management. It automates software installation via Homebrew, manages shell configurations (Oh My Zsh), handles runtime version management (asdf), and maintains dotfiles across machines.

## Bootstrap System Architecture

The repository uses a modular bootstrap system:

- **`bootstrap.sh`** - Main entry point that orchestrates all operations via subcommands
- **`lib/*.sh`** - Modular libraries sourced by bootstrap.sh containing installer functions:
  - `lib/dotfiles.sh` - Copies dotfiles to $HOME using rsync with exclusions
  - `lib/homebrew.sh` - Installs/updates Homebrew and processes the Brewfile
  - `lib/ohmyzsh.sh` - Installs/updates Oh My Zsh
  - `lib/asdf.sh` - Configures asdf with default Python 3, Node 24, and .NET 9 versions
  - `lib/scripts.sh` - Creates symlinks for bin/ scripts in ~/.local/bin (strips .sh extensions)
  - `lib/claude.sh` - Syncs Claude skills from config/claude/ to ~/.claude/

The bootstrap script is self-symlinking: during `install`, it creates `~/.local/bin/bootstrap` pointing to itself, enabling `bootstrap` to be called from anywhere after installation.

## Common Commands

### Bootstrap Operations
```bash
# Fresh machine setup (installs everything)
./bootstrap.sh install

# Update everything (homebrew, dotfiles, scripts)
bootstrap update

# Update specific components
bootstrap update homebrew    # Update Homebrew packages from Brewfile
bootstrap update dotfiles    # Copy dotfiles to $HOME (prompts for confirmation)
bootstrap update scripts     # Recreate symlinks for bin/ scripts
bootstrap update claude      # Sync Claude skills to ~/.claude (prompts for confirmation)
bootstrap update ohmyzsh     # Update Oh My Zsh
bootstrap update asdf        # Update asdf plugins and install latest versions

# Configure tools with defaults
bootstrap configure asdf     # Install asdf plugins and set default versions

# Edit files
bootstrap edit               # Open entire repo in $EDITOR
bootstrap edit homebrew      # Edit Brewfile
```

### macOS System Configuration
```bash
# Apply opinionated macOS system defaults (run once on new machines)
./macos.sh
```
**Warning:** This script contains personal preferences (hot corners, Finder settings, etc.). Review before running.

### Managing Runtime Versions (asdf)
```bash
# Installed by default: Python 3, Node 24, .NET 9 (configured in lib/asdf.sh)
# Set project-specific versions
cd my-project
asdf set nodejs latest:22
```

## File Structure

### Dotfiles Loading Chain
`.zshrc` sources configuration files in this order:
1. `.path` - PATH modifications
2. `.exports` - Environment variables
3. `.aliases` - Command aliases
4. `.functions` - Shell functions
5. `.extra` - User-specific config (copied once during install, never updated)
6. `.ssh-agent` - SSH agent configuration

### Important Files
- **`Brewfile`** - Homebrew package manifest (brew bundle)
- **`bin/*.sh`** - User scripts symlinked to ~/.local/bin (without .sh extension)
- **`config/`** - Application configurations (e.g., config/ghostty/config)
- **`config/claude/`** - Claude Code skills synced to ~/.claude/ (mirrors ~/.claude/ directory structure)
- **`.extra`** - Copied once during install, excluded from updates (for secrets, local overrides)

### Rsync Exclusions
When copying dotfiles, `lib/dotfiles.sh` excludes:
- `init/`, `bin/`, `lib/`, `config/`
- `.git/`, `.gitignore`, `.editorconfig`
- `bootstrap.sh`, `Brewfile`, `macos.sh`, `Readme.md`
- `.extra` (handled separately, only copied on first install)

## Key Behaviors

### Update Safety
- `update dotfiles` prompts for confirmation before overwriting $HOME files (use `--force` to skip)
- `.extra` is never overwritten after initial install
- `update scripts` removes broken symlinks in ~/.local/bin
- `update claude` prompts for confirmation before overwriting ~/.claude files (use `--force` to skip)

### Claude Skills Management
Skills stored in `config/claude/` are synced to `~/.claude/` to extend Claude Code's capabilities:
- Skills follow the `config/claude/skills/skill-name/SKILL.md` structure
- Each skill requires a `SKILL.md` file with YAML frontmatter (name, description) and markdown instructions
- `update claude` uses rsync to copy the entire config/claude/ directory to ~/.claude/
- Skills are personal (synced across all projects) and version-controlled in this repo
- Create new skills in config/claude/skills/, then run `bootstrap update claude` to sync

### Script Symlinking
Scripts in `bin/*.sh` are symlinked to `~/.local/bin` without the `.sh` extension:
- `bin/aws-credentials.sh` → `~/.local/bin/aws-credentials`
- `bin/tunnel.sh` → `~/.local/bin/tunnel`

### Shell Configuration
- Uses Oh My Zsh with Starship prompt (no ZSH theme)
- Enabled plugins: asdf, brew, git, gh, kubectl, direnv, macos, starship
- Loads zsh-autosuggestions and zsh-syntax-highlighting from Homebrew
- History settings: append mode, ignore duplicates, save immediately

## Development Notes

- The bootstrap script can be invoked from any location (follows symlinks to find $BOOTSTRAP_DIR)
- All lib/ modules are automatically sourced via `for f in ./lib/*.sh; do source "$f"; done`
- Color and formatting variables (red, green, bold, etc.) are defined in bootstrap.sh using tput
- Functions follow naming convention: `install_*`, `update_*`, `configure_*`
