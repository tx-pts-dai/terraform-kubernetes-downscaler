locals {
  nginx_labels = {
    app = "nginx"
  }
}

resource "kubernetes_deploymentss_v1" "shutdown_at_night" {
  metadata {
    name   = "nginx"
    labels = local.nginx_labels

    # Here's the instructions for the downscaler to scale down every day at 10pm and scale back up at 5am
    # Use "Mon-Fri" instead of "Mon-Sun" to shut down completely during the weekends
    annotations = {
      "downscaler/downscale-period" = "Mon-Sun 20:00-20:01 Europe/Zurich"
      "downscaler/upscale-period"   = "Mon-Sun 05:00-05:01 Europe/Zurich"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = local.nginx_labels
    }

    template {
      metadata {
        labels = local.nginx_labels
      }

      spec {
        container {
          name  = "nginx"
          image = "nginx:1.14.2"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}
