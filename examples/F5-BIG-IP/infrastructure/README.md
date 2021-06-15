# Provision subnets and optional Wireguard server in preparation for F5


## Input Variables

| Name | Description | Type | Default/Example | Required |
| ---- | ----------- | ---- | ------- | -------- |
| ibmcloud_api_key | API Key used to provision resources.  Your key must be authorized to perform the actions in this script. | string | N/A | yes |
| basename | prefix used in name of all provisioned resources. | string | "user123" | yes |
| region | Must be the same region as the vpc. | string | "us-south" | yes |
| zone | Zone in which to provision all resources.  Must be in the same region as the vpc. | string | "us-south-1" | yes | vpc_name | The name of the VPC into which the F5 server will be provisioned | string | N/A | yes |
| resource_group_name | The name of the resource group into which to provision all resources in this script | string | N/A | yes |
| ssh_key_name | The name of ssh key that you will use to provision (access) the VSIs | string | N/A | yes |
| provision_wireguard | Set to true if you would like to provision Wireguard | boolean | true | no |
| wg_cidr | The RFC 4632 CIDR to use for the WireGuard network. | string | "10.0.200.0/24" | Required if provision_wireguard is true |
| wg_server_config | The server config for WireGuard. To work properly the private key must be provided | object({ publicKey = string, privateKey = string }) | { publicKey = "", privateKey = "generated via wg command" } | Required if provision_wireguard is true |
| wg_clients | The list of client configurations for WireGuard. To work properly the public keys must be provided | list(object({ publicKey = string, privateKey = string })) | [{ publicKey = "generated via wg command", privateKey = "" }] | no |

### Output Variables

| Name | Description |
| ---- | ----------- |
| WG_VSI_FLOATING_IP | The floating ip of the WireGuard VSI created |
| WG_VSI_SUBNET      | The cidr of the WireGuard subnet created |
| CLIENT_CONFIGS | The client configuration files needed to connect to the WireGuard server. If complete public/private key pairs were provided these should be complete configs, otherwise they will need to be completed with the appropriate key pair information. |
| f5_mgmt_subnet_id | UUID of subnet for management interface for F5 BIG-IP |
| f5_internal_subnet_id | UUID of subnet for internal interface for F5 BIG-IP |
| f5_external_subnet_id | UUID of subnet for external interface for F5 BIG-IP |


### Security Considerations

The wireguard VSI is running ubuntu and has disabled PasswordAuthentication over ssh and the root password is deleted.  Addtionally, The security groups on the Wireguard server does not permit ssh traffic (port 22),  To permit ssh traffic to the wireguard VSI (which has a public floating ip), add a rule to its security group to allow inbound traffic on port 22.  You can further restrict this traffic to your ip only.

In order to provide a deterministic setup, the WireGuard private key of the server and the WireGuard public keys of the clients are provided to the module, and adding/changing them will respin the server with the specified config. However, this also means these values are present within the terraform state and care should be taken to handle them, see [Handling Sensitive Values in State](https://www.terraform.io/docs/extend/best-practices/sensitive-state.html).


## Terraform Version
Tested with Terraform v0.14


## Running the configuration

Run:

```shell
terraform init
```

```shell
terraform apply
```

After you run the script:

* Copy `CLIENT_CONFIGS` info from the script output into a configuration file (e.g. `wg-client.conf`), add the server public key and client private key to the configuration file if you excluded them from the variables.  Import client configuration into each WireGuard client.
* Activate the tunnel by pushing the activate button in the WireGuard client
