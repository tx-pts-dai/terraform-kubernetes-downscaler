# Documentation at https://codeberg.org/hjacobs/kube-downscaler

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.0"
    }
  }
}


locals {
  downscaler_name = "downscaler"
  downscaler_labels = {
    app = local.downscaler_name
  }

  dry_run = var.dry_run ? ["--dry-run"] : []
  args    = concat(var.custom_args, local.dry_run)

}

resource "kubernetes_namespace_v1" "this" {
  metadata {
    name = local.downscaler_name
  }
}

resource "kubernetes_service_account_v1" "this" {
  metadata {
    name      = local.downscaler_name
    namespace = kubernetes_namespace_v1.this.metadata[0].name
  }
}

resource "kubernetes_cluster_role_v1" "this" {
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

resource "kubernetes_cluster_role_binding_v1" "this" {
  metadata {
    name = local.downscaler_name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.this.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.this.metadata[0].name
    namespace = kubernetes_namespace_v1.this.metadata[0].name
  }
}

resource "kubernetes_deployment_v1" "this" {
  metadata {
    name      = local.downscaler_name
    namespace = kubernetes_namespace_v1.this.metadata[0].name
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
        service_account_name = kubernetes_service_account_v1.this.metadata[0].name
        node_selector        = var.node_selector

        dynamic "toleration" {
          for_each = var.tolerations
          content {
            effect   = toleration.value.effect
            key      = toleration.value.key
            operator = toleration.value.operator
            value    = toleration.value.value
          }
        }

        container {
          image = "hjacobs/kube-downscaler:${var.image_version}"
          name  = local.downscaler_name
          args  = local.args

          resources {
            limits = {
              memory = "150Mi"
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
