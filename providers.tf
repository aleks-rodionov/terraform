# Configure the AWS Provider
provider "aws" {
  region = var.aws-region
  access_key = file("../Credentials/AWS/access_key.txt")
  secret_key = file("../Credentials/AWS/secret_key.txt")
}

provider "google" {
  credentials = file("../Credentials/GCP/redhat-295420-769720b20d99.json")
  project     = "redhat-295420"
  region      = var.gcp-region
}
