#!/bin/bash

cd $HOME/git/OxfordDemSci/lemur/

# build image
docker build --tag lemur_shiny .

# save lemur image to tar
docker save -o ./deploy/lemur.tar lemur_shiny

# transfer tar to server
scp ./deploy/lemur.tar ubuntu@big-lemur:~/lemur.tar

# rebuild image on server from tar
ssh big-lemur "docker load -i ~/lemur.tar"

# reload docker container
ssh big-lemur "cd /home/ubuntu/git/lemur;docker-compose up -d"
