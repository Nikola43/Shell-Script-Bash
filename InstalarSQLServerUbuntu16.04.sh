#!/bin/bash

#update system
sudo apt update
sudo apt dist-upgrade -y 

sudo echo "LC_ALL=es_ES.UTF-8" >> /etc/environment
sudo echo "LANG=es_ES.UTF-8" >> /etc/environment
sudo locale-gen "es_ES.UTF-8"
sudo dpkg-reconfigure locales

sudo apt update 
sudo apt upgrade -y

## Install SQL Server
# 1. Import the public repository GPG keys:
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

# 2. Register the Microsoft SQL Server Ubuntu repository:
curl https://packages.microsoft.com/config/ubuntu/16.04/mssql-server.list | sudo tee /etc/apt/sources.list.d/mssql-server.list

# 3. Run the following commands to install SQL Server:
sudo apt update
sudo apt install -y mssql-server

# 4. After the package installation finishes, run mssql-conf setup and follow the prompts.
#    Make sure to specify a strong password for the SA account (Minimum length 8 characters, 
#    including uppercase and lowercase letters, base 10 digits and/or non-alphanumeric symbols).
sudo /opt/mssql/bin/mssql-conf setup

# 5. Once the configuration is done, verify that the service is running:
systemctl status mssql-server

## Install SQL Server tools
# 1. Register the Microsoft Ubuntu repository.
curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list

# 2. Update the sources list and run the installation command with the unixODBC developer package.
sudo apt update 
sudo apt install mssql-tools unixodbc-dev -y

# 3. Optional: Add /opt/mssql-tools/bin/ to your PATH environment variable in a bash shell.
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc

#Create symlinks for tools
ln -sfn /opt/mssql-tools/bin/sqlcmd-13.0.1.0 /usr/bin/sqlcmd 
ln -sfn /opt/mssql-tools/bin/bcp-13.0.1.0 /usr/bin/bcp





