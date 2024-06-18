locals {
  ws_vars = "checkov"
}

resource "google_container_cluster" "standard-cluster" {
  # https://stackoverflow.com/questions/68550763/gke-terraformed-cluster-release-channel-setting
  # https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-kubernetes-policies/ensure-use-of-binary-authorization
  # enable_binary_authorization = false CKV_GCP_66 DEPRECIATED!! - Check: CKV_GCP_66: "Ensure use of Binary Authorization"
  depends_on              = [google_compute_network.vpc]
  enable_kubernetes_alpha = false
  enable_legacy_abac      = false

  # https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-kubernetes-policies/manage-kubernetes-rbac-users-with-google-groups-for-gke
  # Check: CKV_GCP_65: "Manage Kubernetes RBAC users with Google Groups for GKE"
  authenticator_groups_config {
    security_group = "gcp-security-admins@nzastudios.com"
  }

  # https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-kubernetes-policies/ensure-shielded-gke-nodes-are-enabled
  enable_shielded_nodes = true # Check: CKV_GCP_71: "Ensure Shielded GKE Nodes are Enable and set to true"

  # https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-kubernetes-policies/enable-vpc-flow-logs-and-intranode-visibility
  enable_intranode_visibility = true # Check: CKV_GCP_61: "Enable VPC Flow Logs and Intranode Visibility"
  initial_node_count          = 0
  location                    = var.location
  logging_service             = "logging.googleapis.com/kubernetes"
  monitoring_service          = "monitoring.googleapis.com/kubernetes"
  name                        = "checkov-cluster-gke"
  network                     = "projects/${var.project_id}/global/networks/checkov-dev-vpc"
  project                     = var.project_id
  subnetwork                  = "projects/${var.project_id}/regions/${var.region}/subnetworks/checkov-dev-subnet"
  # https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-kubernetes-policies/bc-gcp-kubernetes-13
  # Check: CKV_GCP_21: "Ensure Kubernetes Clusters are configured with Labels"
  resource_labels = {
    environment = "production"
    team        = "backend"
  }
  release_channel {
    channel = var.release_channel
  }

  ip_allocation_policy {
    #cluster_ipv4_cidr_block = local.ws_vars["cidr-block"]
    cluster_secondary_range_name  = "subnet-pods"
    services_secondary_range_name = "subnet-services"
  }


  addons_config {

    horizontal_pod_autoscaling {
      disabled = false
    }

    http_load_balancing {
      disabled = false
    }

    # CHECKOV FIX 2 - Enable network policy config disabled is not set to true
    # Network policy rules can ensure that Pods and Services in a given namespace cannot access other Pods or Services in a different namespace
    # https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-kubernetes-policies/bc-gcp-kubernetes-7

    network_policy_config {
      disabled = false
    }
  }

  database_encryption {
    state = "DECRYPTED"
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "01:00"
    }
  }

  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  node_pool {
    initial_node_count = 1
    name               = "scoped-two-cpu-high-mem-preemptible"
    node_locations = [
      var.location,
    ]

    autoscaling {
      max_node_count = 30
      min_node_count = 0
    }

    management {
      auto_repair  = true
      auto_upgrade = true
    }

    node_config {
      disk_size_gb      = 100
      disk_type         = "pd-standard"
      guest_accelerator = []
      image_type        = "COS"
      labels            = {}
      local_ssd_count   = 0
      machine_type      = "n1-highmem-4"
      # Check: CKV_GCP_69: "Ensure the GKE Metadata Server is Enabled" in node_config
      # https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-kubernetes-policies/ensure-the-gke-metadata-server-is-enabled
      metadata = {
        "disable-legacy-endpoints" = "true"
        workload_metadata_config   = "GKE_METADATA_SERVER"
      }
      oauth_scopes = [
        "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring",
        "https://www.googleapis.com/auth/ndev.clouddns.readwrite",
        "https://www.googleapis.com/auth/service.management.readonly",
        "https://www.googleapis.com/auth/servicecontrol",
        "https://www.googleapis.com/auth/trace.append",
      ]
      preemptible     = true
      service_account = "default"
      tags            = []
      taint           = []

      shielded_instance_config {
        enable_integrity_monitoring = true
        enable_secure_boot          = false
      }
    }

    upgrade_settings {
      max_surge       = 1
      max_unavailable = 0
    }
  }

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  vertical_pod_autoscaling {
    enabled = true
  }

  # https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-kubernetes-policies/bc-gcp-kubernetes-12
  # Enable Master authorized networks block to allow whitelisting of specific CIDR ranges hosting Nodes or POD 
  # POD workloads in those allowed ranges will be allowed to acecess the cluster master endpoint using HTTPS ( TLS )
  # Check: CKV_GCP_20: "Ensure master authorized networks is set to enabled in GKE clusters"
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "10.10.0.0/24"
      display_name = "gke-checkov-sub"
    }
    #   workload_identity_config {
    #     identity_namespace = "${local.ws_vars["project-id"]}.svc.id.goog"
    #   }
  }
}