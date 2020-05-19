output "public_ip" {
  description = "Access Hashi Ui with port 3000"
  value       = "${aws_instance.master[0].*.public_ip}"
}
