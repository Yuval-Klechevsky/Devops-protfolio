#!/bin/bash
ssh ubuntu@3.8.133.86 mkdir GYM-protfolio
scp ./requirements.txt  ubuntu@3.8.133.86:/home/ubuntu/GYM-protfolio
scp ./mongo.dockerfile  ubuntu@3.8.133.86:/home/ubuntu/GYM-protfolio
scp ./nginx.dockerfile  ubuntu@3.8.133.86:/home/ubuntu/GYM-protfolio
scp ./docker-compose-prod.yaml  ubuntu@3.8.133.86:/home/ubuntu/GYM-protfolio
scp ./init-db.js ubuntu@3.8.133.86:/home/ubuntu/GYM-protfolio
scp ./app.py ubuntu@3.8.133.86:/home/ubuntu/GYM-protfolio
scp ./tests/unit-test.sh ubuntu@3.8.133.86:/home/ubuntu/GYM-protfolio/tests
scp ./nginx/nginx.conf ubuntu@3.8.133.86:/home/ubuntu/GYM-protfolio/nginx
scp ./templates/index.html ubuntu@3.8.133.86:/home/ubuntu/GYM-protfolio/templates
scp ./deploy.sh ubuntu@3.8.133.86:/home/ubuntu/GYM-protfolio