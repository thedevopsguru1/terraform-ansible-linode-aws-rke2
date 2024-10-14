terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "~> 1.0"
    }
  }

  required_version = ">= 0.12"
}


provider "linode" {
  token = var.linode_token  # Your Linode API token
}



# Create the master instance
resource "linode_instance" "master" {
  count       = 1
  label       = "master-${count.index + 1}"
  region      = "us-east"  # Change to your desired region
  type        = "g6-standard-2"  # Adjust the type as needed
  image       = "linode/centos-stream9"  # Specify CentOS 9 image



  # SSH key for access
  authorized_keys = [trimspace(file("~/.ssh/aws_key.pub"))]  # Path to your public key
}

# Create the worker instances
resource "linode_instance" "worker" {
  count       = 3
  label       = "worker-${count.index + 1}"
  region      = "us-east"  # Change to your desired region
  type        = "g6-standard-2"  # Adjust the type as needed
  image       = "linode/centos-stream9"  # Specify CentOS 9 image

 

  # SSH key for access
  authorized_keys = [trimspace(file("~/.ssh/aws_key.pub"))]  # Path to your public key
}

# Output the public IPs of the instances
output "master_ips" {
  value = linode_instance.master[*].ipv4
}

output "worker_ips" {
  value = linode_instance.worker[*].ipv4
}


