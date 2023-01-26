#!/bin/bash
New_tag=$1
ssh ubuntu@35.178.35.133 mkdir -p GYM-protfolio
ssh ubuntu@35.178.35.133 mkdir -p GYM-protfolio/nginx
ssh ubuntu@35.178.35.133 mkdir -p GYM-protfolio/templates
scp ./requirements.txt  ubuntu@35.178.35.133:/home/ubuntu/GYM-protfolio
scp ./mongo.dockerfile  ubuntu@35.178.35.133:/home/ubuntu/GYM-protfolio
scp ./nginx.dockerfile  ubuntu@35.178.35.133:/home/ubuntu/GYM-protfolio
scp ./docker-compose-prod.yaml  ubuntu@35.178.35.133:/home/ubuntu/GYM-protfolio
scp ./init-db.js ubuntu@35.178.35.133:/home/ubuntu/GYM-protfolio
scp ./app.py ubuntu@35.178.35.133:/home/ubuntu/GYM-protfolio
scp ./nginx/nginx.conf ubuntu@35.178.35.133:/home/ubuntu/GYM-protfolio/nginx
scp ./templates/index.html ubuntu@35.178.35.133:/home/ubuntu/GYM-protfolio/templates
scp ./deploy.sh ubuntu@35.178.35.133:/home/ubuntu/GYM-protfolio
ssh ubuntu@35.178.35.133 ./GYM-protfolio/deploy.sh $New_tag

