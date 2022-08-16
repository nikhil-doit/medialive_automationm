resource "aws_security_group" "sg_allow_ssh" {
  name        = "sg_allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id = "vpc-0368dc1afbe9b7ffb"
  #vpc_id      = module.vpc-us-east-1.vpc_id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #cidr_blocks = var.sg-ssh
    self = true
  }

   ingress {
    from_port = 445
    to_port   = 445
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #cidr_blocks = var.sg-ssh
    description = "Remote desk login"
  }

   ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
     #cidr_blocks = var.sg-ssh
    description = "https"
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
     #cidr_blocks = var.sg-ssh
    description = "http"
  }

   ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
     #cidr_blocks = var.sg-ssh
    description = "adport"
  }

   ingress {
    #description = "SSH from VPC"
    from_port   = "-1"
    to_port     = "-1"
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
     #cidr_blocks = var.sg-ssh
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_allow_ssh", created_by = "terraform"
  }
}

output "sg_ssh_id" {
  description = "SG_SSH ID"
  value = aws_security_group.sg_allow_ssh.id
}

resource "aws_instance" "gw_instance" {
  ami                         = "ami-044238dc0ff5b8208"
  instance_type               = "m5.xlarge"
  associate_public_ip_address = true
  subnet_id                   = "subnet-090c4e0411c0d81e1"
  vpc_security_group_ids = ["sg-0345ddfc7bf0a9b47"]
  tags = {
    created_by = "terraform"
  }
}

resource "aws_ebs_volume" "sgw_ebs" {
  availability_zone = "us-east-1a"
  size              = "200"
  type              = "gp3"
  encrypted         = false
  tags = {
    created_by = "terraform"
  }
}

resource "aws_volume_attachment" "sgw_attach" {
  device_name  = "/dev/sdh"
  volume_id    = aws_ebs_volume.sgw_ebs.id
  instance_id  = aws_instance.gw_instance.id
  force_detach = false
}
/*
resource "aws_storagegateway_gateway" "file_sgw" {
  gateway_ip_address = "44.192.120.87"
  gateway_name       = "test_gw"
  gateway_timezone   = "GMT"
  gateway_type       = "FILE_S3"
}

data "aws_storagegateway_local_disk" "sgw_ebs" {
  disk_node   = "/dev/sdh"
  #disk_node   = data.aws_volume_attachment.sgw_attach.de
  gateway_arn = aws_storagegateway_gateway.file_sgw.arn
}

resource "aws_storagegateway_cache" "gw_cache" {
  disk_id     = data.aws_storagegateway_local_disk.sgw_ebs.disk_id
  gateway_arn = aws_storagegateway_gateway.file_sgw.arn
}

*/