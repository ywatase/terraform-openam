# terraform-openam

Terraform scripts to provision openam, opendj and haproxy docker images to AWS

Docker images:

https://hub.docker.com/u/rustemsuniev/

Base image is CoreOS t2.micro

1. Install Terraform - https://www.terraform.io/
2. Update variables.tf with the information about your private AWS key
3. Update variables.tf with your public IP
4. Copy the private key to this folder.
5. Run terraform apply