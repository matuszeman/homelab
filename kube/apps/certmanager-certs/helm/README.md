# CertManager Certificates Helm Chart

This chart provides certificate management configuration for Kubernetes clusters using cert-manager.

## Configuration

### Gateway Reference Grants

Gateway Reference Grants allow gateways in other namespaces to reference TLS secrets managed by cert-manager. This is required when using Gateway API with certificates stored in a different namespace than the gateway.

#### Configuration Options

Configure reference grants through the `secretsReferenceGrants` section in `values.yaml`:

```yaml
secretsReferenceGrants:
  my-gateway:
    kind: Gateway           # Type of resource (Gateway, HTTPRoute, etc.)
    namespace: traefik-system  # Namespace where the gateway is located
    labels: {}              # Additional labels for the ReferenceGrant
    annotations: {}         # Additional annotations for the ReferenceGrant
```

#### Configuration Fields

| Field | Type | Description | Default |
|-------|------|-------------|---------|
| `kind` | string | The kind of resource requesting access | `Gateway` |
| `namespace` | string | The namespace where the requesting resource is located | Required |
| `labels` | object | Additional labels for the ReferenceGrant resource | `{}` |
| `annotations` | object | Additional annotations for the ReferenceGrant resource | `{}` |

#### Example Configuration

```yaml
secretsReferenceGrants:
  # Allow Traefik gateway to reference certificates
  traefik-gateway:
    kind: Gateway
    namespace: traefik-system
    labels:
      app: traefik
    annotations:
      description: "Allow Traefik gateway to access certificates"
  
  # Allow Istio gateway to reference certificates
  istio-gateway:
    kind: Gateway
    namespace: istio-system
    labels:
      app: istio
  
  # Allow HTTPRoute to reference certificates
  api-routes:
    kind: HTTPRoute
    namespace: api-system
    labels:
      tier: api
```

This configuration creates ReferenceGrant resources that allow:
- `traefik-gateway` in `traefik-system` namespace to access secrets
- `istio-gateway` in `istio-system` namespace to access secrets  
- `api-routes` HTTPRoute in `api-system` namespace to access secrets

#### Generated Resources

Each entry in `secretsReferenceGrants` generates a ReferenceGrant with the name pattern: `{key}-secrets-ref-grant`

For example, `traefik-gateway` would create: `traefik-gateway-secrets-ref-grant`

#### Use Case

This is particularly useful when:
1. Your certificates are managed in a dedicated namespace (e.g., `cert-manager`)
2. Your gateways are in different namespaces (e.g., `traefik-system`, `istio-system`)
3. You need to reference the TLS secrets across namespace boundaries

The ReferenceGrant provides the necessary RBAC permissions for cross-namespace secret access in Gateway API.
