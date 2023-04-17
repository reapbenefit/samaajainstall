sudo apt update && sudo apt upgrade
sudo apt install python3-pip git redis-server xvfb libfontconfig wkhtmltopdf python3.10-venv -y
sudo apt install postgresql postgresql-contrib -y
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
exec bash
source ~/.bashrc
nvm install 18
npm install -g yarn
pip3 install frappe-bench
export PATH="/usr/local/bin":$PATH
#if your image is the desktop image, PATH="$HOME/.local/bin"
source ~/.bashrc
bench init frappe-bench
cd frappe-bench

# type sudo -u postgres psql to enter PSQL command prompt for the user called Postgres, which is the Database's default username
# type ALTER USER postgres PASSWORD '_enter_your_own_password_'; to change the default password
# type \q to quit
# type exit to exit the postgres user and return to your own user

bench new-site <site-name> --db-type postgres
bench use <site-name>
bench get-app https://github.com/fossunited/Samaaja --resolve-deps
bench --site <site-name> install-app samaaja
bench start
