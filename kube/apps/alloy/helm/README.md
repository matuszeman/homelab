# Alloy Helm Chart

Umbrella chart for deploying [Grafana Alloy](https://grafana.com/docs/alloy/latest/) to Kubernetes.

## Features

- Grafana Alloy telemetry collector with Kubernetes pod discovery
- Secret management via [idp-app](https://github.com/matuszeman/charts)
- Optional clustering for distributed deployments

## Examples

### Pod Logs to Stdout

```bash
helm install alloy . -f tests/values/pod-logs-stdout.yaml
```

### Grafana Cloud Logs

```bash
helm install alloy . -f tests/values/grafana-cloud.yaml
```

See [`values.yaml`](values.yaml) for all configuration options.
