export New_tag
docker rmi $(docker images -aq)
docker pull 644435390668.dkr.ecr.eu-west-2.amazonaws.com/yuval-klechevsky-repo:${New_tag}
cd GYM-protfolio
docker compose -f docker-compose-prod  build --no-cache
docker compose -f docker-compose-prod up -d
sleep 10
curl 35.178.35.133:80    
