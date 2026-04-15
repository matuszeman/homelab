# certmanager-certs

Helm chart for managing cert-manager `Issuer` and `Certificate` resources, with optional API credentials via a sealed/plain secret and Gateway API `ReferenceGrant` support.

## Features

- Let's Encrypt (production + staging) `Issuer` resources
- `Certificate` resources referencing those issuers
- Cloudflare (or any DNS01/HTTP01) solver configuration via a managed secret
- `ReferenceGrant` resources for cross-namespace secret access (Gateway API)

## Let's Encrypt issuers

Full example: [tests/example/issuers.yaml](tests/example/issuers.yaml)

```yaml
issuers:
  letsencrypt:
    enabled: true
    email: "admin@example.com"
    solvers:
      - dns01:
          cloudflare:
            email: "admin@example.com"
            apiTokenSecretRef:
              name: certmanager-certs-config-secrets
              key: cloudflare-api-token

  configs:
    secrets:
      content:
        cloudflare-api-token: "<token>"
```

Enable `letsencrypt-staging` the same way for testing before switching to production.

## Certificates

Full example: [tests/example/certificates.yaml](tests/example/certificates.yaml)

```yaml
certificates:
  my-cert:
    enabled: true
    commonName: example.com
    dnsNames:
      - example.com
      - "*.example.com"
    issuer: letsencrypt   # or letsencrypt-staging
```

Each entry creates a `Certificate` resource. The generated TLS secret has the same name as the map key (`my-cert`).

## Gateway ReferenceGrants

Full example: [tests/example/reference_grants.yaml](tests/example/reference_grants.yaml)

Required when a Gateway in another namespace needs to reference TLS secrets from this chart's namespace.

```yaml
secretsReferenceGrants:
  traefik-gateway:
    kind: Gateway
    namespace: traefik-system
```

Creates a `ReferenceGrant` named `traefik-gateway-secrets` allowing the specified namespace to read `Secret` resources.

Optional fields: `labels`, `annotations`. `kind` defaults to `Gateway`.
