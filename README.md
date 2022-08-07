# Terraform_AWS_EKS

Simple Terraform template to start AWS EKS cluster with ingress-nginx controller

# Start Here:

```sh
git clone https://github.com/webmastersmith/terraform_aws_eks.git
cd terraform_aws_eks
```

1. You must have `aws` installed:

```sh
  aws sts get-caller-identity  # make sure your NOT 2206-devops-user

  # if your 2206-devops-user, reset credentials
  aws configure
  # To get new aws credentials, login / click on your name / security credentials / access keys / create new access key.
```

2. Install Terraform

```sh
# you should make ssh files
mkdir .ssh && ssh-keygen -t rsa -f ./.ssh/id_rsa

# https://www.terraform.io/downloads
# I had problems with their keyring. Install from binary:
sudo apt-get install -y tar unzip
curl -o /tmp/terraform.zip -LO https://releases.hashicorp.com/terraform/1.2.6/terraform_1.2.6_linux_amd64.zip
unzip /tmp/terraform.zip
chmod +x terraform && mv terraform $HOME/.local/bin/

# if $HOME/.local/bin does not exist
# mkdir -p $HOME/.local/bin
# add terraform to $PATH
# export PATH=$PATH:$HOME/.local/bin

# check if terraform in $PATH
terraform
```

3. Add your info in the terraform `variables.tf` file.

```sh
  change cluster size and number of instances in the 'eks-cluster-tf' file
```

4. Run terraform

```sh
# Download & initialize modules from terraform configuration
terraform init
# Validate terraform configuration
terraform validate
# Create terraform plan - Dry run to find errors
terraform plan -out state.tfplan
# Apply terraform plan -- will make the infrastructure (cluster, modules, & Pods) on aws.
terraform apply state.tfplan
```

5. Get kubeconfig file from aws

```sh
aws eks update-kubeconfig --name CLUSTER_NAME

# check if you have access to cluster
aws eks list-clusters
```

6. Install Nginx & Jenkins

```sh
# install nginx in it's own namespace
# https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx
kubectl create ns nginx
helm repo add ingress-nginx-chart ingress-nginx/ingress-nginx
helm repo update
helm upgrade --install ingress-nginx-chart ingress-nginx/ingress-nginx --version 4.2.0 -n nginx
# aws ingress setup takes a few minutes.
kubectl --namespace nginx get services -o wide -w ingress-nginx-chart-controller
# going to the aws address should return 404 not found. You know endpoint is working and ingress controller is responding.
# paste address into browser or curl -i http://YOUR-ADDRESS-us-east-1.elb.amazonaws.com

# install jenkins in it's own namespace
# https://artifacthub.io/packages/helm/jenkinsci/jenkins
# add your awsAddress to the jenkins/jenkins.yaml
#   jenkinsUrl: http://REDACTED-1903214843.us-east-1.elb.amazonaws.com/jenkins
kubectl create ns jenkins
helm repo add jenkins jenkins/jenkins
helm repo update
helm upgrade --install jenkins jenkins/jenkins --version 4.1.13 -n jenkins -f jenkins/jenkins.yaml
# get password.  user is 'admin'  Route: awsAddress/jenkins
kubectl exec --namespace jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/additional/chart-admin-password && echo
# login and update plugins. restart
```

7. Install Monitoring Tools (optional)

```sh
# Add this username & password
    # To lines 20-1 in `grafana-agent_configMap` & 20-1 & 26-7 in `grafana-logs_Agent_configMap`
    # username: *****
    # password: *****

    # To lines 91-2 in `grafana-agent_configMap` & 35-6 in `grafana-logs_Agent_configMap`
    # username: *****
    # password: *****

./monitor/Intsall.sh
```

8. Install Apps (optional)

