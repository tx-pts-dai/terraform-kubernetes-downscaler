variable "dry_run" {
  description = "Whether to use the `--dry-run` CLI flag to block the downscaler from introducing any change."
  type        = bool
  default     = false
}

variable "image_version" {
  description = "Version of the 'kube-downscaler' image deployed as a controller"
  type        = string
  default     = "23.2.0"
}

variable "node_selector" {
  description = "Node selector specifics for the Kubernetes deployment"
  type        = map(string)
  default     = {}
}

variable "tolerations" {
  description = "List of tolerations for the Kubernetes deployment"
  type = list(object({
    effect   = optional(string)
    key      = optional(string)
    operator = optional(string)
    value    = optional(string)
  }))
  default = []
}
