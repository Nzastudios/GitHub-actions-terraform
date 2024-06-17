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

variable "region" {
  type    = string
  default = "europe-west2"
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