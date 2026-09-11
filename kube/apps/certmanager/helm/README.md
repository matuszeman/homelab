# certmanager

Umbrella chart for [cert-manager](https://cert-manager.io) with CRDs enabled.

Release notes: https://cert-manager.io/docs/releases/

## Required configuration

`global.leaderElection.namespace` must be set to the namespace where cert-manager is deployed ([example](tests/values/required.yaml)):

```yaml
global:
  leaderElection:
    namespace: certmanager
```
