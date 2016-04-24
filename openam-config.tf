resource "aws_instance" "openam-config" {
  ami = "ami-2a1fad59"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.internal.name}"]
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
      "sudo docker run --add-host openam.example.com:${aws_instance.openam-haproxy.private_ip} --add-host server1.example.com:${aws_instance.openam-server.0.private_ip} -e OPENDJ_SERVER=${aws_instance.opendj-server.0.private_ip} -e SERVER_TYPE=${var.openam_server_type.master} rustemsuniev/openam-config",
      "sudo docker run --add-host openam.example.com:${aws_instance.openam-haproxy.private_ip} --add-host server2.example.com:${aws_instance.openam-server.1.private_ip} -e OPENDJ_SERVER=${aws_instance.opendj-server.1.private_ip} -e SERVER_TYPE=${var.openam_server_type.slave} rustemsuniev/openam-config"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo docker stop ${var.container-name.openam}",
      "sudo docker start ${var.container-name.openam}",
      "TRY=0;until [ $(curl -s -o /dev/null -w \"%{http_code}\" \"http://localhost:8080/openam/isAlive.jsp\" ) == 200 ] || [ $TRY -gt 15 ]; do echo \"Waiting for openam server\";sleep 5;let \"TRY++\";done",
      "docker exec -it ${var.container-name.ssoadm} sh /opt/ssoadm/ssoadm-install.sh"
    ]
    connection {
      user = "core"
      type = "ssh"
      host = "${aws_instance.openam-server.0.public_ip}"
      private_key = "${var.key_path}"
    }
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = "8"
    delete_on_termination = true
  }
}
