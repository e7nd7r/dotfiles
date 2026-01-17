# >>> Install curl if not present >>>
if ! command -v curl >/dev/null 2>&1; then
    echo "❌ curl is not installed. The execution will end."
    exit 1
fi

# >>> Install xcode tools if not present. >>>
echo "🛠 Installing Xcode Command Line Tools..."
xcode-select --install

# Wait until installation is complete
echo "⏳ Waiting for installation to complete..."
sleep 1

echo "✅ Xcode Command Line Tools installed."

# >>> Install brew if not present >>>
if command -v brew >/dev/null 2>&1; then
    echo "✅ Brew already installed."
else
    echo "ℹ️ Brew will be installed."
    /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Verify installation
    if ! command -v brew >/dev/null 2>&1; then
        echo "❌ Homebrew installation failed. Exiting."
        exit 1
    fi
fi

# >>> Install Brewfile >>>

# Install mas, a cli to install app store programs.
brew install mas

# Install or update xcode.
echo "ℹ️  Installing xcode."
mas install 497799835

# Ensure brew bundle is instaled.
# This brew subcommand allows to install brew packages
# from Brewfile.
brew tap homebrew/bundle

if [ -f "$HOME/Brewfile" ]; then
    echo "📦 Installing packages from Brewfile..."
    brew bundle --file=Brewfile
    echo "✅ Brewfile installation completed."
else
    echo "⚠️ No Brewfile found in the current directory. Skipping installation."
fi

# >>> Install tmuxifier >>>
if [ ! -d "$HOME/.tmuxifier" ]; then
    echo "ℹ️  Installing tmuxifier"
    git clone https://github.com/jimeh/tmuxifier.git ~/.tmuxifier
fi

# >>> Install tmux plugin manager (TMP) >>>
if [ ! -d "$HOME/.tmux/plugins/tmp" ]; then
    echo "ℹ️  Instaling tmux plugin manager (TMP)"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    echo "✅ TMP installed successfully."
fi


