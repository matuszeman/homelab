# homelab-modules

## Upgrading Helm Charts

Charts live under `kube/apps/<app>/helm/`. Before upgrading any chart dependency:

1. Check the chart's `README.md` for release note links and any upgrade-specific guidance.
2. Review breaking changes and deprecations for all versions between current and target.