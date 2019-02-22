output "vpc_id" {
  value = "${aws_vpc.this.id}"
}
output "subpublic_id" {
  value = ["${aws_subnet.public.*.id}"]
}

output "subprivate_id" {
  value = ["${aws_subnet.private.*.id}"]
}


output "sec_backend_id" {
  value = ["${aws_security_group.backend.id}"]
}
output "sec_frontend_id" {
  value = ["${aws_security_group.web.id}"]
}
output "sec_db_id" {
  value = ["${aws_security_group.database.id}"]
}

output "sec_internal_id" {
  value = ["${aws_security_group.internal.id}"]
}
