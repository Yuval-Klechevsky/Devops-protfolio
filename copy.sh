#!/bin/bash
ssh ubuntu@35.178.35.133 mkdir GYM-protfolio
scp ./requirements.txt  ubuntu@35.178.35.133:/home/ubuntu/GYM-protfolio
scp ./mongo.dockerfile  ubuntu@35.178.35.133:/home/ubuntu/GYM-protfolio
scp ./nginx.dockerfile  ubuntu@35.178.35.133:/home/ubuntu/GYM-protfolio
scp ./docker-compose-prod.yaml  ubuntu@35.178.35.133:/home/ubuntu/GYM-protfolio
scp ./init-db.js ubuntu@35.178.35.133:/home/ubuntu/GYM-protfolio
scp ./app.py ubuntu@35.178.35.133:/home/ubuntu/GYM-protfolio
scp ./tests/unit-test.sh ubuntu@35.178.35.133:/home/ubuntu/GYM-protfolio/tests
scp ./nginx/nginx.conf ubuntu@35.178.35.133:/home/ubuntu/GYM-protfolio/nginx
scp ./templates/index.html ubuntu@35.178.35.133:/home/ubuntu/GYM-protfolio/templates
scp ./deploy.sh ubuntu@35.178.35.133:/home/ubuntu/GYM-protfolio