# Sample Terraform Module

Using IBM Cloud Terraform Provider Create
- A role, with no permissions, which can be assumed by users within the same account
- A policy, allowing users / entities to assume the above role
- A group, with the above policy attached
- A service ID, belonging to the above group

## Providers

| Name | Version |
|------|---------|
| <a name="provider_ibm"></a> [ibm](#provider\_ibm) | 1.36.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ibmcloud_api_key"></a> [ibmcloud\_api\_key](#input\_ibmcloud\_api\_key) | IBM Cloud API Key with access to manage IAM Roles, Groups, Policies, Service ID (instead of user) | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix for name of all resource created by this example | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | Region where resources are created | `string` | `"us-south"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_group_id"></a> [group\_id](#output\_group\_id) | IBM Cloud Group ID |
| <a name="output_group_name"></a> [group\_name](#output\_group\_name) | IBM Cloud Group Name |
| <a name="output_role_id"></a> [role\_id](#output\_role\_id) | IBM Cloud Role ID |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | IBM Cloud Role Name |
