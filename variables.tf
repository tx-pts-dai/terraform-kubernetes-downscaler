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
