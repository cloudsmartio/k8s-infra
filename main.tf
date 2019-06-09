# https://www.terraform.io/docs/providers/google/r/container_cluster.html
resource "google_container_cluster" "primary" {
  name     = "my-gke-cluster"
  location = "us-central1"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true

  # The number of nodes to create in this cluster (not including the Kubernetes master).
  initial_node_count = 1

  # Using node_locations to limit count of zones and hence count of nodes
  node_locations = [
    "us-central1-a"
  ]

  master_auth {
    # Setting an empty username and password explicitly disables basic auth
    username = ""
    password = ""

    # Whether client certificate authorization is enabled for this cluster.
    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

# https://www.terraform.io/docs/providers/google/r/container_node_pool.html
resource "google_container_node_pool" "primary_preemptible_nodes" {
  name = "my-node-pool"

  # The location (region or zone) in which the cluster resides
  location = "us-central1"
  cluster  = "${google_container_cluster.primary.name}"

  node_count = 1

  node_config {
    # https://cloud.google.com/blog/products/containers-kubernetes/cutting-costs-with-google-kubernetes-engine-using-the-cluster-autoscaler-and-preemptible-vms
    preemptible = true

    machine_type = "n1-standard-1"

    # The metadata key/value pairs assigned to instances in the cluster.
    metadata = {
      # https://cloud.google.com/kubernetes-engine/docs/how-to/protecting-cluster-metadata
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
