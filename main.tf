# Creation of the AWS ressource (base resource to access the API)
provider "aws"  {
	shared_credentials_file = "%UserProfile%\\.aws\\credentials"
	profile                 = "terraform-test"
	region                  = "us-east-1"
	
	# We can make it faster by skipping some of the following steps by setting it to true
	skip_get_ec2_platforms      = false
	skip_metadata_api_check     = false
	skip_region_validation      = false
	skip_credentials_validation = false
	skip_requesting_account_id  = false
}

# Creation of our key-pair in AWS
resource "aws_key_pair" "terraform-keys" {
  key_name = "terraform-test-keys"
  public_key = "${file("${path.root}/terraform-test-keys.pub")}"
}

# To define firewall rules to our server we need to create a security group:
resource "aws_security_group" "vakt_test_sgroup" {
  name = "vakt_test"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
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

    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Now let's create the EC2 instance and perform a base installation of Nginx to it:
resource "aws_instance" "vakt_test" {
  ami           = "ami-f4cc1de2"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.vakt_test_sgroup.id}"]
  associate_public_ip_address = true
  
  connection {
    # The default username for our Ubuntu AMI
    user = "ubuntu"
    type        = "ssh"
    private_key = "${file("${path.root}/terraform-test-keys")}"
  }
  key_name = "${aws_key_pair.terraform-keys.id}"

  
  tags {
    Name = "vakt_test-public"
  }
  

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install nginx",
      "sudo service nginx start"
    ]
  }
}

# Create and assign our Elastic IP to the instance so we don't have a new IP every single time we perform a small change to the instance's configurations
resource "aws_eip" "ip" {
  instance = "${aws_instance.vakt_test.id}"
}

# Print out the Public IP Address
output "Public IP Address" {
  value = "${aws_eip.ip.public_ip}"
}

# Print out the Public DNS Address
output "Public DNS Address" {
  value = "${aws_eip.ip.public_dns}"
}