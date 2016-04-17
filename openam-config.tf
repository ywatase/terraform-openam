resource "aws_instance" "openam-config" {
  ami = "ami-2a1fad59"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.fleet-street-internal.name}"]
  key_name = "${var.key_name}"
  depends_on = [
    "aws_instance.openam-server",
    "aws_instance.opendj-server",
    "aws_eip.ip"]

  connection {
    user = "core"
    private_key = "${var.key_path}"
  }

  tags {
    Name = "openam-config"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /etc/systemd/system/docker.service.d",
      "sudo systemctl daemon-reload",
      "sudo docker pull rustemsuniev/openam-config",
      "sudo docker run --add-host openam.example.com:${aws_instance.openam-server.0.private_ip} -e OPENDJ_SERVER=${aws_instance.opendj-server.private_ip} rustemsuniev/openam-config",
      "sudo docker run --add-host openam.example.com:${aws_instance.openam-server.1.private_ip} -e OPENDJ_SERVER=${aws_instance.opendj-server.private_ip} rustemsuniev/openam-config"
    ]
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = "8"
    delete_on_termination = true
  }
}
