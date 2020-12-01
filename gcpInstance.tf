// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
 byte_length = 8
}

// Optional - add SSH Public Key in Project Meta Data
// Can be added on the account level and
// desciminted to participating projects
/*
resource "google_compute_project_metadata_item" "ssh-keys" {
  key   = "ssh-keys"
  value = "user_name${file("../Credentials/GCP/legacy_key.pub")}"
}
*/

// A single Compute Engine instance
resource "google_compute_instance" "default" {
 name         = "rhel-vm-${random_id.instance_id.hex}"
 machine_type = "f1-micro"
 zone         = "us-west1-a"

 boot_disk {
    initialize_params {
      image = "rhel-7-v20201112"
    }
 }

// Make sure rhel is installed on all new instances for later steps
metadata_startup_script = "yum update"

 network_interface {
   network = "default"

   access_config {
     // Include this section to give the VM an external ip address
   }
 }

 # install prerequisites
 provisioner "file" {
   source      = "script.sh"
   destination = "/tmp/script.sh"
 }

 # copy over python scrip that performs S3 transfer
 provisioner "file" {
   source      = "upload_file.py"
   destination = "/tmp/upload_file.py"
 }

 # copy over the AWS credenials file
 provisioner "file" {
   source      = "credentials"
   destination = "/tmp/credentials"
 }

 # upload and initiate the transfer script
 # remove excta characters that might have been added by Windows editor
 provisioner "remote-exec" {
   inline = [
     "chmod +x /tmp/upload_file.py",
     "tr -d '\r' < /tmp/script.sh > /tmp/scriptClean.sh",
     "chmod +x /tmp/scriptClean.sh",
     "sh /tmp/scriptClean.sh ${var.log_file_name} ${var.bucket_name}",
   ]
 }

 connection {
   type = "ssh"
   user = "${var.gcp_user_name}"
   private_key = file("../Credentials/GCP/legacy_key")
   host = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
 }
}

# We create a public IP address for our google compute instance to utilize
resource "google_compute_address" "static" {
  name = "vm-public-address"
}

// A variable for extracting the external IP address of the instance
output "ip" {
 value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
}
