# Dotfiles management with GNU Stow

# List all packages
packages := "zsh tmux ghostty aerospace bat zfz yazi claude nvim starship git btop fzf zed zellij"

# Default: show available commands
default:
    @just --list

# Install all dotfiles (create symlinks)
install:
    @echo "Installing dotfiles..."
    stow -v -t ~ {{packages}}
    @echo "Done!"

# Uninstall all dotfiles (remove symlinks)
uninstall:
    @echo "Removing dotfiles symlinks..."
    stow -v -t ~ -D {{packages}}
    @echo "Done!"

# Restow all packages (useful after adding new files)
restow:
    @echo "Restowing dotfiles..."
    stow -v -t ~ -R {{packages}}
    @echo "Done!"

# Install a specific package
install-pkg pkg:
    stow -v -t ~ {{pkg}}

# Uninstall a specific package
uninstall-pkg pkg:
    stow -v -t ~ -D {{pkg}}

# Update Brewfile from currently installed packages
brew-dump:
    @echo "Updating Brewfile..."
    brew bundle dump --force --file=Brewfile
    @echo "Brewfile updated!"

# Install packages from Brewfile
brew-install:
    @echo "Installing from Brewfile..."
    brew bundle install --file=Brewfile
    @echo "Done!"

# Check what would be installed from Brewfile
brew-check:
    brew bundle check --file=Brewfile || brew bundle list --file=Brewfile

# Full setup: install brew packages and dotfiles
setup: brew-install install
    @echo "Setup complete!"

# Show status of symlinks
status:
    @echo "Checking symlink status..."
    @for pkg in {{packages}}; do \
        echo "\n=== $pkg ==="; \
        stow -v -t ~ -n $pkg 2>&1 || true; \
    done

# Initialize submodules (needed after fresh clone)
submodule-init:
    git submodule update --init --recursive

# Update all submodules to latest
submodule-update:
    git submodule update --remote --merge
    @echo "Don't forget to commit the submodule reference update!"

# Full clone setup (submodules + brew + stow)
bootstrap: submodule-init brew-install install
    @echo "Bootstrap complete!"
