# Documentation at https://codeberg.org/hjacobs/kube-downscaler

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}


locals {
  downscaler_name = "downscaler"
  downscaler_labels = {
    app = local.downscaler_name
  }
}

resource "kubernetes_namespace_v1" "kube_downscaler" {
  metadata {
    name = local.downscaler_name
  }
}

resource "kubernetes_service_account_v1" "kube_downscaler" {
  metadata {
    name      = local.downscaler_name
    namespace = kubernetes_namespace_v1.kube_downscaler.metadata[0].name
  }
}

resource "kubernetes_cluster_role_v1" "kube_downscaler" {
  metadata {
    name = local.downscaler_name
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "namespaces"]
    verbs      = ["get", "watch", "list"]
  }

  rule {
    api_groups = ["apps"]
    resources  = ["deployments", "statefulsets"]
    verbs      = ["get", "watch", "list", "update", "patch"]
  }

  rule {
    api_groups = ["autoscaling"]
    resources  = ["horizontalpodautoscalers"]
    verbs      = ["get", "watch", "list", "update", "patch"]
  }

  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["get", "create", "watch", "list", "update", "patch"]
  }
}

resource "kubernetes_cluster_role_binding_v1" "kube_downscaler" {
  metadata {
    name = local.downscaler_name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.kube_downscaler.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.kube_downscaler.metadata[0].name
    namespace = kubernetes_namespace_v1.kube_downscaler.metadata[0].name
  }
}

resource "kubernetes_deployment_v1" "kube_downscaler" {
  metadata {
    name      = local.downscaler_name
    namespace = kubernetes_namespace_v1.kube_downscaler.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = local.downscaler_labels
    }

    template {
      metadata {
        labels = local.downscaler_labels
      }

      spec {
        container {
          image = "hjacobs/kube-downscaler:${var.image_version}"
          name  = local.downscaler_name
          args = concat([
            "--default-uptime='${var.default_uptime}'", # Always up if not specifically mentioned on the workload itself
          ], var.dry_run ? ["--dry-run"] : [])

          resources {
            limits = {
              memory = "100Mi"
            }
            requests = {
              cpu    = "5m"
              memory = "100Mi"
            }
          }

          security_context {
            read_only_root_filesystem = true
            run_as_non_root           = true
            run_as_user               = 1000
          }
        }
      }
    }
  }
}
