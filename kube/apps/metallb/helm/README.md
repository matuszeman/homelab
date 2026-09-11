Release notes: https://metallb.universe.tf/release-notes/

# MetalLB Configuration

This chart configures MetalLB with `IPAddressPool` and `L2Advertisement` resources.

## IPAddressPools

Define one or more IP address pools. Each key under `ipAddressPools` becomes a separate `IPAddressPool` resource.

```yaml
ipAddressPools:
  my-pool:
    addresses:
      - "192.168.1.240-192.168.1.250"
```

See [`values.yaml`](values.yaml) for all available options.

## L2 Advertisements

Define one or more L2 advertisements. Each key under `l2Advertisements` becomes a separate `L2Advertisement` resource.

```yaml
l2Advertisements:
  my-ad:
    enabled: true
```

See [`values.yaml`](values.yaml) for all available options.
