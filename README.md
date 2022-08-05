# terraform_aws_eks
Simple template to start AWS EKS Cluster

# Start Here:
1. must have `aws` installed:
```sh
  aws sts get-caller-identity  # make sure your NOT 2206-devops-user
  
  # if your 2206-devops-user, reset credentials
  aws configure
  # add you credentials. To get credentials, login / click on your name / security credentials / access keys / create new access key.
```
2. Install Terraform
```sh
# https://www.terraform.io/downloads
# I had problems with there keyring. Install from binary:
sudo apt-get install -y jq gzip nano tar git unzip wget
curl -o /tmp/terraform.zip -LO https://releases.hashicorp.com/terraform/1.2.6/terraform_1.2.6_linux_amd64.zip
unzip /tmp/terraform.zip
chmod +x terraform && mv terraform $HOME/.local/bin/
terraform
```