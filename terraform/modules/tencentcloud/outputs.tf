output "tencentcloud_clb_vips" {
  description = "The VIPs of the CLB instance"
  value       = tencentcloud_clb_instance.zy_test_clb.clb_vips
}

output "tencentcloud_clb_domain" {
  description = "The Domain name of the CLB instance"
  value       = tencentcloud_clb_instance.zy_test_clb.domain
}
