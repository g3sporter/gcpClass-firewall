resource "google_compute_instance" "default" {
  count          = length(var.name_count)
  name           = "list-${count.index + 1}"
  machine_type   = var.machine_type
  zone           = var.zone
  can_ip_forward = "false"
  description    = "This is our Virtual Machine"
  tags           = ["allow-http", "allow-https"] #FIREWALL

  boot_disk {
    initialize_params {
      image = var.image
      size  = "20"
    }
  }

  labels = {
    name         = "list-${count.index + 1}"
    zone         = var.zone
    machine_type = var.machine_type
  }

  network_interface {
    network = "default"
  }

  metadata = {
    size = "20"
    foo  = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}
output "GCP_Instance_Type" { value = "${google_compute_instance.default.*.machine_type}" }
output "GCP_Instance_Name" { value = "${google_compute_instance.default.*.name}" }
output "GCP_Instance_Zone" { value = "${google_compute_instance.default.*.zone}" }
#make the output comma seperated for use as a variable
output "instance_id" { value = "${join(",", google_compute_instance.default.*.name)}" }
