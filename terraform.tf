
resource "aws_instance" "jenkins1" {
  ami = "ami-0f5ee92e2d63afc18"
  instance_type = "t3.micro"
  key_name = "Ashok"
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]

  tags = {
    Name = "jenkins1"
  }
}
#creating security group 
resource "aws_security_group" "ec2_security_group" {
    name = "ec2 security group"
    description = "allow access on ports 8080 and 22"
 
 ingress {
    description = "https proxy access"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
 }

 ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
 }
 egress {
    from_port     = 0
    to_port       = 0
    protocol      = -1
    cidr_blocks   = ["0.0.0.0/0"]
 }
 tags = {
    Name = "jenkins server security group"
 }
}

#an empty resource block
resource "null_resource"  "name" {

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/PROJECT/Ashok.pem")
    host        = aws_instance.jenkins1.public_ip
  }

 # copy the install_jenkins.sh file from your computer to the ec2 instance
  provisioner "file" {
    source        = "install_jenkins.sh"
    destination   = "/tmp/install_jenkins.sh"
  }
 
 # set permissions and run the install_jenins.sh file

  provisioner "remote-exec" {
    inline = [
        "sudo chmod +x /tmp/install_jenkins.sh",
        "sh /tmp/install_jenkins.sh",
    ]
  }

  # wait for ec2 to be created
  depends_on = [aws_instance.jenkins1]
}

#print the url of the jenkins server
output "website_url" {
    value = join ("", ["http://", aws_instance.jenkins1.public_dns, ":", "8080"])
}