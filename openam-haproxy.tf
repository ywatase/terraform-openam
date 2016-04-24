resource "aws_instance" "openam-haproxy" {
  ami = "ami-2a1fad59"
  instance_type = "t2.micro"
  security_groups = [
    "${aws_security_group.external.name}",
    "${aws_security_group.internal.name}"]
  key_name = "${var.key_name}"

  connection {
    user = "core"
    private_key = "${var.key_path}"
  }

  tags {
    Name = "openam-haproxy"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir /etc/haproxy/",
      "sudo chown core:core /etc/haproxy"
    ]
  }

  provisioner "file" {
    source = "${path.module}/files/haproxy.cfg"
    destination = "/etc/haproxy/haproxy.cfg"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sed -i 's/OAM_1_PRIVATE_IP/${aws_instance.openam-server.0.private_ip}/g' /etc/haproxy/haproxy.cfg",
      "sudo sed -i 's/OAM_2_PRIVATE_IP/${aws_instance.openam-server.1.private_ip}/g' /etc/haproxy/haproxy.cfg",
      "sudo mkdir -p /etc/systemd/system/docker.service.d",
      "sudo systemctl daemon-reload",
      "sudo docker pull haproxy:${var.haproxy_version}",
      "sudo docker run -h openam.example.com -d --name my-running-haproxy -v /etc/haproxy/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro -p 80:80 -p 81:81 haproxy:${var.haproxy_version}"
    ]
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = "8"
    delete_on_termination = true
  }
}

output "openam_haproxy_public_ip" {
  value = "${aws_eip.ip.public_ip}"
}