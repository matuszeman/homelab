# csi-proxmox

Umbrella Helm chart deploying the [Proxmox CSI Plugin](https://github.com/sergelogvinov/proxmox-csi-plugin) with cluster config managed via [idp-app](https://matuszeman.github.io/charts).

## Example

```yaml
app:
  nodeSelector:
    node-role.kubernetes.io/control-plane: ""
  tolerations:
    - key: node-role.kubernetes.io/control-plane
      effect: NoSchedule
  storageClass:
    - name: proxmox-data-xfs
      storage: data
      reclaimPolicy: Delete
      fstype: xfs

config:
  configs:
    secret:
      secret: {}
      content:
        config.yaml:
          clusters:
            - url: https://proxmox.example.com:8006/api2/json
              token_id: "kubernetes-csi@pve!csi"
              token_secret: "changeme"
              region: my-cluster
```
