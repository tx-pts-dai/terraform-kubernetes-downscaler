terraform {
  required_version = "~> 1.5"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

module "downscaler" {
  source = "../"
}

module "downscaler_karpenter" {
  source = "../"

  node_selector = {
    "provisioner-group" = "default"
  }

  tolerations = [{
    effect   = "NoSchedule"
    key      = "karpenter.sh/default"
    operator = "Exists"
  }]
}
