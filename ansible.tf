resource "local_file" "hosts_inventory" {
  content = templatefile("${path.module}/hosts.tftpl", {
    webservers = yandex_compute_instance.count
    databases  = values(yandex_compute_instance.each)
    storage    = [yandex_compute_instance.storage]
  })

  filename = "${path.module}/hosts.ini"
}
