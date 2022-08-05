# terraform_aws_eks
Simple template to start AWS EKS Cluster

# Start Here:
1. You must have `aws` installed:
```sh
  aws sts get-caller-identity  # make sure your NOT 2206-devops-user
  
  # if your 2206-devops-user, reset credentials
  aws configure
  # To get new aws credentials, login / click on your name / security credentials / access keys / create new access key.
```
2. Install Terraform
```sh
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

3. Add your info in the terraform variables.tf file.
```diff
  + change cluster size and amounts in the eks-cluster-tf file
```

4. Run terraform
```sh
# Download modules
terraform init
# dry run to find errors
terraform plan
# will make the 
terraform apply
```

5. Get kubeconfig file from aws
```sh
aws eks update-kubeconfig --name CLUSTER_NAME

# check if you have access to cluster
aws eks list-clusters
```

6. Install Apps
```sh
# install nginx
# https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx
kubectl create ns nginx
helm upgrade --install ingress-nginx-chart ingress-nginx/ingress-nginx -n nginx

# install apps
kubectl create ns app
kubectl apply -f apps/apple-banana.yaml -n app
kubectl apply -f apps/flask.yaml -n app
kubectl apply -f apps/tea-coffee.yaml -n app

# install jenkins
kubectl create ns jenkins
# https://artifacthub.io/packages/helm/jenkinsci/jenkins
helm install my-jenkins jenkinsci/jenkins --version 4.1.13 -n jenkins -f jenkins/jenkins.yaml


```


7. Destroy Cluster
```sh
# Remove helm items:

# Remove namespaces and all content

# destroy all terraform infrastructure
terraform destroy
```

8. Double check all items destroyed. # The dashboard should be zero. Use the search bar at top of screen.
  - ec2
  - eks  # cluster should empty
  - vpc  # DHCP option sets will show 1. It's the dns service offered by aws and does not cost any money.