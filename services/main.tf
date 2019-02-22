

resource "aws_instance" "front_end" {
  count = "${var.num_instancias_front}"
  ami = "${var.ami}"
  instance_type = "${var.tipo_instancia}"
  vpc_security_group_ids = ["${var.sec_frontend_id}", "${var.sec_internal_id}"]
  subnet_id = "${element(var.subpublic_id, count.index)}"
  key_name = "marco-test"

  root_block_device {
    delete_on_termination = "true"
    volume_type = "gp2"
    volume_size = 20
  }
  tags {
    Name = "MGMT-${count.index}"
  }
}

resource "aws_instance" "back_end" {
  count = "${var.num_instancias_back}"
  ami = "${var.ami}"
  instance_type = "${var.tipo_instancia}"
  vpc_security_group_ids = ["${var.sec_backend_id}", "${var.sec_internal_id}"]
  subnet_id = "${element(var.subprivate_id, count.index)}"
  key_name = "marco-test"

  root_block_device {
    delete_on_termination = "true"
    volume_type = "gp2"
    volume_size = 20
  }
  tags {
    Name = "BACK-${count.index}"
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
