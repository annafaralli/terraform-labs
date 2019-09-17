resource "azurerm_resource_group" "core" {
    name     = "core"
    location = "${var.loc}"
    tags     = "${var.tags}"
}

resource "azurerm_public_ip" "vpnGatewayPublicIp" {
  name                = "acceptanceTestPublicIp1"
  location            = "${var.loc}"
  resource_group_name = "${azurerm_resource_group.core.name}"
  allocation_method   = "Dynamic"

  tags = "${var.tags}"
}

resource "azurerm_virtual_network" "core" {
  name                = "core"
  location            = "${azurerm_resource_group.core.location}"
  resource_group_name = "${azurerm_resource_group.core.name}"
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["1.1.1.1", "1.0.0.1"]

  subnet {
    name           = "GatewaySubnet"
    address_prefix = "10.0.0.0/24"
  }

  subnet {
    name           = "training"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "dev"
    address_prefix = "10.0.2.0/24"
  }

  tags = "${var.tags}"
}


/* resource "azurerm_virtual_network_gateway" "vpnGateway" {
  name                = "vpnGateway"
  location            = "${azurerm_resource_group.core.location}"
  resource_group_name = "${azurerm_resource_group.core.name}"

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = true
  sku           = "Basic"

  ip_configuration {
    name                          = "vnetGwConfig1"
    public_ip_address_id          = "${azurerm_public_ip.vpnGatewayPublicIp.id}"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "${azurerm_subnet.GatewaySubnet.id}"
  }

} */