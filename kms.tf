# -------------------------------------------------------------- #
# CMEK CRYPTO KMS AND KEY RING
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_template
# -------------------------------------------------------------- #

resource "google_kms_key_ring" "crypto-ndr-keyring" {
  name     = "corelightx-lab-key"
  project  = var.project_id
  location = "global"
}

resource "google_kms_crypto_key" "crypto-ndr-key" {
  name     = "cryptox-lab-keyring"
  key_ring = google_kms_key_ring.crypto-ndr-keyring.id
  #rotation_period = "100000s"
  purpose = "ASYMMETRIC_SIGN"

  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_crypto_key#algorithm

  lifecycle {
    prevent_destroy = false
  }
  # https://cloud.google.com/kms/docs/reference/rest/v1/CryptoKeyVersionAlgorithm
  # https://cloud.google.com/kms/docs/algorithms?authuser=2
  version_template {
    algorithm        = "EC_SIGN_P384_SHA384"
    protection_level = "HSM"
  }
}

resource "google_project_iam_member" "iam_encrypt_decrypt" {
  project = var.project_id
  role    = "roles/cloudkms.cryptoKeyEncrypter"
  member  = "serviceAccount:terraform-jenkins@development-337317.iam.gserviceaccount.com"
}

resource "google_kms_crypto_key_iam_binding" "key_iam_binding" {
  crypto_key_id = resource.google_kms_crypto_key.crypto-ndr-key.id
  role          = "roles/cloudkms.cryptoKeyEncrypter"
  members = [
    "serviceAccount:terraform-jenkins@development-337317.iam.gserviceaccount.com",
  ]
}





# resource "google_kms_key_ring" "gke_keys" {
#   project  = var.project_id
#   name     = "gke-keys"
#   location = var.region
# }

# resource "google_kms_crypto_key" "secrets_encryption" {
#   name     = "secrets-encryption"
#   key_ring = google_kms_key_ring.gke_keys.id

#   version_template {
#     algorithm        = "GOOGLE_SYMMETRIC_ENCRYPTION"
#     protection_level = "HSM"
#   }
# }

# resource "google_kms_crypto_key_iam_binding" "gke_secrets_encryption" {
#   crypto_key_id = google_kms_crypto_key.secrets_encryption.id
#   role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

#   members = [
#     "serviceAccount:service-${google_project.orchestrator.number}@container-engine-robot.iam.gserviceaccount.com"
#   ]
# }
