### 1. Add a Dockerfile to containerize the app, with support for multiple environments (DEV, UAT & Production)
I create Dockerfile that support multiple environments (DEV, UAT & Production) and use docker-compose.yml for create container that contains both of js container and graphite container
choose environment by edit value from key target: in docker-compose.yml
```sh
docker-compose build
docker-compose up
```
### 2. Design the cloud infrastructure diagram (prefer AWS) with all the resources that are required for the application(Node app, statsd & the backend. Applicants can use any backends for statsd eg: Graphite). Use ECS or EKS as application platform.
I draw the diagram of EKS via draw.io, internet traffic -> ingress -> EKS I decided to deploy graphite by using helm chart because It has already installed all neccessary resources in one command. I exported diargram as pdf and push to this git repo.
### 3. Utilize Terraform to establish infrastructure that adheres to industry-standard security and high availability (HA) practices.
I learn terraform by myself so I don't expertise in terraform much. It's first time for me to use terraform for create eks cluster. I test it with terraform plan command but don't use terraform apply because I don't have paid plan AWS user (Free tier user of AWS doesn't include EKS).
### 4. (Optional) Deploy on the cloud computing platforms
Actually I want to deploy with EKS but that I told above Free tier user of AWS doesn't include EKS and I'm not farmilar with ECS so I deploy with docker-compose file from exercise 1 on EC2

You can access graphite UI with my EC2 public IP: http://13.212.238.57

### IAM user info If you need
Accout ID: 404936370167
Username: user2
Password: P@ssw0rd1234
Access key: AKIAV4SAWU733VFWDH6V
Secret access key : VZ9J0s8lwtbr7rzlbEntRmVTqwxR/41TjMl3MQzb

### SSH Client for connect to instance
Instance ID: i-0b3255a0f7769c8a8 (devops)
- Open an SSH client.
- Locate your private key file. The key used to launch this instance is devop-test.pem
- Run this command, if necessary, to ensure your key is not publicly viewable.
- chmod 400 devop-test.pem
- Connect to your instance using its Public DNS:
```sh
ec2-13-212-238-57.ap-southeast-1.compute.amazonaws.com
```
Example:
```sh
ssh -i "devop-test.pem" ubuntu@ec2-13-212-238-57.ap-southeast-1.compute.amazonaws.com
```
### [Additional]
I deployed js and graphite followed by exercise 2 diagram using my .yaml file that I pushed to this git repo in my local environment minikube instead of that I can't deploy on EKS due to free tier user.
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
![Alt text](https://raw.githubusercontent.com/boatpand/devops-test/master/image_evidence/ingress_controller.png?token=GHSAT0AAAAAACIMZ46BAADSHSP7BOFNPXGMZJCQQOA)
5. Apply ingress
```sh
kubectl apply -f graphite-ingress.yaml
```
6. Apply js deployment
```sh
kubectl apply -f lynxjs.yaml
```
All resources
![Alt text](https://raw.githubusercontent.com/boatpand/devops-test/master/image_evidence/all_resoureces.png?token=GHSAT0AAAAAACIMZ46ACD3Q2V73NG2X5XE6ZJCQO6A)
7. Port forwarding for Access Graphite UI
```sh
# store graphite pod name to variable
export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=graphite,app.kubernetes.io/instance=graphite" -o jsonpath="{.items[0].metadata.name}")

# Port forwarding
kubectl port-forward $POD_NAME 8080:80
```
##### You can access graphite UI via http://127.0.0.1:8080/
![Alt text](https://raw.githubusercontent.com/boatpand/devops-test/master/image_evidence/graphite_ui.png?token=GHSAT0AAAAAACIMZ46AUR2XAU4ACN7LVDM6ZJCQV7Q)
