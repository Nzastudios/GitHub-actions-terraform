
# https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-general-policies/ensure-gcp-artifact-registry-repositories-are-encrypted-with-customer-supplied-encryption-keys-csek
# GCP Artifact Registry repositories are not encrypted with Customer Supplied Encryption Keys (CSEK)
resource "google_artifact_registry_repository" "project_florence_repo" {
  provider = google-beta

  location      = var.region
  project       = var.project_id
  repository_id = "platform_florence_repo"
  description   = "Artifact Registry for Improbable Defence Platform images."
  format        = "DOCKER"
  kms_key_name  = google_kms_crypto_key.crypto-ndr-key.name
  depends_on    = [google_kms_crypto_key.crypto-ndr-key]
}

resource "google_project_iam_custom_role" "artifact_registry_policy_access" {
  role_id     = "artifactRegistryPolicyAccess"
  project     = var.project_id
  title       = "Allow terraform_gke to provision IAM rules for repository"
  description = "Expands the permissions given to get/create IAM policies to ARs"
  permissions = [
    "artifactregistry.repositories.getIamPolicy",
    "artifactregistry.repositories.setIamPolicy"
  ]
}

resource "google_artifact_registry_repository_iam_member" "terraformer_gke_iam_policy_access_artifact_registry" {
  provider = google-beta

  project    = var.project_id
  location   = google_artifact_registry_repository.project_florence_repo.location
  repository = google_artifact_registry_repository.project_florence_repo.name
  role       = google_project_iam_custom_role.artifact_registry_policy_access.name
  member     = "serviceAccount:terraform-jenkins@development-337317.iam.gserviceaccount.com"
  #member     = "serviceAccount:${data.google_service_account.terraformer_gke.email}" # Allow terraform_gke to provision IAM rules for repository
}
