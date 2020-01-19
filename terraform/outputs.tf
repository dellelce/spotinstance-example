output "instance_ips" {
  value = ["${aws_spot_instance_request.spot-t0.*.public_ip}"]
}
output "spot_status" {
  value = ["${aws_spot_instance_request.spot-t0.*.spot_bid_status}"]
}

