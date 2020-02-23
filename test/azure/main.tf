// Create Resource Group

resource azurerm_resource_group "k3s-bootstrap-rg" {
  name     = var.rg_name
  location = var.location
}

// Create Network

module azure-network {
  source             = "./modules/azure-network"
  location           = "${var.location}"
  vnet_address_space = "${var.vnet_address_space}"
  vnet_name          = "${var.vnet_name}"
  vnet_subnet_name   = "${var.vnet_subnet_name}"
  vnet_subnet_prefix = "${var.vnet_subnet_prefix}"
  rg_name            = azurerm_resource_group.k3s-bootstrap-rg.name
}

// Create VMs

module azure-vms {
  source       = "./modules/azure-vms"
  hosts        = "${var.hosts}"
  location     = "${var.location}"
  rg_name      = azurerm_resource_group.k3s-bootstrap-rg.name
  vm_size      = "${var.vm_size}"
  os_publisher = "${var.os_publisher}"
  os_offer     = "${var.os_offer}"
  os_sku       = "${var.os_sku}"
  os_version   = "${var.os_version}"
  username     = "${var.username}"
  ssh-key      = "${var.ssh-key}"
  subnet_id    = "${module.azure-network.subnet_id}"

}

# resource null_resource "ansible-playbook" {
#   provisioner "local-exec" {
#     command = <<EOT
#               ansible-playbook ../../ansible/bootstrap.yml --extra-vars "@overrides.yaml"
#               EOT
#   }
#   depends_on = [module.azure-vms]
# }
