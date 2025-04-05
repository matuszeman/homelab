```markdown
module "proxmox" {
    source = "github.com/example/proxmox-module"

    proxmox = {
        description = "Proxmox node configuration."
        node_name   = "example-node"
        api_url     = "https://example-proxmox-url:8006/"
        api_token   = "example-api-token"
    }

    vm_params = {
        example-vm-1 = {
            cpu_cores    = 2
            disk_size    = 20
            k8s_role     = "example-role"
            install_disk = "example-disk"
            ip_address   = "192.168.0.101"
            memory       = 2048
            tags         = ["example-tag"]
        }
        example-vm-2 = {
            cpu_cores    = 4
            disk_size    = 40
            k8s_role     = "example-role"
            install_disk = "example-disk"
            ip_address   = "192.168.0.102"
            memory       = 4096
            tags         = ["example-tag"]
        }
    }
}
```
