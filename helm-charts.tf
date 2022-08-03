resource "helm_release" "ingress_nginx_chart" {
  name       = "my-ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.2.0"
  # namespace       = "kube-system"
  cleanup_on_fail = true
  atomic          = true

  values = [
    "${file("./charts/values-nginx.yaml")}"
  ]
}

# resource "helm_release" "jenkins_chart" {
#   name            = "my-jenkins"
#   repository      = "https://charts.jenkins.io/"
#   chart           = "jenkinsci/jenkins"
#   version         = "4.1.13"
#   namespace       = "kube-system"
#   cleanup_on_fail = true
#   atomic          = true

#   values = [
#     "${file("./charts/values-jenkins.yaml")}"
#   ]
# }

output "Ingress_Nginx_Controller_Namespace" {
  value = helm_release.ingress_nginx_chart.namespace
}
# output "Jenkins_Namespace" {
#   value = helm_release.jenkins_chart.namespace
# }
