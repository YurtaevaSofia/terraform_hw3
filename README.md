# Домашнее задание - Управляющие конструкции в Terraform - Юртаева Софья Вячеславовна

Ветка: `terraform-03`

## Задание 1

Изучен и запущен базовый проект: сеть `yandex_vpc_network`, подсеть `yandex_vpc_subnet`,
группа безопасности `yandex_vpc_security_group.example` с динамическими ingress/egress
правилами (`dynamic` + `for_each` по переменным `security_group_ingress` / `security_group_egress`).

Скриншот входящих правил группы безопасности:
<img width="1680" height="1050" alt="Screenshot 2026-09-21 at 20 52 08" src="https://github.com/user-attachments/assets/d03e8ba8-2a87-4f0d-b1d4-970745bea0c7" />

## Задание 2

- `count-vm.tf` — две одинаковые ВМ `web-1` и `web-2`, создаются мета-аргументом `count`
  (`name = "web-${count.index + 1}"`), подключены к группе безопасности из Задания 1.
- `for_each-vm.tf` — две ВМ баз данных `main` и `replica` с разными cpu/ram/disk_volume,
  созданы через `for_each` по общей переменной `each_vm` (`list(object({vm_name, cpu, ram, disk_volume}))`).
- ВМ из `count-vm.tf` создаются после ВМ из `for_each-vm.tf` через `depends_on = [yandex_compute_instance.each]`.
- SSH-ключ читается один раз через `file(var.ssh_public_key_path)` в `local.ssh_public_key` (`main.tf`)
  и используется в `metadata` всех ВМ проекта.

## Задание 3

- `disk_vm.tf` — 3 одинаковых диска по 1 ГБ (`yandex_compute_disk.extra`, `count = 3`).
- Одиночная ВМ `storage` (без `count`/`for_each`) подключает все 3 диска через
  `dynamic "secondary_disk"` с `for_each = yandex_compute_disk.extra`.

## Задание 4

- `ansible.tf` + `hosts.tftpl` — динамический inventory-файл через `templatefile`,
  собирает 3 группы (`webservers`, `databases`, `storage`) из ВМ заданий 2.1, 2.2 и 3.2 (5 ВМ).
- В каждую запись инвентаря добавлена переменная `fqdn`.

Скриншот содержимого сгенерированного `hosts.ini`:

<img width="495" height="182" alt="Screenshot 2026-09-21 at 20 55 42" src="https://github.com/user-attachments/assets/cfaa630f-fc92-41de-bf5e-82a72a530d40" />

- Все созданные в Yandex Cloud ресурсы удалены (`terraform destroy`) после проверки задания.
