# terraform-openam

Terraform scripts to provision openam, opendj and haproxy docker images to AWS

Docker images:

https://hub.docker.com/u/rustemsuniev/

Base image is CoreOS t2.micro

1. Install Terraform - https://www.terraform.io/
2. Update variables.tf with the information about your private AWS key
3. Update variables.tf with your public IP
4. Copy the private key to this folder and change the permissions on the file. Example `chmod 400 mykey.pem`
5. Run: `terraform apply`
6. After provision is complete you should be able to see the public IP address of the haproxy
7. Add this IP to your hosts file. Example 51.48.56.132 openam.example.com
8. Type http://openam.example.com/openam to go to openam admin console

To ssh into a box use: `ssh -i "mykey.pem" core@PUBLIC_IP_OF_THE_BOX`

To get access to a docker image use: `docker exec -it CONTAINER_NAME bash`

To clear everythig run: `terraform destroy --force`
