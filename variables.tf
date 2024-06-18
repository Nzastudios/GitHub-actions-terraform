variable "project_id" {
  type        = string
  description = "The Google Cloud Project Id"
  default     = "development-337317"
}

variable "organization" {
  description = "Path to a service account credentials file with rights to run the Google Zeek Automation. If this file is absent Terraform will fall back to Application Default Credentials."
  type        = string
  default     = "nzastudios.com"
}

variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

variable "gke_num_nodes" {
  default     = 2
  description = "number of gke nodes"
}

# https://discuss.hashicorp.com/t/cant-find-the-example-of-release-channel-for-gke/15732
# https://stackoverflow.com/questions/68550763/gke-terraformed-cluster-release-channel-setting
variable "release_channel" {
  type    = string
  default = "STABLE"
}

variable "region" {
  type    = string
  default = "europe-west2"
}

variable "location" {
  description = "The location (region or zone) to host the cluster in"
  type        = string
  default     = "europe-west2"
}

variable "env" {
  default     = "dev"
  description = "Environment: dev"
  type        = string
}

variable "dev-env" {
  default     = "dev"
  description = "Environment: dev"
  type        = string
}

variable "stage-env" {
  default     = "staging"
  description = "Environment: staging"
  type        = string
}

variable "prod-env" {
  default     = "prod"
  description = "Environment: prod"
  type        = string
}