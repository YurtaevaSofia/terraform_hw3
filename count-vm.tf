resource "yandex_compute_instance" "count" {
  depends_on = [yandex_compute_instance.each]

  count = 2

  name        = "web-${count.index + 1}"
  hostname    = "web-${count.index + 1}"
  platform_id = "standard-v1"
  zone        = var.default_zone

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = "network-hdd"
      size     = 15
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${local.ssh_public_key}"
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  allow_stopping_for_update = true
}
