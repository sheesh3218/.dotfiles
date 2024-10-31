source <(curl -s https://raw.githubusercontent.com/MorganKryze/bash-toolbox/main/src/prefix.sh)

info "Updating the hostname..."
NEW_HOSTNAME="concord"
CURRENT_HOSTNAME=$(scutil --get HostName)
if [ "$CURRENT_HOSTNAME" != "$NEW_HOSTNAME" ]; then
    sudo scutil --set HostName "$NEW_HOSTNAME" || error "Failed to set HostName."
    sudo scutil --set LocalHostName "$NEW_HOSTNAME" || error "Failed to set LocalHostName."
    sudo scutil --set ComputerName "$NEW_HOSTNAME" || error "Failed to set ComputerName."
    dscacheutil -flushcache || error "Failed to flush DNS cache."
else
    warning "Hostname is already set to $NEW_HOSTNAME."
fi

info "Installing Xcode Command Line Tools..."
if xcode-select -p &>/dev/null; then
    warning "Xcode Command Line Tools are already installed."
else
    info "Installing Xcode Command Line Tools..."
    xcode-select --install || error "Failed to install Xcode Command Line Tools."
    acknoledge "Download the Xcode Command Line Tools from the pop-up window before continuing."
fi

info "Fetching the .dotfiles from GitHub..."
if [ -d "$HOME/.dotfiles" ]; then
    cd "$HOME/.dotfiles" || error "Failed to change directory to $HOME/.dotfiles."
    git pull origin main || error "Failed to pull the latest version of .dotfiles."
    git submodule update --init --recursive || error "Failed to update the submodules."

    info "Creating the .env file..."
    cp .env.example .env || error "Failed to copy the .env.example file."
    acknoledge "Update the .env file with your personal information after the installation."
else
    git clone --recurse-submodules https://github.com/MorganKryze/.dotfiles.git "$HOME/.dotfiles" || error "Failed to clone the .dotfiles repository."
    cd "$HOME/.dotfiles" || error "Failed to change directory to $HOME/.dotfiles."
fi

info "Setting up the environment and symlinks..."
source ./apps/zsh/.functions
create-symlinks || error "Failed to create symlinks."

info "Installing Nix..."
if ! command -v nix &>/dev/null; then
    sh <(curl -L https://nixos.org/nix/install) || error "Failed to install Nix."
    acknoledge "Restart a new terminal window and run this script again."
else if ! command -v brew &>/dev/null; then
    info "Nix is already installed. Proceeding to the config setup..."
    nix run nix-darwin --experimental-features "nix-command flakes" -- switch --flake ~/.config/nix-darwin#concord --impure || error "Failed to setup the Concord flake."
else 
    warning "Nix and Nix-Darwin are already installed. Rebuilding the environment..."
    darwin-rebuild switch --flake ~/.config/nix-darwin#concord
fi

success "Bootstrap completed successfully. Enjoy! :3"

# # Add default macOS settings
# sh .macos

# # If not installed, install brew
# if ! command -v brew &>/dev/null; then
#     echo "Brew is not installed. Installing..."
#     /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# fi

# # If not installed, install oh-my-zsh
# if [ ! -d "$HOME/.oh-my-zsh" ]; then
#     echo "Oh my zsh is not installed. Installing..."
#     sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#     git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
#     git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# fi

# # If not installed, install VSCode
# if ! command -v code &>/dev/null; then
#     echo "VSCode is not installed. Installing..."
#     brew install visual-studio-code
# fi

# # Install Homebrew packages
# sh brew.sh

# # Install miniconda
# source ./conda/.conda_func
# env-install

# # Install yabai and start the services (remember to disable the SIP)
# source ./yabai/.yabai_func
# yabai-install

# # Set up GitHub for this machine
# sh github.sh
