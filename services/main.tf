resource "aws_security_group" "web" {
  name        = "Allow http"
  description = "Allow all http traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]

  }
  vpc_id = "${var.vpc_id}"

}

resource "aws_instance" "webs" {
  count = "${var.num_instancias}"
  ami = "${var.ami}"
  instance_type = "${var.tipo_instancia}"
  vpc_security_group_ids = ["${aws_security_group.web.id}"]
  subnet_id = "${element(var.sub_id, count.index)}"
  key_name = "test"

  root_block_device {
    delete_on_termination = "true"
    volume_type = "gp2"
    volume_size = 20
  }
  tags {
    Name = "WEB-${count.index}"
  }
}
/*
resource "dns_a_record_set" "this" {
  count = "${var.num_instancias}"
  zone = "inkafarma.internal."
  name = "WEB-${count.index}"
  addresses = ["${element(aws_instance.webs.*.private_ip, count.index)}"]
  ttl = 300
}*/
