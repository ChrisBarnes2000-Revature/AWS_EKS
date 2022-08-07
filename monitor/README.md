# Kubernetes Monitoring (Grafan, Prometheus, Loki)

## Steps to install on kubernetes cluster
<!--
- Have `kubectl` installed and pointing to the correct cluster.
- Also requires `helm`, `curl`, and `envsubst` on `local systems`.
- The `cluster` must also have `tiller` and `docker` installed.
  - These are all installed into the `'default' namespace`,
  - though this can be changed with a simple `'ctrl + H'` to
  - whichever namespace you prefer.

if needed run
chmod +x Script-Name.sh
-->

1. Create metrics agent configmap.

```sh
grafana-agent_configmap.sh
```

2. Create Agent StatefulSet

```sh
grafana-stateful_set.sh
```

3. Deploy kubernetes state metrics.

```sh
grafana-kubernetes-state-metrics.sh
```

4. Deploy logging agent's configmap.

```sh
grafana-logs_Agent_configMap.sh
```

5. This finally installs the Grafana agent to the cluster
   and configures the RBAC permissions.

```sh
grafana-agent_daemonset.sh
```

All done! You've just deployed monitoring to your Grafana Cloud!

Lazy Run (All In One)

```sh
Install.sh

or

grafana-agent_configmap.sh && grafana-stateful_set.sh && grafana-kubernetes-state-metrics.sh && grafana-logs_Agent_configMap.sh && grafana-agent_daemonset.sh
```

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
