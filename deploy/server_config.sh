# lemur server config


# update
sudo apt-get update 
sudo apt-get upgrade

# packages
sudo apt install git
sudo apt-get install ca-certificates curl gnupg lsb-release
sudo apt-get install docker-ce docker-ce-cli containerd.io
sudo apt-get install docker-compose
sudo apt-get install r-base

#---- swap ----#
sudo fallocate -l 64G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
swapon --show
sudo cp /etc/fstab /etc/fstab.back
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
sudo sysctl vm.swappiness=1

sudo nano /etc/sysctl.conf
# add line: vm.swappiness=1

#---- ufw ----#
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow from 163.1.150.0/24 proto tcp to any port 22
sudo ufw allow http
sudo ufw allow https

sudo ufw enable


#---- docker ----#

# build docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
# add user to docker group
sudo usermod -aG docker ubuntu
newgrp docker


#---- shinyproxy ----#

# modify docker config
sudo systemctl edit docker
# [Service]
# ExecStart=
# ExecStart=/usr/bin/dockerd -H unix:// -D -H tcp://127.0.0.1:2375

sudo chmod a+rw /var/run/docker.sock

sudo systemctl daemon-reload
sudo systemctl restart docker


#---- lemur app ----#

# NOTE: first setup a GitHub deploy key for the lemur repository and add it to ~/.ssh/config

cd ~
git clone http://github.com/OxfordDemSci/lemur

# deploy
cd ~/lemur
docker-compose up -d












