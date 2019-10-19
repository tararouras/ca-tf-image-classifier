local kp =
  (import 'kube-prometheus/kube-prometheus.libsonnet') +
  (import 'kube-prometheus/kube-prometheus-kubespray.libsonnet') +
  (import 'kube-prometheus/kube-prometheus-node-ports.libsonnet') +
  // Uncomment the following imports to enable its patches
  // (import 'kube-prometheus/kube-prometheus-anti-affinity.libsonnet') +
  // (import 'kube-prometheus/kube-prometheus-managed-cluster.libsonnet') +
  // (import 'kube-prometheus/kube-prometheus-static-etcd.libsonnet') +
  // (import 'kube-prometheus/kube-prometheus-thanos-sidecar.libsonnet') +
  {
    _config+:: {
      namespace: 'monitoring',
      // append extra configuration in prometheus adapter config (config.yaml)
      prometheusAdapter+:: {
        config+:: (importstr 'prometheus-adapter-extra-conf.yaml'),
      },
    },
    prometheusRules+:: {
      groups+: [
        {
          name: 'edge-server-tf-record-rules',
          interval: '30s',
          rules: [
            {
              record: 'edge_server_request_rate_for_30',
              expr: 'rate(django_http_requests_total_by_view_transport_method_total{view="edge-server-metrics"} [120s])',
            },
            {
              record: 'edge_server_latency_for_30',
              expr: 'rate(django_http_requests_latency_seconds_by_view_method_sum{view="edge-server-metrics"} [120s])/rate(django_http_requests_latency_seconds_by_view_method_count{view="edge-server-metrics"} [120s])',
            },
            {
              record: 'edge_server_cpu_for_30',
              expr: 'rate(container_cpu_usage_seconds_total{pod=~"edge-server-tf.*", container="edge-server-tf"}[120s])',
            },
            {
              record: 'edge_server_memory',
              expr: 'container_memory_working_set_bytes{pod=~"edge-server-tf.*", container="edge-server-tf"}',
            },
            {
              record: 'edge_server_pod_count',
              expr: 'count(count by (pod) (django_http_requests_total_by_view_transport_method_total{view="edge-server-metrics"}))',
            },
          ],
        },
      ],
   },
  };

{ ['00namespace-' + name]: kp.kubePrometheus[name] for name in std.objectFields(kp.kubePrometheus) } +
{ ['0prometheus-operator-' + name]: kp.prometheusOperator[name] for name in std.objectFields(kp.prometheusOperator) } +
{ ['node-exporter-' + name]: kp.nodeExporter[name] for name in std.objectFields(kp.nodeExporter) } +
{ ['kube-state-metrics-' + name]: kp.kubeStateMetrics[name] for name in std.objectFields(kp.kubeStateMetrics) } +
{ ['alertmanager-' + name]: kp.alertmanager[name] for name in std.objectFields(kp.alertmanager) } +
{ ['prometheus-' + name]: kp.prometheus[name] for name in std.objectFields(kp.prometheus) } +
{ ['prometheus-adapter-' + name]: kp.prometheusAdapter[name] for name in std.objectFields(kp.prometheusAdapter) } +
{ ['grafana-' + name]: kp.grafana[name] for name in std.objectFields(kp.grafana) }
