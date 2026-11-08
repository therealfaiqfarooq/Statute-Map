#!/bin/zsh
# Double-click to run Statute Map on a Mac. Keep this window open while you
# use it; closing it stops the app.
cd "$(dirname "$0")"

# Pick up Node from nvm or Homebrew if the shell didn't already find it.
if ! command -v npm >/dev/null 2>&1; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
fi
if ! command -v npm >/dev/null 2>&1; then
  echo "Statute Map needs Node.js 20.19 or newer. Install it from https://nodejs.org and try again."
  read -k1 "?Press any key to close."
  exit 1
fi

# First run: install dependencies.
if [ ! -d node_modules ]; then
  echo "Installing dependencies (first run only)..."
  npm install || { read -k1 "?Install failed. Press any key to close."; exit 1; }
fi

if lsof -nP -iTCP:5173 -sTCP:LISTEN >/dev/null 2>&1; then
  open http://localhost:5173
  exit 0
fi
(sleep 2 && open http://localhost:5173) &
exec npm run dev -- --port 5173 --strictPort
