# Install and Configure Wireguard

## Use Case

In a VPC, you have disabled public service endpoints on a service or, for security/compliance reasons, you have only private IPs on your VSIs (no floating ips).  You need some way to connect to your servers and services.

## How it helps 

This terraform module will stand up an ubuntu VSI with wireguard running.  As parameters to the terraform template, you provide a public/private key for the server and one or more public/private keys for your team.  Your team installs the wireguard client (for mac, it's in the app store), paste the client config you give them into the client and activate the tunnel.  Once the tunnel is activated, they can use the VPN tunnel to access private endpoints.


### Prerequisites

Prior to using this module, ensure you have at least the following (refer to Input Variables for additional parameters for the IBM Cloud VPC environment):

* Terraform 0.14 or higher -  see installation instructions in the reference section:  [Terraform installation](#terraform-installation)
* IBM API Key - refer to  [IBM Cloud Doc: Setting up an API key](https://cloud.ibm.com/docs/account?topic=account-userapikey#create_user_key)
* An ssh key object already available in the IBM Cloud in the region where the VSI will be provisioned - refer to [IBM Cloud Doc: Setting up an SSH key](https://cloud.ibm.com/docs/vpc?topic=vpc-ssh-keys).  Once you have the key, you will need to upload it to IBM Cloud.  You can do this in the UI by navigating to `VPC Infrastructure->SSH Keys` and selecting `Create` or, if you have the [IBM Cloud CLI installed](https://cloud.ibm.com/docs/cli?topic=cli-getting-started) with the infrastructure plugin, you can use the command `ibmcloud is key-create` to upload your key.  To get the ID to pass into the terraform, use the `UUID` field from the UI, or from the CLI, use the `ID` value for your key, returned from the command `ibmcloud is keys`.
* A VPC into which a subnet and VSI will be provisioned.
* WireGuard client installed on your workstation (desktop/laptop) - refer to [WireGuard Documentation: installation](https://www.WireGuard.com/install/)
* Wireguard-tools installed.  This is used to generate public/private keys pairs On [Wireguard Documentation: installation](https://www.WireGuard.com/install/) page, search for `wireguard-tools` for your os.
* A public/private key pair for the wireguard server, and public/private key pairs for at least one client configuration.  To create a pair, use the `wireguard-tools` and run the command `wg genkey | tee privatekey | wg pubkey > publickey`.  The keys can then be copied from the generated privatekey and publickey files.  Alternatively, you can use the helper script by running `./createkeys.sh -n <numClients>` and this will output the variables `wg_server_config` and `wg_clients` to stdout for you to paste into the `terraform.tfvars` or `variables.tf` file.  If you don't want the server public key or client private keys exposed in the terraform state or output, then remove these from the variables and save them elsewhere to be added to the client configurations manually, later.


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

* Copy (and, add the server public key and client private key to the configuration file if you excluded them from the variables) the wireguard config(s) that are output into your wireguard client(s)
* Activate the tunnel in your wireguard client and test connectivity, note the deployment and provisioning can take a few minutes to complete after the apply has completed
