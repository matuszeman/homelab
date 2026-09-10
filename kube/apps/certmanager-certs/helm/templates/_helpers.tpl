{{- define "idp-app.solvers" }}
{{- $ctx := .ctx }}
{{- $values := $ctx.Values }}
{{- $issuer := .issuer }}
{{- if $issuer.solvers }}
{{- range $solverId := $issuer.solvers.dns01 }}
{{- $solver := index $values.solvers $solverId }}
- dns01:
    cloudflare:
      email: {{ $solver.email | quote }}
      apiTokenSecretRef:
        name: {{ include "idp-app.configName" (list $ctx "secrets") }}
        key: cloudflare_api_token
{{- end }}
{{- end }}
{{- end }}
