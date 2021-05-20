# Install and Configure Wireguard

## Introduction
This module deploys a VSI into a VPC environment pre-configured with Wireguard and any configuration for peers provided. Once the floating IP is assigned this can be used to tunnel into your VPC environment from your laptop or other machine.

### Prerequisites

Prior to using this module, ensure you have at least the following (refer to Input Variables for additional parameters for the IBM Cloud VPC environment):

* Terraform 0.14 or higher
* IBM API Key
* An ssh key object already available in the IBM Cloud in the region where the VSI will be provisioned.  
* A VPC into which a subnet and VSI will be provisioned.
* Wireguard client installed on your desktop/laptop to connect to the deployed VSI
* Wireguard tools to generate peer configs


### Input Variables

| Name | Description | Type | Default/Example | Required |
| ---- | ----------- | ---- | ------- | -------- |
| ibmcloud_api_key | API Key used to provision resources.  Your key must be authorized to perform the actions in this script. | string | N/A | yes |
| basename | prefix used in name of all provisioned resources. | string | "user123" | no |
| resource_group_id | The id of the resource group in which to provision all resources | string | N/A | yes |
| region | Must be the same region as the vpc. | string | N/A | yes |
| zone | Zone in which to provision all resources.  Must be in the same region as the vpc. | string | N/A | yes |
| vpc_id | VPC id of the VPC to use  | string | N/A | yes |
| ssh_key_id | The id of the ssh key that the VSI will be provisioned with | string | N/A | yes |
| cidrs | An array of cidrs to which you will want to connect.  An example might be the subnet ranges where your IKS or ROKS cluster is provisioned.  You can also add these to the client configuration later. | list(string) | [] | no |
| wg_cidr | The RFC 4632 CIDR to use for the Wireguard network. | string | "10.0.200.0/24" | no |
| wg_server_config | The server config for wireguard. To work properly the private key must be provided | object({ publicKey = string, privateKey = string }) | { publicKey = "", privateKey = "<output from wg command>" } | yes |
| wg_clients | The list of client configurations for wireguard. To work properly the public keys must be provided. Note while not required, failing to provide any client configurations will prevent connecting to the wireguard tunnel | list(object({ publicKey = string, privateKey = string })) | [{ publicKey = "<output from wg command>", privateKey = "" }] | no |
| init_timeout | The number of seconds to wait for a newly provisioned wireguard VSI before tearing down an old one. Can be used to minimize downtime between `terraform apply`s. | string | "1" | no |

### Output Variables

| Name | Description |
| ---- | ----------- |
| vsi_private_ip  | The private ip of the vsi created |
| vsi_floating_ip | The floating ip of the vsi created |
| vsi_subnet     | The cidr of the subnet created |
| vsi_id         | The id of the newly created vsi |
| client_configs | The client configuration files needed to connect to the wireguard server. If complete public/private key pairs were provided these are complete configs, otherwise they will need to be completed with the appropriate key pair information. |
| security_group_id | The id of the newly created security group for the vsi |


### Security Considerations

The VSI is running Ubuntu and has disabled PasswordAuthentication over ssh and the root password is deleted.  

In order to provide a deterministic setup, the private key of the server and the public keys of the clients are provided to the module, and adding/changing them will respin the server with the specified config. However, this also means these values are present within the terraform state and care should be taken to handle them, see [Handling Sensitive Values in State](https://www.terraform.io/docs/extend/best-practices/sensitive-state.html).


## Terraform Version
Tested with Terraform v0.14

## Running the configuration

Since this wireguard instance is intended to be a specialized VSI as part of a larger ecosystem, it's best imported as a module into a larger Terraform plan (see a simple [example](../../examples/wireguard/)). However, if you have an existing environment you'd like to deploy this into, start by filling in `variables.tf` or create an appropriate `terraform.tfvars`.

Then run:

```shell
terraform init
```

```shell
terraform apply
```

After you run the script, you should:

* Copy [and optionally complete] the wireguard config(s) that are output into your wireguard client(s)
* Activate the tunnel in your wireguard client and test connectivity, note the deployment and provisioning can take a few minutes to complete after the apply has completed
