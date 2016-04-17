resource "aws_instance" "opendj-server" {
  ami = "ami-2a1fad59"
  instance_type = "t2.micro"
  security_groups = [
    "${aws_security_group.fleet-street-internal.name}"]
  key_name = "${var.key_name}"
  #count = 1

  connection {
    user = "core"
    private_key = "${var.key_path}"
  }

  tags {
    Name = "opendj-server"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /etc/systemd/system/docker.service.d",
      "sudo systemctl daemon-reload",
      "sudo docker pull rustemsuniev/opendj",
      "sudo docker run -d -p 389:389 -p 4444:4444 -p 636:636 rustemsuniev/opendj"
    ]
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = "8"
    delete_on_termination = true
  }
}