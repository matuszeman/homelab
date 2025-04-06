```markdown
```hcl
module "proxmox" {
    source = "./modules/talos-cluster-proxmox"

    proxmox = {
        node_name   = "example-node"
    }

    talos = {
        cluster_endpoint = "https://example-endpoint:6443"
        cluster_name     = "example-cluster"
        version          = "vX.Y.Z"
        image_hash       = "example-image-hash"
    }

    vm_params = {
        vm-1 = {
            cpu_cores    = 2
            disk_size    = 10
            role         = "controlplane"
            ip_address   = "192.168.1.1"
            gateway      = "192.168.1.254"
            memory       = 1024
            tags         = ["example", "controlplane"]
        }
        vm-2 = {
            cpu_cores    = 2
            disk_size    = 20
            role         = "controlplane"
            ip_address   = "192.168.1.2"
            gateway      = "192.168.1.254"
            memory       = 2048
            tags         = ["example", "controlplane"]
        }
        vm-3 = {
            cpu_cores    = 2
            disk_size    = 20
            role         = "controlplane"
            ip_address   = "192.168.1.3"
            gateway      = "192.168.1.254"
            memory       = 2048
            tags         = ["example", "controlplane"]
        }
        vm-4 = {
            cpu_cores    = 1
            disk_size    = 20
            role         = "worker"
            ip_address   = "192.168.1.4"
            gateway      = "192.168.1.254"
            memory       = 3072
            tags         = ["example", "worker"]
        }
    }
}
```
