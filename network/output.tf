output "vpc_id" {
  value = "${aws_vpc.this.id}"
}
output "sub_id" {
  value = ["${aws_subnet.public.*.id}"]
}
