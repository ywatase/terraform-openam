resource "aws_eip" "ip" {
  instance = "${aws_instance.openam-haproxy.id}"
}
