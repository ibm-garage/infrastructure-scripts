# Provision a Virtual Server Instance on Classic Infrastructure

## Introduction

This set of simple example Terraform scripts demonstrates how to provision a Centos 7 Virtual Server Instance (VSI) on IBM Cloud Classic Infrastructure.

### Prerequisites

* Terraform version `0.14` or higher -  see installation instructions in the reference section:  [Terraform installation](#terraform-installation)
* (Optional for this scenario, but needed by most) IBM API Key - refer to  [IBM Cloud Doc: Setting up an API key](https://cloud.ibm.com/docs/account?topic=account-userapikey#create_user_key)
* Create or find your IBM Cloud Classic Infrastructure API key [here](https://cloud.ibm.com/iam/apikeys). Select `Classic Infrastructure API Keys` option from view dropdown.
* For your Classic Infrastructure user name go to [Users](https://cloud.ibm.com/iam/users), Click on `user`. Find user name in the `VPN password` section under `User Details` tab.



### Input Variables


We recommend using `terraform.tfvars` to provide values to the input parameters to the example scripts, and include it in your `.gitignore`, instead of filling them in directly in `variables.tf`. Either copy your existing `terraform.tfvars` into the `examples/WireGuard` directory and edit it to include all the required parameters, or copy from the sample `terraform.tfvars.template` into a new `terraform.tfvars` configuration file and populate it.


| Name | Description | Type | Default/Example | Required |
| ---- | ----------- | ---- | ------- | -------- |
| ibmcloud_api_key | API Key needed to provision most IBM Cloud resources.  Your key must be authorized to perform the actions in the your script. | string | N/A | no (included for demo purpose)|
| iaas_classic_username | Classic Infrastructure user name used to provision resources. | string | N/A | yes |
| iaas_classic_api_key | IBM Cloud Classic Infrastructure API key used to provision Classic Infrastructure resources. | string | N/A | yes |
| hostname | Hostname for the new VSI. | string | "user123" | yes |
| region | The region to provision the VSI in. | string | "us-south" | yes |
| zone | Zone in which to provision all resources.  Must be in the same region as the vpc. | string | "us-south-1" | yes |
| ssh_key | The public SSH key you want to use to access the VSI. |string | N/A | yes |


## Terraform Version
Tested with Terraform v0.14 and v1.0.5.

## Running the configuration

Run:

```shell
terraform init
```

```shell
terraform apply
```

Once the scripts finish successfully (takes ~3 minutes in our test), key attributes of the new VSI including the public IP address are printed to standard out. You can log on to the VSI using the SSH key you provided driving provisioning.

To delete the VSI instance, Run

Run:

```shell
terraform destroy
```

### Terraform installation

* set up a directory to store terraform binary with `mkdir terraform && cd terraform`
* download the `Terraform CLI` from the [hashicorp site](https://www.terraform.io/downloads.html) (or directly from the [directory](https://releases.hashicorp.com/terraform/) to the local directory. e.g. `wget https://releases.hashicorp.com/terraform/0.14.8/terraform_0.14.8_linux_amd64.zip`) and unzip it.
* set up the `$PATH` environment variable to point to `terraform` executable: `export PATH=$PATH:$HOME/terraform`
* verify the installation

  ```
  # terraform -version
  Terraform v1.0.5

  ```

### References

* [IBM Cloud Doc: Getting started with Terraform on IBM Cloud](https://cloud.ibm.com/docs/ibm-cloud-provider-for-terraform?topic=ibm-cloud-provider-for-terraform-getting-started)
* [IBM Cloud Provider Documentation](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs)
  * [IBM Cloud Provider Documentation - Authentication (API keys etc)](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs#authentication)
