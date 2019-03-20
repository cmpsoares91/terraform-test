provider "aws"  {
	shared_credentials_file = "%UserProfile%\\.aws\\credentials"
	profile                 = "terraform-test"
	region                  = "us-east-1"
	
	# Make it faster by skipping something
	skip_get_ec2_platforms      = true
	skip_metadata_api_check     = true
	skip_region_validation      = true
	skip_credentials_validation = true
	skip_requesting_account_id  = true
}

resource "aws_key_pair" "terraform-keys" {
  key_name = "terraform-test-keys"
  public_key = "${file("${path.root}/terraform-test-keys.pub")}"
}

resource "aws_security_group" "vakt_test_sgroup" {
  name = "vakt_test"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = "22"
    to_port   = "22"
    protocol  = "tcp"

    # To keep this example simple, we allow incoming SSH requests from any IP. In real-world usage, you should only
    # allow SSH requests from trusted servers, such as a bastion host or VPN server.
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "vakt_test" {
  ami           = "ami-f4cc1de2"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.vakt_test_sgroup.id}"]
  associate_public_ip_address = true
  
  connection {
    # The default username for our AMI
    user = "ubuntu"
    type        = "ssh"
    private_key = "${file("${path.root}/terraform-test-keys")}"

    # The connection will use the local SSH agent for authentication.
  }
  key_name = "${aws_key_pair.terraform-keys.id}"

  
  tags {
    Name = "vakt_test-public"
  }
  
  # We run a remote provisioner on the instance after creating it.
  # In this case, we just install nginx and start it. By default,
  # this should be on port 80
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install nginx",
      "sudo service nginx start"
    ]
  }
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.vakt_test.id}"
}

output "Public IP Address" {
  value = "${aws_eip.ip.public_ip}"
}

output "Public DNS Address" {
  value = "${aws_eip.ip.public_dns}"
}