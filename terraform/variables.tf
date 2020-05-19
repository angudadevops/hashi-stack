variable "access_key" {
  default = "KFGH8GAja0JHDgaLJ"
}
variable "secret_key" {
  default = "Hahs5HGDkjah9hdhannsG5jagdj4vgsgGKH"  
}
variable "key_name" {
  default = "anurag-aws"
}
variable "worker_count" {
  default = 2
}
variable "master_count" {
  default = 3
}
variable "region" {
  default = "us-west-2"
}
variable "ami" {
  default = "ami-06cb848001176ed5a"
}
variable "node_instance_type" {
  default = "t2.micro"
}

variable "master_instance_type" {
  default = "t2.micro"
}
variable "master_tags" {
  default = "master"
}

variable "worker_tags" {
  default = "worker"
}

variable "private_key_path" {
  default = "~/Downloads/AWS/anurag-aws.pem"
}

variable "state" {
  default = "running"
}
