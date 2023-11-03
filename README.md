### 1. Add a Dockerfile and docker-compose file and deploy on EC2
I have index.js that simulates a simple app that runs infinitely & sends metrics to a statsd server and I use graphite for statd server
I create Dockerfile and use docker-compose.yml for create container that contains both of js container and graphite container
```sh
docker-compose build
docker-compose up
```
I deploy docker-compose file on EC2
You can access graphite UI with my EC2 public IP: http://54.254.234.91

### 2. Deploy graphite helm chart and index.js using .yaml file on Minikube
I deployed js and graphite using my .yaml file that I pushed to this git repo in my local environment minikube instead of that I can't deploy on EKS due to free tier user.
##### Step
0. Install helm (If you haven't already.)
https://helm.sh/docs/intro/install/
1. Add graphite helm repo
```sh
helm repo add kiwigrid https://kiwigrid.github.io
```
2. Install graphite from helm repo
```sh
helm install graphite kiwigrid/graphite
```
3. Update config by using values.yaml in this repo
```sh
helm upgrade graphite kiwigrid/graphite -f values.yaml
```
4. Install ingress controller
```sh
# depending on your container platform (minikube for me)
minikube addons enable ingress

# verify installation
kubectl get pods -n ingress-nginx
```
![Alt text](https://github.com/boatpand/statd_graphite/blob/master/image_evidence/ingress_controller.png?raw=true)
5. Apply ingress
```sh
kubectl apply -f graphite-ingress.yaml
```
6. Apply js deployment
```sh
kubectl apply -f lynxjs.yaml
```
All resources
![Alt text](https://github.com/boatpand/statd_graphite/blob/master/image_evidence/all_resources.png?raw=true)
7. Port forwarding for Access Graphite UI
```sh
# store graphite pod name to variable
export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=graphite,app.kubernetes.io/instance=graphite" -o jsonpath="{.items[0].metadata.name}")

# Port forwarding
kubectl port-forward $POD_NAME 8080:80
```
##### You can access graphite UI via http://127.0.0.1:8080/
![Alt text](https://github.com/boatpand/statd_graphite/blob/master/image_evidence/graphite_ui.png?raw=true)
