# Configure the AWS Provider

provider "aws" {
  region = "us-east-1"
  access_key = "$file(../AWS Credentials/access_key.txt)"
  secret_key = "$file(../AWS Credentials/secret_key.txt)"
}

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
    private_key = file("../terraformEC2access.pem")
    host = self.public_ip
  }
}

output "instance_ip_addr" {
  value = aws_instance.my_awesome_ec2.public_ip
}
