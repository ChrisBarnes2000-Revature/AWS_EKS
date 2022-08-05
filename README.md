# terraform_aws_eks
Simple template to start AWS EKS Cluster

# Start Here:
1. must have `aws` installed:
```sh
  aws sts get-caller-identity  # make sure your NOT 2206-devops-user
  
  # if your 2206-devops-user, reset credentials
  aws configure
  # To get new credentials, login / click on your name / security credentials / access keys / create new access key.
```
2. Install Terraform
```sh
# https://www.terraform.io/downloads
# I had problems with there keyring. Install from binary:
sudo apt-get install -y tar unzip wget
curl -o /tmp/terraform.zip -LO https://releases.hashicorp.com/terraform/1.2.6/terraform_1.2.6_linux_amd64.zip
unzip /tmp/terraform.zip
chmod +x terraform && mv terraform $HOME/.local/bin/

# check if terraform in $PATH
terraform
```

3. Change the terraform variables.tf file to your info
  - change cluster size and amounts in the `eks-cluster-tf` file
4. Run terraform
```sh
# Download modules
terraform init
# dry run to find errors
terraform plan
# will make the 
terraform apply
terraform destroy
```