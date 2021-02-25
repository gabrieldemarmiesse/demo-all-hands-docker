terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "eu-west-1"
}


resource "aws_security_group" "terraform_example_gabriel_all_hands" {

  name = "terraform_example_gabriel_all_hands"

  # open bar everywhere
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # can connect to anything from the inside
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "tf-gabriel-ssh-key" {
  key_name   = "tf-gabriel-ssh-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDLvVT5oF260mUmeghX64IDQpeF02GPOVbZv4m4zclQj3tLW5cGGdArtqHADkiDZr60bC6iIpnkjusc86DLsos2K5aPsmaB48TV4ueWTcqxTSpB/VV/EyPlV4FAXocMS0C1qr+9qq2pEyDCNk7km/xeVcd9Pg4BBw8R28eDJYx52ucKxC5NdnT9qFeO2nJcghXM9nTM10KFbXngUkhUaf4+i78u3Co37O+NrKMQM2yU0Y7xTZadeJkfY644uchr2ihnBprQaOLkSNL4kLJE8zb9SUj/1SOvbc6z6MCO50aNYYuIZ7to5XnaJyLb7A4RxAAIkTBpd6DF+i3PTlR+7TKb root@DESKTOP-J3EQHEE"
}

resource "aws_instance" "example" {
  ami             = "ami-022e8cc8f0d3c52fd"
  instance_type   = "g4dn.xlarge"
  key_name        = "tf-gabriel-ssh-key"
  security_groups = ["terraform_example_gabriel_all_hands"]

  root_block_device {
    volume_size = 80
  }

  provisioner "remote-exec" {
    inline = [
      "sudo -s",
      "cd /root",
      "git clone https://github.com/gabrieldemarmiesse/demo-all-hands-docker.git",
      "cd demo-all-hands-docker",
      "bash ec2-install.sh",
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = self.public_ip
      private_key = file("~/.ssh/id_rsa")
    }
  }
  tags = {
    Name = "GPUDemoExampleInstance"
  }
}

output "address_ip" {
  value = aws_instance.example.public_ip
}