variable "default_uptime" {
  description = "Specifies default uptime for all the resources that don't override it. Documentation at https://codeberg.org/hjacobs/kube-downscaler#uptime-downtime-spec. Default is 'always up'."
  type        = string
  default     = "Mon-Sun 00:00-24:00 Europe/Berlin"
}

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
