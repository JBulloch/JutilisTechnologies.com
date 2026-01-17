#!/bin/bash
set -e

echo "Setting up JutilisTechnologies.com..."

# Check if asdf is installed
if ! command -v asdf &> /dev/null; then
    echo "asdf is not installed. Installing asdf..."
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
    echo ". \"\$HOME/.asdf/asdf.sh\"" >> ~/.bashrc
    echo ". \"\$HOME/.asdf/completions/asdf.bash\"" >> ~/.bashrc
    export PATH="$HOME/.asdf/bin:$PATH"
    . "$HOME/.asdf/asdf.sh"
fi

# Add required plugins
echo "Adding asdf plugins..."
asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git || true
asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git || true
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git || true

# Install versions from .tool-versions
echo "Installing required versions..."
asdf install

# Install hex and rebar
echo "Installing hex and rebar..."
mix local.hex --force
mix local.rebar --force

# Install Phoenix
echo "Installing Phoenix..."
mix archive.install hex phx_new --force

# Install dependencies if mix.exs exists
if [ -f "mix.exs" ]; then
    echo "Installing Elixir dependencies..."
    mix deps.get

    echo "Installing Node.js dependencies..."
    cd assets && npm install && cd ..
fi

# Setup database if needed
if [ -f "mix.exs" ]; then
    echo "Setting up database..."
    mix ecto.create
    mix ecto.migrate
fi

echo "Setup complete!"
echo ""
echo "Run 'source ~/.bashrc' to load asdf in your current shell"
echo "Then run './bin/repo-menu.sh' to access the interactive menu"