```sh
# install apps
kubectl create ns app
# Routes: awsAddress/apple, awsAddress/banana
kubectl apply -f apps/apple-banana.yaml -n app
# Route: awsAddress/flask
kubectl apply -f apps/flask.yaml -n app
# Routes: awsAddress/tea, awsAddress/coffee
kubectl apply -f apps/tea-coffee.yaml -n app
# check ingress
kubectl describe ingress -n app


# Name:             ab-ingress
# Labels:           <none>
# Namespace:        app
# Address:          REDACTED-1924653928.us-east-1.elb.amazonaws.com
# Ingress Class:    nginx
# Default backend:  <default>
# Rules:
#   Host        Path  Backends
#   ----        ----  --------
#   *
#               /apple    apple-service:5678 (10.0.2.228:5678)
#               /banana   banana-service:5678 (10.0.2.9:5678)
# Annotations:  ingressClassName: nginx
# Events:
#   Type    Reason  Age                    From                      Message
#   ----    ------  ----                   ----                      -------
#   Normal  Sync    4m36s (x2 over 4m57s)  nginx-ingress-controller  Scheduled for sync



# Name:             cafe-ingress
# Labels:           <none>
# Namespace:        app
# Address:          REDACTED-1924653928.us-east-1.elb.amazonaws.com
# Ingress Class:    nginx
# Default backend:  <default>
# Rules:
#   Host        Path  Backends
#   ----        ----  --------
#   *
#               /coffee   coffee-svc:80 (10.0.2.213:80,10.0.2.32:80)
#               /tea      tea-svc:80 (10.0.2.11:80,10.0.2.190:80,10.0.2.215:80)
# Annotations:  ingressClassName: nginx
#               nginx.ingress.kubernetes.io/rewrite-target: /
# Events:
#   Type    Reason  Age                    From                      Message
#   ----    ------  ----                   ----                      -------
#   Normal  Sync    2m37s (x2 over 3m36s)  nginx-ingress-controller  Scheduled for sync



# Name:             flask-ingress
# Labels:           <none>
# Namespace:        app
# Address:          REDACTED.us-east-1.elb.amazonaws.com
# Ingress Class:    nginx
# Default backend:  <default>
# Rules:
#   Host        Path  Backends
#   ----        ----  --------
#   *
#               /flask   flask-service:80 (10.0.2.105:5000)
# Annotations:  ingressClassName: nginx
# Events:
#   Type    Reason  Age                    From                      Message
#   ----    ------  ----                   ----                      -------
#   Normal  Sync    3m37s (x2 over 3m46s)  nginx-ingress-controller  Scheduled for sync
```

9. Destroy Cluster

```sh
# Remove helm items:
helm uninstall ingress-nginx-chart -n nginx
helm uninstall jenkins -n jenkins

# Remove namespaces and all content
kubectl delete ns nginx
kubectl delete ns jenkins
kubectl delete ns app

# Destroy all terraform infrastructure
terraform destroy --auto-approve
```

10. Double check all items destroyed. # The dashboard's should be zero. Use the search bar at top of screen.

- ec2
- eks  # cluster should empty
- vpc  # DHCP option sets will show 1. It's the dns service offered by aws and does not cost any money.

---

Extra proficeny add these aliases

```sh
# Download & initialize modules from terraform configuration
alias TI="terraform init -no-color |& tee Output.log && echo "---" >> Output.log"

# Validate terraform configuration
alias TV="terraform validate -no-color |& tee -a Output.log && echo "---" >> Output.log"

# Create terraform plan - Dry run to find errors
alias TP="terraform plan -out state.tfplan -var-file=secrets.tfvars -no-color |& tee -a Output.log && echo "---" >> Output.log"
# Apply terraform plan -- will make the cluster & modules
alias TAP="terraform apply state.tfplan -no-color |& tee -a Output.log && echo "---" >> Output.log"

# Apply terraform Configuration without plan -- will make the cluster & modules
alias TAA="terraform apply -var-file=secrets.tfvars -no-color -auto-approve |& tee -a Output.log && echo "---" >> Output.log"

# Destroy all terraform infrastructure
alias TD="terraform destroy -var-file=secrets.tfvars -no-color -auto-approve |& tee -a Output.log"

# Remove all terraform infrastructure
alias TR="rm Output.log && rm -rf .terraform && rm .terraform.lock.hcl && rm terraform.tfstate"

# Deploy Nginx-Ingress Load-Balancer
alias Nginx-Ingress="kubectl create ns nginx && helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx && helm repo update && helm upgrade --install ingress-nginx-chart ingress-nginx/ingress-nginx --version 4.2.0 -n nginx && kubectl --namespace nginx get services -o wide -w ingress-nginx-chart-controller"

# Deploy Jenkins Server
alias Jenkins-Helm="kubectl create ns jenkins && helm repo add jenkins https://charts.jenkins.io && helm repo update && helm upgrade --install jenkins jenkins/jenkins --version 4.1.14 -n jenkins -f jenkins/jenkins.yaml && kubectl exec --namespace jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/additional/chart-admin-password && echo"
```
