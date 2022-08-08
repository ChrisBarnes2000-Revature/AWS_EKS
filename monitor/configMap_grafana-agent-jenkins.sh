cat <<'EOF' | NAMESPACE=default /bin/sh -c 'kubectl apply -n $NAMESPACE -f -'

kind: ConfigMap
metadata:
  name: grafana-agent-jenkins
apiVersion: v1
data:
  grafana-jenkins-agent.yaml: |
    metrics:
      wal_directory: /tmp/grafana-agent-wal
      global:
        scrape_timeout: 60s
        scrape_interval: 65s
        evaluation_interval: 65s
      configs:
        - name: integrations
          remote_write:
            - basic_auth:
                username: *****
                password: *****
              url: http://cortex:9009/api/prom/push
              # url: https://prometheus-prod-10-prod-us-central-0.grafana.net/api/prom/push
          scrape_configs:
            - job_name: 'prometheus'
              static_configs:
                - targets:
                    - localhost:9090
            - job_name: integrations/jenkins
              metrics_path: /prometheus/
              static_configs:
                - targets:
                    - localhost:8080
      # Alertmanager configuration
      alerting:
        alertmanagers:
          - static_configs:
              - targets:
                # - alertmanager:9093
    integrations:
      prometheus_remote_write:
        - basic_auth:
            username: *****
            password: *****
          url: http://cortex:9009/api/prom/push
          # url: https://prometheus-prod-10-prod-us-central-0.grafana.net/api/prom/push

    logs:
      configs:
        - clients:
            - basic_auth:
                username: *****
                password: *****
              url: https://logs-prod3.grafana.net/loki/api/v1/push
          name: integrations
          positions:
            filename: /tmp/positions.yaml
          target_config:
            sync_period: 10s

EOF

# curl -O -L "https://github.com/grafana/agent/releases/latest/download/agent-darwin-amd64.zip";
# unzip "agent-darwin-amd64.zip";
# chmod a+x "agent-darwin-amd64";

# cat <<EOF > ./grafana-jenkins-agent_configmap.yaml
# DO STUFF FROM ABOVE
# EOF

# ./agent-darwin-amd64 --config.file=grafana-jenkins-agent_configmap.yaml;
# rm agent-darwin-amd64.zip && rm agent-darwin-amd64 && rm grafana-jenkins-agent_configmap.yaml;


#   static_configs:
#     - targets: ['http://a9b460f8f4c734d6c8ca3dee15115ba6-1718504656.us-east-1.elb.amazonaws.com:8080']
# remote_write:
#   - url: http://cortex:9009/api/prom/push