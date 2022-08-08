cat <<'EOF' | NAMESPACE=default /bin/sh -c 'kubectl apply -n $NAMESPACE -f -'

kind: ConfigMap
metadata:
  name: grafana-agent
apiVersion: v1
data:
  agent.yaml: |
    metrics:
      wal_directory: /var/lib/agent/wal
      global:
        scrape_interval: 60s
        external_labels:
          cluster: cloud
      configs:
        - name: integrations
          remote_write:
            - url: https://prometheus-prod-10-prod-us-central-0.grafana.net/api/prom/push
              basic_auth:
                username: *****
                password: *****
          scrape_configs:
            - bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
              job_name: integrations/kubernetes/cadvisor
              kubernetes_sd_configs:
                - role: node
              metric_relabel_configs:
                - source_labels: [__name__]
                  regex: container_network_transmit_bytes_total|kubelet_running_container_count|container_memory_cache|namespace_memory:kube_pod_container_resource_limits:sum|kube_deployment_status_replicas_updated|kube_horizontalpodautoscaler_status_desired_replicas|kube_node_status_allocatable|kube_node_status_capacity|kube_job_failed|container_network_transmit_packets_dropped_total|kubelet_node_name|kubelet_volume_stats_inodes_used|kube_deployment_status_replicas_available|kube_statefulset_metadata_generation|container_fs_writes_bytes_total|kube_resourcequota|kubelet_volume_stats_available_bytes|namespace_cpu:kube_pod_container_resource_limits:sum|node_namespace_pod_container:container_memory_cache|node_namespace_pod_container:container_memory_working_set_bytes|kube_horizontalpodautoscaler_spec_min_replicas|kube_statefulset_status_replicas_updated|container_memory_working_set_bytes|kubelet_cgroup_manager_duration_seconds_count|kubelet_pleg_relist_duration_seconds_bucket|kube_horizontalpodautoscaler_spec_max_replicas|kube_daemonset_status_updated_number_scheduled|kubelet_server_expiration_renew_errors|kubelet_pod_start_duration_seconds_count|kube_node_info|node_namespace_pod_container:container_memory_swap|kube_deployment_spec_replicas|container_network_receive_bytes_total|storage_operation_duration_seconds_count|kubelet_runtime_operations_total|kubelet_runtime_operations_errors_total|kubelet_volume_stats_inodes|cluster:namespace:pod_memory:active:kube_pod_container_resource_limits|container_fs_reads_total|kube_deployment_metadata_generation|kubelet_certificate_manager_client_ttl_seconds|kube_horizontalpodautoscaler_status_current_replicas|container_network_transmit_packets_total|cluster:namespace:pod_cpu:active:kube_pod_container_resource_limits|cluster:namespace:pod_memory:active:kube_pod_container_resource_requests|container_fs_writes_total|kube_daemonset_status_desired_number_scheduled|kubelet_certificate_manager_client_expiration_renew_errors|cluster:namespace:pod_cpu:active:kube_pod_container_resource_requests|kube_deployment_status_observed_generation|kube_pod_status_phase|kube_statefulset_status_replicas|kube_pod_container_resource_limits|kubelet_pleg_relist_duration_seconds_count|container_cpu_cfs_throttled_periods_total|machine_memory_bytes|kube_pod_info|kubelet_running_pods|namespace_workload_pod:kube_pod_owner:relabel|kube_pod_container_resource_requests|kubelet_node_config_error|kubelet_running_containers|rest_client_requests_total|kube_daemonset_status_number_misscheduled|kubelet_pod_worker_duration_seconds_count|kube_daemonset_status_number_available|process_resident_memory_bytes|volume_manager_total_volumes|kubelet_volume_stats_capacity_bytes|kube_job_status_start_time|kubelet_certificate_manager_server_ttl_seconds|container_cpu_usage_seconds_total|kube_namespace_status_phase|kube_statefulset_status_update_revision|kube_node_status_condition|node_namespace_pod_container:container_memory_rss|container_memory_swap|kube_pod_container_status_waiting_reason|kube_node_spec_taint|namespace_workload_pod|container_fs_reads_bytes_total|namespace_cpu:kube_pod_container_resource_requests:sum|node_quantile:kubelet_pleg_relist_duration_seconds:histogram_quantile|process_cpu_seconds_total|kubelet_pleg_relist_interval_seconds_bucket|kubernetes_build_info|kube_replicaset_owner|node_namespace_pod_container:container_cpu_usage_seconds_total:sum_irate|kubelet_pod_worker_duration_seconds_bucket|container_cpu_cfs_periods_total|kube_job_status_active|kubelet_running_pod_count|storage_operation_errors_total|container_memory_rss|kube_statefulset_status_replicas_ready|container_network_receive_packets_total|kube_statefulset_status_current_revision|container_network_receive_packets_dropped_total|go_goroutines|kube_statefulset_status_observed_generation|kube_pod_owner|namespace_memory:kube_pod_container_resource_requests:sum|kube_statefulset_replicas|kubelet_cgroup_manager_duration_seconds_bucket|kube_daemonset_status_current_number_scheduled|kube_namespace_status_phase|container_cpu_usage_seconds_total|kube_pod_status_phase|kube_pod_start_time|kube_pod_container_status_restarts_total|kube_pod_container_info|kube_pod_container_status_waiting_reason|kube_daemonset.*|kube_replicaset.*|kube_statefulset.*|kube_job.*
                  action: keep
              relabel_configs:
                - replacement: kubernetes.default.svc.cluster.local:443
                  target_label: __address__
                - regex: (.+)
                  replacement: /api/v1/nodes/${1}/proxy/metrics/cadvisor
                  source_labels:
                    - __meta_kubernetes_node_name
                  target_label: __metrics_path__
              scheme: https
              tls_config:
                ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
                insecure_skip_verify: false
                server_name: kubernetes
            - bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
              job_name: integrations/kubernetes/kubelet
              kubernetes_sd_configs:
                - role: node
              metric_relabel_configs:
                - source_labels: [__name__]
                  regex: container_network_transmit_bytes_total|kubelet_running_container_count|container_memory_cache|namespace_memory:kube_pod_container_resource_limits:sum|kube_deployment_status_replicas_updated|kube_horizontalpodautoscaler_status_desired_replicas|kube_node_status_allocatable|kube_node_status_capacity|kube_job_failed|container_network_transmit_packets_dropped_total|kubelet_node_name|kubelet_volume_stats_inodes_used|kube_deployment_status_replicas_available|kube_statefulset_metadata_generation|container_fs_writes_bytes_total|kube_resourcequota|kubelet_volume_stats_available_bytes|namespace_cpu:kube_pod_container_resource_limits:sum|node_namespace_pod_container:container_memory_cache|node_namespace_pod_container:container_memory_working_set_bytes|kube_horizontalpodautoscaler_spec_min_replicas|kube_statefulset_status_replicas_updated|container_memory_working_set_bytes|kubelet_cgroup_manager_duration_seconds_count|kubelet_pleg_relist_duration_seconds_bucket|kube_horizontalpodautoscaler_spec_max_replicas|kube_daemonset_status_updated_number_scheduled|kubelet_server_expiration_renew_errors|kubelet_pod_start_duration_seconds_count|kube_node_info|node_namespace_pod_container:container_memory_swap|kube_deployment_spec_replicas|container_network_receive_bytes_total|storage_operation_duration_seconds_count|kubelet_runtime_operations_total|kubelet_runtime_operations_errors_total|kubelet_volume_stats_inodes|cluster:namespace:pod_memory:active:kube_pod_container_resource_limits|container_fs_reads_total|kube_deployment_metadata_generation|kubelet_certificate_manager_client_ttl_seconds|kube_horizontalpodautoscaler_status_current_replicas|container_network_transmit_packets_total|cluster:namespace:pod_cpu:active:kube_pod_container_resource_limits|cluster:namespace:pod_memory:active:kube_pod_container_resource_requests|container_fs_writes_total|kube_daemonset_status_desired_number_scheduled|kubelet_certificate_manager_client_expiration_renew_errors|cluster:namespace:pod_cpu:active:kube_pod_container_resource_requests|kube_deployment_status_observed_generation|kube_pod_status_phase|kube_statefulset_status_replicas|kube_pod_container_resource_limits|kubelet_pleg_relist_duration_seconds_count|container_cpu_cfs_throttled_periods_total|machine_memory_bytes|kube_pod_info|kubelet_running_pods|namespace_workload_pod:kube_pod_owner:relabel|kube_pod_container_resource_requests|kubelet_node_config_error|kubelet_running_containers|rest_client_requests_total|kube_daemonset_status_number_misscheduled|kubelet_pod_worker_duration_seconds_count|kube_daemonset_status_number_available|process_resident_memory_bytes|volume_manager_total_volumes|kubelet_volume_stats_capacity_bytes|kube_job_status_start_time|kubelet_certificate_manager_server_ttl_seconds|container_cpu_usage_seconds_total|kube_namespace_status_phase|kube_statefulset_status_update_revision|kube_node_status_condition|node_namespace_pod_container:container_memory_rss|container_memory_swap|kube_pod_container_status_waiting_reason|kube_node_spec_taint|namespace_workload_pod|container_fs_reads_bytes_total|namespace_cpu:kube_pod_container_resource_requests:sum|node_quantile:kubelet_pleg_relist_duration_seconds:histogram_quantile|process_cpu_seconds_total|kubelet_pleg_relist_interval_seconds_bucket|kubernetes_build_info|kube_replicaset_owner|node_namespace_pod_container:container_cpu_usage_seconds_total:sum_irate|kubelet_pod_worker_duration_seconds_bucket|container_cpu_cfs_periods_total|kube_job_status_active|kubelet_running_pod_count|storage_operation_errors_total|container_memory_rss|kube_statefulset_status_replicas_ready|container_network_receive_packets_total|kube_statefulset_status_current_revision|container_network_receive_packets_dropped_total|go_goroutines|kube_statefulset_status_observed_generation|kube_pod_owner|namespace_memory:kube_pod_container_resource_requests:sum|kube_statefulset_replicas|kubelet_cgroup_manager_duration_seconds_bucket|kube_daemonset_status_current_number_scheduled|kube_namespace_status_phase|container_cpu_usage_seconds_total|kube_pod_status_phase|kube_pod_start_time|kube_pod_container_status_restarts_total|kube_pod_container_info|kube_pod_container_status_waiting_reason|kube_daemonset.*|kube_replicaset.*|kube_statefulset.*|kube_job.*
                  action: keep
              relabel_configs:
                - replacement: kubernetes.default.svc.cluster.local:443
                  target_label: __address__
                - regex: (.+)
                  replacement: /api/v1/nodes/${1}/proxy/metrics
                  source_labels:
                    - __meta_kubernetes_node_name
                  target_label: __metrics_path__
              scheme: https
              tls_config:
                ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
                insecure_skip_verify: false
                server_name: kubernetes
            - job_name: integrations/kubernetes/kube-state-metrics
              kubernetes_sd_configs:
                - role: pod
              metric_relabel_configs:
                - source_labels: [__name__]
                  regex: container_network_transmit_bytes_total|kubelet_running_container_count|container_memory_cache|namespace_memory:kube_pod_container_resource_limits:sum|kube_deployment_status_replicas_updated|kube_horizontalpodautoscaler_status_desired_replicas|kube_node_status_allocatable|kube_node_status_capacity|kube_job_failed|container_network_transmit_packets_dropped_total|kubelet_node_name|kubelet_volume_stats_inodes_used|kube_deployment_status_replicas_available|kube_statefulset_metadata_generation|container_fs_writes_bytes_total|kube_resourcequota|kubelet_volume_stats_available_bytes|namespace_cpu:kube_pod_container_resource_limits:sum|node_namespace_pod_container:container_memory_cache|node_namespace_pod_container:container_memory_working_set_bytes|kube_horizontalpodautoscaler_spec_min_replicas|kube_statefulset_status_replicas_updated|container_memory_working_set_bytes|kubelet_cgroup_manager_duration_seconds_count|kubelet_pleg_relist_duration_seconds_bucket|kube_horizontalpodautoscaler_spec_max_replicas|kube_daemonset_status_updated_number_scheduled|kubelet_server_expiration_renew_errors|kubelet_pod_start_duration_seconds_count|kube_node_info|node_namespace_pod_container:container_memory_swap|kube_deployment_spec_replicas|container_network_receive_bytes_total|storage_operation_duration_seconds_count|kubelet_runtime_operations_total|kubelet_runtime_operations_errors_total|kubelet_volume_stats_inodes|cluster:namespace:pod_memory:active:kube_pod_container_resource_limits|container_fs_reads_total|kube_deployment_metadata_generation|kubelet_certificate_manager_client_ttl_seconds|kube_horizontalpodautoscaler_status_current_replicas|container_network_transmit_packets_total|cluster:namespace:pod_cpu:active:kube_pod_container_resource_limits|cluster:namespace:pod_memory:active:kube_pod_container_resource_requests|container_fs_writes_total|kube_daemonset_status_desired_number_scheduled|kubelet_certificate_manager_client_expiration_renew_errors|cluster:namespace:pod_cpu:active:kube_pod_container_resource_requests|kube_deployment_status_observed_generation|kube_pod_status_phase|kube_statefulset_status_replicas|kube_pod_container_resource_limits|kubelet_pleg_relist_duration_seconds_count|container_cpu_cfs_throttled_periods_total|machine_memory_bytes|kube_pod_info|kubelet_running_pods|namespace_workload_pod:kube_pod_owner:relabel|kube_pod_container_resource_requests|kubelet_node_config_error|kubelet_running_containers|rest_client_requests_total|kube_daemonset_status_number_misscheduled|kubelet_pod_worker_duration_seconds_count|kube_daemonset_status_number_available|process_resident_memory_bytes|volume_manager_total_volumes|kubelet_volume_stats_capacity_bytes|kube_job_status_start_time|kubelet_certificate_manager_server_ttl_seconds|container_cpu_usage_seconds_total|kube_namespace_status_phase|kube_statefulset_status_update_revision|kube_node_status_condition|node_namespace_pod_container:container_memory_rss|container_memory_swap|kube_pod_container_status_waiting_reason|kube_node_spec_taint|namespace_workload_pod|container_fs_reads_bytes_total|namespace_cpu:kube_pod_container_resource_requests:sum|node_quantile:kubelet_pleg_relist_duration_seconds:histogram_quantile|process_cpu_seconds_total|kubelet_pleg_relist_interval_seconds_bucket|kubernetes_build_info|kube_replicaset_owner|node_namespace_pod_container:container_cpu_usage_seconds_total:sum_irate|kubelet_pod_worker_duration_seconds_bucket|container_cpu_cfs_periods_total|kube_job_status_active|kubelet_running_pod_count|storage_operation_errors_total|container_memory_rss|kube_statefulset_status_replicas_ready|container_network_receive_packets_total|kube_statefulset_status_current_revision|container_network_receive_packets_dropped_total|go_goroutines|kube_statefulset_status_observed_generation|kube_pod_owner|namespace_memory:kube_pod_container_resource_requests:sum|kube_statefulset_replicas|kubelet_cgroup_manager_duration_seconds_bucket|kube_daemonset_status_current_number_scheduled|kube_namespace_status_phase|container_cpu_usage_seconds_total|kube_pod_status_phase|kube_pod_start_time|kube_pod_container_status_restarts_total|kube_pod_container_info|kube_pod_container_status_waiting_reason|kube_daemonset.*|kube_replicaset.*|kube_statefulset.*|kube_job.*
                  action: keep
              relabel_configs:
                - action: keep
                  regex: kube-state-metrics
                  source_labels:
                    - __meta_kubernetes_pod_label_app_kubernetes_io_name

    integrations:
      eventhandler:
        cache_path: /var/lib/agent/eventhandler.cache
        logs_instance: integrations
    logs:
      configs:
        - name: integrations
          clients:
            - url: https://logs-prod3.grafana.net/loki/api/v1/push
              basic_auth:
                username: *****
                password: *****
              external_labels:
                cluster: cloud
                job: integrations/kubernetes/eventhandler
          positions:
            filename: /tmp/positions.yaml
          target_config:
            sync_period: 10s
EOF
