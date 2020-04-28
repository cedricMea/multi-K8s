# 7- Build all images tag each one and push each one to docker hub

# Build images
docker build -t meacedric/multi-client:latest -t meacedric/multi-client:$SHA  -f ./client/Dockerfile ./client
docker build -t meacedric/multi-server:latest -t meacedric/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t meacedric/multi-worker:latest -t meacedric/multi-worker:$SHA-f ./worker/Dockerfile ./worker

#Push them to dockerHub
docker push meacedric/multi-client:latest
docker push meacedric/multi-server:latest
docker push meacedric/multi-worker:latest

docker push meacedric/multi-client:$SHA
docker push meacedric/multi-server:$SHA
docker push meacedric/multi-worker:$SHA


# 8- Apply all configs in the k8s dir
kubectl apply -f k8s

# 9- Imperatively set latest (the one we just build referenced by commit id) image on each deployment
kubectl set image deployments/server-deployement server=meacedric/multi-server:$SHA
kubectl set image deployments/client-deployement client=meacedric/multi-client:$SHA
kubectl set image deployments/worker-deployement worker=meacedric/multi-worker:$SHA