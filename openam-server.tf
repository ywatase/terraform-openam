resource "aws_instance" "openam-server" {
  ami = "ami-2a1fad59"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.internal.name}"]
  key_name = "${var.key_name}"
  count = 2

  connection {
    user = "core"
    private_key = "${var.key_path}"
  }

  tags {
    Name = "openam-server-${concat("server",count.index+1)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /etc/systemd/system/docker.service.d",
      "sudo mkdir -p /root/openam",
      "sudo systemctl daemon-reload",
      "sudo docker pull rustemsuniev/openam",
      "sudo docker run --name=${var.container-name.openam} -h ${concat("server",count.index+1)}.example.com -d -p 8080:8080 -v /root/openam:/root/openam rustemsuniev/openam",
      "sudo docker pull rustemsuniev/ssoadm",
      "sudo docker run --name=${var.container-name.ssoadm} --add-host ${concat("server",count.index+1)}.example.com:${self.private_ip} -d -v /root/openam:/root/openam rustemsuniev/ssoadm"
    ]
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = "8"
    delete_on_termination = true
  }
}