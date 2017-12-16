variable "major_version" { default = "16.04" }

# Login credentials
provider "aws" {
   access_key = ""
   secret_key = ""
   region = "us-east-1"
}

# Get latest LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-${var.major_version}-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

#Register key with AWS
resource "aws_key_pair" "example1_key" {
  key_name = "example1_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzDdS2oTbPqzJL8q1nG0AC42jIzL2FTArXDplKcFXloNB+C3qp9vg9vDXx3poLKq5htUogLdxeX9jKhMt2rpphZ3spr5cxiZsdUmHL1pv2NZezs1VZTRPyE6d2GfR4/bDevsSti1S64Z9pZw0C+IoMPew0Hs7DNPtR27BmIF5jMnHKxOU1Ce4D+Q9M55/PtFNnKBCQ4CQ9QzIgJXoNCcSLvNiRbO9FY3F5TrhjtH1Q05QiCSZJIpodGrXNdHt2OZKEgU3FDK1HZ4oEJNatUk2Mk9SxusIOyXENw5X4VhB2BY7zvWQCy3SMqMWSafFax7LeXj/AtbJtIpsYDKcUQU+J root@instance-2"
#Get ID for default VPC
}
data "aws_vpc" "default_vpc" {
  default = 1
}

#Create security group
resource "aws_security_group" "allow_client1" {
  name = "allow_client1"
  description = "Allow 22, 80, 443 only to 5.148.106.4/32"
  vpc_id      = "${data.aws_vpc.default_vpc.id}"
  
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["5.148.106.4/32"]
   }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["5.148.106.4/32"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["5.148.106.4/32"]
  }
}

#Create instance
resource "aws_instance" "example1" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  key_name = "example1_key"
  security_groups = ["allow_client1"]
  
  tags {
    Name = "example1"
    Name = "client1"
  }
}
