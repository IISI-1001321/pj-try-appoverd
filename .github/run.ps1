aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 976952618766.dkr.ecr.us-east-1.amazonaws.com
 
docker build -t <你的專案名稱> .
 
docker tag <你的專案名稱>:latest 976952618766.dkr.ecr.us-east-1.amazonaws.com/wh/test:latest
 
docker push 976952618766.dkr.ecr.us-east-1.amazonaws.com/wh/test:latest
 
aws ecs update-service \
    --cluster 20260312 \
    --service 20260312-service-w2p0s3tq \
    --task-definition 20260312:2
 
 
aws ecs update-service \
    --cluster 20260312 \
    --service 20260312-service-w2p0s3tq \
    --force-new-deployment