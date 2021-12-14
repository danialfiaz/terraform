data "template_file" "mytemp" {
  template = "${file("${path.module}/template_file/data.sh")}"
  vars = {
    rds_endpoint = "${var.rds_endpoint}"
    name_wp         = "${var.name_wp}"
    username_wp     = "${var.username_wp}"
    password_wp     = "${var.password_wp}"
  }
}

resource "aws_instance" "wordpress" {
  ami             = var.ami
  instance_type   = var.instance_type
  key_name        = var.key_name
  count = 1
  subnet_id       = "${element(var.subnet_id, count.index)}"
  security_groups = [aws_security_group.wordpress_sg.id]
  user_data       = "${data.template_file.mytemp.rendered}"
  associate_public_ip_address = true

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  tags = {
    Name = "wordpress"
  }
}

resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress_sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description     = "incoming traffic for ec2"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "name" = "wordpress_sg"
  }
}