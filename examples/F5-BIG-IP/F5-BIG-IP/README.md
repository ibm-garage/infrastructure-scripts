# Provision F5 BIG-IP


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
| tmos_image_name | The image to be used when provisioning the F5 BIG-IP instance | string | "f5-bigip-16-0-1-1-0-0-6-all-1slot-1" | no |
| do_declaration_url | URL to fetch the f5-declarative-onboarding declaration | string | "" | no |
| as3_declaration_url | URL to fetch the f5-appsvcs-extension declaration | string | "" | no |
| ts_declaration_url | URL to fetch the f5-telemetry-streaming declaration | string | "" | no |
| f5_admin_password | Admin password for F5 | string | N/A | yes |
| f5_license | BYOL license key | N/A | yes |


### Output Variables

| Name | Description |
| ---- | ----------- |
| F5_PRIVATE_EXTERNAL_IP | Private IP of F5 external interface |
| F5_PRIVATE_INTERNAL_IP | Private IP of F5 internal interface|
| F5_PRIVATE_MGMT_IP | Private IP of F5 management interface  |
| F5_FLOATNG_MGMT_IP | Floating IP for F5, initially assigned to management interface |
| F5_INSTANCE_STATUS | Status of F5, should say 'running', but may still take some time for F5 to be ready. |
| SNAT_NEXT_HOP_ADDRESS | SNAT next hop address |
| VIRTUAL_SERVER_NEXT_HOP_ADDRESS | virtual server next hop address |
| DEFAULT_GATEWAY | default gateway |
| F5_INSTANCE_NAME | name assigned to F5 instance |
| _COMMAND_FLOATING_IP_MOVE | Sample command for reassigning floating IP to external interface |



## Terraform Version
Tested with Terraform v0.14


## Running the configuration

*IMPORTANT:* Set environment variable `IC_API_KEY` to your IBM Cloud API Key.

Run:

```shell
terraform init
```

```shell
terraform apply
```

