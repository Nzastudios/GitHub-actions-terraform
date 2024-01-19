variable "project_id" {
  type        = string
  description = "The Google Cloud Project Id"
  default     = "development-337317"
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