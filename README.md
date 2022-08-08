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
# Add thes usernames & passwords To:
    # Lines 91-92 in `configMap_grafana-agent`
    #       35-56 in `configMap_grafana-agent-logs`
    #       51-52 in `configMap_grafana-agent-jenkins`
    # username: 2***********6
    # password: eyJ*****4NX0=

    # Lines 20-21           in `configMap_grafana-agent`
    #       20-21 & 26-7    in `configMap_grafana-agent-logs`
    #       19-20 & 42-3    in `configMap_grafana-agent-jenkins`
    # username: 5***********2
    # password: eyJ*****4NX0=

# For proper permissions to run a script use
# `chmod +x Script-Name.sh` (as/if needed)
./monitor/Intsall_All.sh
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

<!--
Ports

8080 - Jenkins
9090 - Prometheus
3000 - Grfana
4000 - Frontend
5000 - Backend API (api/product)

eks-cluster
443:443 - worker nodes to communicate with the cluster
1024:65535 - cluster API Server to communicate with the worker

vpc
443:443 - ingress
80:80 - ingress
0:0 - egress
0:65535 - ingress
1025:65535 - ingress
0:0 - egress
0:65535 - ingress
0:65535 - egress

worker-nodes
0:0 - egress
0:65535 - ingress
1025:65535 - ingress
-->

## Resources

- Ashish Patel's [Github](https://github.com/a-patel) & [Medium](https://iamaashishpatel.medium.com/)

- Kubernetes

  - [Kubernetes (K8s) Overview](https://medium.com/devops-mojo/kubernetes-k8s-overview-what-is-kubernetes-why-kubernetes-introduction-to-kubernetes-da92ee11c8fb)
  - [Kubernetes — Ingress Overview](https://medium.com/devops-mojo/kubernetes-ingress-overview-what-is-kubernetes-ingress-introduction-to-k8s-ingress-b0f81525ffe2)
  - [Kubernetes — Services Overview](https://medium.com/devops-mojo/kubernetes-services-overview-k8s-service-introduction-why-and-what-are-kubernetes-services-how-works-e6fd4fd4a51a)
  - [Kubernetes — Architecture Overview](https://medium.com/devops-mojo/kubernetes-architecture-overview-introduction-to-k8s-architecture-and-understanding-k8s-cluster-components-90e11eb34ccd)
  - [Kubernetes — Service Types Overview](https://medium.com/devops-mojo/kubernetes-service-types-overview-introduction-to-k8s-service-types-what-are-types-of-kubernetes-services-ea6db72c3f8c)
  - [Kubernetes — Objects (Resources/Kinds) Overview](https://medium.com/devops-mojo/kubernetes-objects-resources-overview-introduction-understanding-kubernetes-objects-24d7b47bb018)
  - [Kubernetes — Role-Based Access Control (RBAC) Overview](https://medium.com/devops-mojo/kubernetes-role-based-access-control-rbac-overview-introduction-rbac-with-kubernetes-what-is-2004d13195df)
  - [Kubernetes — Storage Overview — PV, PVC and Storage Class](https://medium.com/devops-mojo/kubernetes-storage-options-overview-persistent-volumes-pv-claims-pvc-and-storageclass-sc-k8s-storage-df71ca0fccc3)
  - [Kubernetes — Probes (Liveness, Readiness, and Startup) Overview](https://medium.com/devops-mojo/kubernetes-probes-liveness-readiness-startup-overview-introduction-to-probes-types-configure-health-checks-206ff7c24487)
  - [Kubernetes — Difference between Deployment and StatefulSet in K8s](https://medium.com/devops-mojo/kubernetes-difference-between-deployment-and-statefulset-in-k8s-deployments-vs-statefulsets-855f9e897091)

- AWS

  - [AWS — Organizations Overview](https://medium.com/awesome-cloud/aws-organizations-overview-introduction-to-what-is-aws-organization-multi-accounts-consolidated-billing-5009efc42b07)
  - [AWS — VPC Route Table Overview](https://medium.com/awesome-cloud/aws-vpc-route-table-overview-intro-getting-started-guide-5b5d65ec875f)
  - [AWS — Amazon RDS Proxy Overview](https://medium.com/awesome-cloud/aws-amazon-rds-proxy-overview-introduction-to-amazon-rds-proxy-what-is-aws-rds-proxy-b7d29b2a83c2)
  - [AWS — Amazon ElastiCache Overview](https://medium.com/awesome-cloud/aws-amazon-elasticache-overview-introduction-to-aws-elasticache-for-redis-memcached-f7165c3c2e5f)
  - [AWS — Amazon EKS vs ECS — Comparison](https://medium.com/awesome-cloud/aws-amazon-eks-vs-amazon-ecs-comparison-difference-between-eks-and-ecs-7451abd23859)
  - [AWS — Network Load Balancer (NLB) Overview](https://medium.com/awesome-cloud/aws-network-load-balancer-nlb-overview-introduction-to-amazon-nlb-what-is-aws-nlb-elb-837749c20063)
  - [AWS — Elastic Load Balancer (ELB) Overview](https://medium.com/awesome-cloud/aws-elastic-load-balancer-elb-overview-introduction-to-aws-elb-alb-nlb-gwlb-e2820fe8fe27)
  - [AWS — Application Load Balancer (ALB) Overview](https://medium.com/awesome-cloud/aws-application-load-balancer-alb-overview-introduction-to-amazon-alb-what-is-aws-alb-b5280f625153)
  - [AWS — Amazon RDS vs Amazon EC2 Relational Databases — Comparison](https://medium.com/awesome-cloud/aws-amazon-rds-vs-amazon-ec2-relational-databases-comparison-b28eb0802355)
  - [AWS — Difference between Application load balancer (ALB) and Network load balancer (NLB)](https://medium.com/awesome-cloud/aws-difference-between-application-load-balancer-and-network-load-balancer-cb8b6cd296a4)

- Terraform

  - [Terraform — Overview](https://medium.com/devops-mojo/terraform-overview-introduction-to-terraform-what-is-terraform-843bf65b83fb)
  - [Terraform — Best Practices](https://medium.com/devops-mojo/terraform-best-practices-top-best-practices-for-terraform-configuration-style-formatting-structure-66b8d938f00c)
  - [Terraform — Workspaces Overview](https://medium.com/devops-mojo/terraform-workspaces-overview-what-is-terraform-workspace-introduction-getting-started-519848392724)
  - [Terraform — Remote States Overview](https://medium.com/devops-mojo/terraform-remote-states-overview-what-is-terraform-remote-state-storage-introduction-936223a0e9d0)
  - [Terraform — Provision Amazon EKS Cluster using Terraform](https://medium.com/devops-mojo/terraform-provision-amazon-eks-cluster-using-terraform-deploy-create-aws-eks-kubernetes-cluster-tf-4134ab22c594)

- Other
  - [Prometheus — Overview](https://medium.com/devops-mojo/prometheus-overview-what-is-prometheus-introduction-92e064cff606)
  - [Helm — Helm Charts Overview](https://medium.com/devops-mojo/helm-charts-overview-introduction-to-helm-101-ef6296ecff87)

[terraform-provider-helm/issues/893](https://github.com/hashicorp/terraform-provider-helm/issues/893)
[kubernetes/ingress-nginx-values.yaml](https://github.com/kubernetes/ingress-nginx/blob/main/charts/ingress-nginx/values.yaml)
