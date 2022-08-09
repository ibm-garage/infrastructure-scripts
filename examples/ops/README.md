# Provisioning IBM Cloud Logging and Monitoring Services for Kubernetes

## Introduction

This set of simple example Terraform scripts demonstrates how to provision IBM Cloud Monitoring (sysdig) and IBM Cloud Log Analysis service instances and bind them to an existing IBM Kubernetes or OpenShift cluster.

### Prerequisites

* Terraform version `1.0.5` or higher -  see installation instructions in the reference section:  [Terraform installation](#terraform-installation)
* IBM API Key - refer to  [IBM Cloud Doc: Setting up an API key](https://cloud.ibm.com/docs/account?topic=account-userapikey#create_user_key)
* An IBM Kubernetes or OpenShift cluster deployed, with sufficient resources allocated.



### Input Variables

We recommend using `terraform.tfvars` to provide values to the input parameters to the example scripts, and include it in your `.gitignore`, instead of filling them in directly in `variables.tf`. Either copy your existing `terraform.tfvars` into the `examples/WireGuard` directory and edit it to include all the required parameters, or copy from the sample `terraform.tfvars.template` into a new `terraform.tfvars` configuration file and populate it.


| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | -------- |
| ibmcloud_api_key | API Key needed to provision most IBM Cloud resources.  Your key must be authorized to perform the actions in the your script. | string | N/A | yes|
| cluster_instance_id | The Kubernetes Cluster ID for which to set up monitoring and logging. |string | N/A | yes |
| region | The region to provision the services in. |string | us-south | no |
| suffix | the suffix for the service name. |string | dev | no |
| resource_group | The name of the resource group into which to provision all resources in this script. |string | Default | no |
| namespace_id | the namespace in the cluster to hold the logging service credentials to bind to the cluster. |string | default | no |


## Terraform Version
Tested with Terraform v1.0.5.

## Running the configuration

Run:

```shell
terraform init
```

```shell
terraform apply
```

The scripts takes a couple of minutes to complete.

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
  provider registry.terraform.io/ibm-cloud/ibm v1.33.1

  ```

### References

* [IBM Cloud Doc: Getting started with Terraform on IBM Cloud](https://cloud.ibm.com/docs/ibm-cloud-provider-for-terraform?topic=ibm-cloud-provider-for-terraform-getting-started)
* [IBM Cloud Provider Documentation](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs)
  * [IBM Cloud Provider Documentation - Authentication (API keys etc)](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs#authentication)
  * [IBM Cloud Provider Documentation - ibm_ob_logging](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/ob_logging)
  * [IBM Cloud Provider Documentation - ibm_ob_monitoring](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/ob_monitoring)
