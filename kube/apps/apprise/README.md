# apprise

Deploys two services:

- **Apprise API** ([caronc/apprise](https://github.com/caronc/apprise-api)) — HTTP notification gateway supporting 80+ services (Home Assistant, Slack, Telegram, email, …)
- **Mailrise** ([YoRyan/mailrise](https://github.com/YoRyan/mailrise)) — SMTP-to-Apprise bridge; accepts email and forwards it as an Apprise notification

## Architecture

```
SMTP clients  ──→  mailrise :25  ──→  apprise-api :80  ──→  notification services
HTTP clients  ──────────────────────→  apprise-api :80  ──→  notification services
```

Mailrise is configured to route emails to the Apprise API running in the same release.

## Required configuration

Both `apprise.yml` and `mailrise.conf` are set to `null` by default and **must** be supplied via a values override.

### apprise.yml

Defines notification targets. See the [Apprise config YAML docs](https://github.com/caronc/apprise/wiki/config_yaml).

```yaml
app:
  configs:
    app:
      content:
        apprise.yml:
          version: 1
          urls:
            - hassio://hassio.local:80/TOKEN:
                tag: platform-admins
```

### mailrise.conf

Maps recipient email addresses to Apprise notification URLs. See the [Mailrise docs](https://github.com/YoRyan/mailrise#configuration).

```yaml
smtp:
  configs:
    app:
      templated: true
      content:
        mailrise.conf:
          listen:
            port: 8025
          configs:
            "*@*":
              urls:
                - "apprise://{{.Release.Name}}:80/apprise/?tags=platform-admins"
```

## Sending a test notification via HTTP

```bash
apprise -vv --body="Test Message" --title="Test title" \
   "apprise://localhost:8000/apprise/?tags=platform-admins"
```

