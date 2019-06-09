provider "google" {
  version     = "~> 2.8"
  credentials = "${file("./.creds/serviceaccount.json")}"
  project     = "credible-list-239813"
  region      = "us-central1"
}

provider "google-beta" {
  version     = "~> 2.8"
  credentials = "${file("./.creds/serviceaccount.json")}"
  project     = "credible-list-239813"
  region      = "us-central1"
}