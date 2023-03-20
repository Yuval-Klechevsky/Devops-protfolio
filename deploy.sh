New_tag=$1
export New_tag
docker rmi $(docker images -aq)
docker pull 644435390668.dkr.ecr.eu-west-2.amazonaws.com/yuval-klechevsky-repo:${New_tag}
cd GYM-protfolio
docker compose -f docker-compose-prod.yaml  build --no-cache
docker compose -f docker-compose-prod.yaml up -d
sleep 10
curl 3.10.54.10:80    
