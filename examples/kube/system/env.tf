locals {
  public_ip = "TODO"
  letsencrypt_email = "TODO"
  cloudflare_email = "TODO"

  # ./sealed-secrets
  sealed_secrets = {
    cloudflare_api_token = "TODO"
    git_private_key = "TODO"
  }

  argocd = {
    domain = "argocd.${var.networks.default.domain}"
    repo_creds = {
      github = {
        type = "git"
        url  = "git@github.com:user"
        sealedSecrets = {
          sshPrivateKey = local.sealed_secrets.git_private_key
        }
      }
      bitbucket = {
        type = "git"
        url  = "git@bitbucket.org:user"
        sealedSecrets = {
          sshPrivateKey = local.sealed_secrets.git_private_key
        }
      }
    }
    repos = {
      github-user-repo = {
        type = "git"
        url = "git@github.com:user/repo.git"
      }
      # https://bitbucket.org/account/settings/ssh-keys/
      # ssh-keygen -t ed25519 -b 4096 -C "your@email.com" -f ~/.ssh/homelab
      bitbucket-user-repo = {
        type = "git"
        url = "git@bitbucket.org:user/repo.git"
      }
    }
  }

  traefik_private = {
    metallb_ip = var.networks.default.static_ips["traefik-private"].address
  }
  traefik_public = {
    metallb_ip = var.networks.default.static_ips["traefik-public"].address
  }
}