provider "aws" {
  region = "us-east-1"
  access_key = ""
  secret_key = ""
}

resource "aws_instance" "web" {
  count         = 3
  ami           = "ami-0bb84b8ffd87024d8" # Example Amazon Linux 2 AMI, replace with your desired AMI
  instance_type = "t2.micro"
  key_name      = "MyKeyPair" # The name of the key pair created in CloudShell

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y python3
              touch /home/ec2-user/hello-world.txt
              echo "Hello, World!" > /home/ec2-user/hello-world.txt
              EOF

  tags = {
    Name = "WebServer-${count.index}"
  }
}

output "instance_ips" {
  value = aws_instance.web.*.public_ip
}
