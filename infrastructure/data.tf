data "template_file" "user_data" {
  template = file("user-data.sh")

  vars = {
    http_port = var.server_port
    release_version  = var.release_version
  }
}
