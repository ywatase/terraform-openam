resource "aws_instance" "openam-server" {
  ami = "ami-2a1fad59"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.fleet-street-internal.name}"]
  key_name = "${var.key_name}"
  count = 2

  connection {
    user = "core"
    private_key = "${var.key_path}"
  }

  tags {
    Name = "openam-server"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /etc/systemd/system/docker.service.d",
      "sudo systemctl daemon-reload",
      "sudo docker pull rustemsuniev/openam",
      "sudo docker run -d -p 8080:8080 rustemsuniev/openam"
    ]
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = "8"
    delete_on_termination = true
  }
}