variable "project" {}
variable "platform" {}
variable "team" {}
variable "ssh_public_key" {}
variable "ami" {
  default = "ami-3b261642"
}

resource "aws_instance" "bastion" {
  ami = "${var.ami}"
  instance_type = "t2.micro"
  tags {
    Name = "${var.platform}_bastion"
    Project = "${var.project}"
    Platform = "${var.platform}"
    Team = "${var.team}"
  }
  key_name = "${aws_key_pair.key_pair.key_name}"
  vpc_security_group_ids = [
    "${aws_security_group.dmz_sg.id}"]
  subnet_id = "${aws_subnet.public_subnet_1.id}"
}

resource "aws_eip" "bastion_public_ip" {}

resource "aws_eip_association" "bastion_public_ip_association" {
  instance_id = "${aws_instance.bastion.id}"
  allocation_id = "${aws_eip.bastion_public_ip.id}"
}

resource "aws_key_pair" "key_pair" {
  key_name = "${var.project}_${var.platform}"
  public_key = "${var.ssh_public_key}"
}
