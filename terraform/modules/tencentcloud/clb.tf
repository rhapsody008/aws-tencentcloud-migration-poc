resource "tencentcloud_clb_instance" "zy_test_clb" {
  network_type = "OPEN"
  clb_name     = "zy_test_clb"

  vpc_id    = tencentcloud_vpc.zy_test_tencentcloud_vpc.id
}

resource "tencentcloud_clb_listener" "zy_test_clb_listener" {
  clb_id        = tencentcloud_clb_instance.zy_test_clb.id
  listener_name = "zy_test_clb_listener"
  port          = 80
  protocol      = "HTTP"
}

resource "tencentcloud_clb_listener_rule" "zy_test_clb_listener_rule" {
  listener_id = tencentcloud_clb_listener.zy_test_clb_listener.listener_id
  clb_id      = tencentcloud_clb_instance.zy_test_clb.id

  health_check_interval_time = 30
  health_check_health_num    = 2
  health_check_unhealth_num  = 2
  health_check_time_out      = 5
  health_check_type          = "HTTP"
  health_check_http_path     = "/"

  domain = tencentcloud_clb_instance.zy_test_clb.clb_vips[0]
  url    = "/"
}
