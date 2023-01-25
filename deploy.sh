export New_tag
docker rmi $(docker images -aq)
docker pull 644435390668.dkr.ecr.eu-west-2.amazonaws.com/yuval-klechevsky-repo:${New_tag}
docker compose -f docker compose-prod  build --no-cache
docker compose -f docker compose-prod up -d

sleep 10
curl 3.8.133.86:80    
