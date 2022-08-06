locals {
  ami_id = "ami-068257025f72f470d"
  vpc_id = "vpc-06b65447cfc13ad97"
  ssh_user = "ubuntu"
  key_name = "LMSKey"
  private_key_path = "/home/ubuntu/ansible-nginx/LMSKey.pem"
}

provider "aws" {
  profile = "lmsproject"
  region = "ap-south-1"
}

resource "aws_security_group" "demoaccess" {
  name = "demoaccess"
  vpc_id = local.vpc_id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami = local.ami_id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.demoaccess.id]
  key_name = local.key_name

  tags = {
    Name = "Demo test"
  }

  connection {
    type = "ssh"
    host = self.public_ip
    user = local.ssh_user
    private_key = file(local.private_key_path)
    timeout = "4m "
  }

  provisioner "remote-exec" {
    inline = [
      	"echo ==========CONNECTED TO REMOTE SYSTEM===========",
	"touch /home/ubuntu/demo-file-from-terraform.txt"
    ]
  }

  provisioner "local-exec" {
    command = "echo server_hostname: ${self.public_ip} >> /home/ubuntu/ansible-nginx/group_vars/all && echo ${self.public_ip} > hosts"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i hosts --user ${local.ssh_user} --private-key ${local.private_key_path} playbook.yml"
  }
  
}

output "instance_ip" {
  value = aws_instance.web.public_ip
}
