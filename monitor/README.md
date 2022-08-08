# Kubernetes Monitoring (Grafan, Prometheus, Loki)

## Requirements

1. Make sure you have `kubectl`, `helm`, `curl`, & `envsubst` on `local systems`.
2. Configure `kubectl` to point at the correct cluster.
3. The `cluster` must also have `tiller` and `docker` installed on the `'default' namespace`
4. For proper permissions to run a script use `chmod +x Script-Name.sh` (as/if needed)

5. Update Usernanmes & Passwords

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
```

## Install on Kubernetes Cluster (AWS-EKS)

```sh
./Install_ALL.sh
```

`All Done!` You've just deployed monitoring to your Grafana Cloud!

## Step By Step Install

1. Create Metrics Agent Configmap.

```sh
./configMap_grafana-agent.sh
```

2. Create Agent StatefulSet

```sh
./statefulSet_grafana.sh
```

3. Deploy Kubernetes State Metrics (KSM).

```sh
./helmChart_grafana-ksm.sh
```

4. Deploy Logging Agent's Configmap.

```sh
./configMap_grafana-agent-logs.sh
```

5. This Finally Install The Grafana Agent To The Cluster & Configures The RBAC Permissions.

```sh
./daemonset_grafana-agent.sh
```

6. Deploy Jenkins Agent's Configmap.

```sh
./configMap_grafana-agent-jenkins.sh
```

`All Done!` You've just deployed monitoring to your Grafana Cloud!

## Resources

- <https://grafana.com/docs/agent/latest/configuration>
- <https://github.com/kubernetes/kube-state-metrics>
- <https://github.com/grafana/agent>
- Jenkins Integration:

  - <https://plugins.jenkins.io/prometheus>
  - <https://plugins.jenkins.io/cloudbees-disk-usage-simple>
  - <https://grafana.com/docs/grafana-cloud/data-configuration/integrations/integration-reference/integration-jenkins>

  - ---

  - [Darin Pope - Youtube](https://youtu.be/3H9eNIf9KZs)
  - [Darin Pope - Github](https://gist.github.com/darinpope/1c8422fb7512411760ccb2827d82613f)

  <!-- docker run -d -p 9090:9090 -v /home/vagrant/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus -->

  - ---

  - [Marcel Dempers - Youtube](https://youtu.be/YDtuwlNTzRc)
  - [Marcel Dempers - Github](https://github.com/marcel-dempers/docker-development-youtube-series/tree/master/monitoring/prometheus/kubernetes/1.23)
