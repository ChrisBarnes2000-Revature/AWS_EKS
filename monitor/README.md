# Kubernetes Monitoring (Grafan, Prometheus, Loki)

## Steps to install on kubernetes cluster
<!--
- Have `kubectl` installed and pointing to the correct cluster.
- Also requires `helm`, `curl`, and `envsubst` on `local systems`.
- The `cluster` must also have `tiller` and `docker` installed.
  - These are all installed into the `'default' namespace`,
  - though this can be changed with a simple `'ctrl + H'` to
  - whichever namespace you prefer.
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

Jenkins Integration:

<https://grafana.com/docs/grafana-cloud/data-configuration/integrations/integration-reference/integration-jenkins>
