/*
# A template file - create am EC2. Not needed for S3 transfer.
# Configure the AWS resources
resource "aws_instance" "my_awesome_ec2" {
  ami           = "ami-096fda3c22c1c990a"
  instance_type = "t2.micro"
  key_name = "terraformEC2access"
  vpc_security_group_ids  = [aws_security_group.allow_ssh.id]

  # install prerequisites
  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }

  # copy over python scripts
  provisioner "file" {
    source      = "demo_file_transfer.py"
    destination = "/tmp/demo_file_transfer.py"
  }

  provisioner "file" {
    source      = "file_transfer.py"
    destination = "/tmp/file_transfer.py"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install nano",
      "chmod +x /tmp/script.sh",
      "chmod +x /tmp/demo_file_transfer.py",
      "/tmp/script.sh args",
    ]
  }

  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = file("../Credentials/Terraform/terraformEC2access.pem")
    host = self.public_ip
  }
}

output "instance_ip_addr" {
  value = aws_instance.my_awesome_ec2.public_ip
}
*/
