#!/bin/bash

# Update and upgrade system packages
sudo apt update && sudo apt upgrade -y

# Install required packages
sudo apt install python3-pip git redis-server xvfb libfontconfig wkhtmltopdf python3.10-venv -y
sudo apt install postgresql postgresql-contrib -y

# Check if NVM is already installed
if [ ! -d "$HOME/.nvm" ]; then
  # NVM is not installed, so install it
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
fi

# Load NVM (if it's installed)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Install Node.js 18 and Yarn
nvm install 18
npm install -g yarn

# Source bashrc to ensure environment variables are set
source ~/.bashrc

# Install Frappe Bench
pip3 install frappe-bench

# Check if it's a server or desktop OS
if [ -f /usr/bin/Xorg ]; then
  # It's a desktop OS
  export PATH="$HOME/.local/bin:$PATH"
else
  # It's a server OS
  export PATH="/usr/local/bin:$PATH"
fi

# Initialize Frappe Bench
cd ~/Documents/code/samaajainstall/  # Change to your desired directory
bench init --frappe-branch version-14-hotfix frappe-bench

# Check if the PostgreSQL user exists and create one if not
postgres_user="$USER"  # Use the current user's username for the PostgreSQL user
if ! sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='$postgres_user'"; then
  read -p "Enter a password for the PostgreSQL user '$postgres_user': " postgres_password
  sudo -u postgres psql -c "CREATE USER $postgres_user WITH PASSWORD '$postgres_password';"
fi

# Prompt the user to suggest a site name
read -p "Enter a site name: " site_name

# Check if a PostgreSQL table exists for the site
if ! sudo -u postgres psql -d "$site_name" -c "SELECT 1 FROM pg_tables WHERE tablename='your_table_name'"; then
  # Create a new site with PostgreSQL as the database
  bench new-site "$site_name" --db-type postgres
  bench use "$site_name"
  bench get-app https://github.com/fossunited/Samaaja --resolve-deps
  bench --site "$site_name" install-app samaaja
fi

# Activate the virtual environment
source ~/Documents/code/samaajainstall/frappe-bench/env/bin/activate

# Start the Bench server
bench start
