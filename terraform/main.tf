locals {
  prefix = var.prefix!="" ? "${var.prefix}-": ""
}

# A role, with no permissions, which can be assumed by users within the same account
resource "ibm_iam_custom_role" "toolchain-viewer-role" {
#  H is added here as a quick hack to match the requirement for the name to start with a capital letter
  name         = "H${local.prefix}toolchainviewer"
  display_name = "Toolchain Viewer"
  description  = "Gives view access to list Toolchain instances"
  service = "toolchain"
  actions      = ["toolchain.dashboard.view"]
}

# A group, with the above policy attached
resource "ibm_iam_access_group" "toolchain-viewer-group" {
  name        = "${local.prefix}toolchainviewer-group"
  description = "Group with toolchain view role"
}

# A policy, allowing users / entities to assume the above role
resource "ibm_iam_access_group_policy" "toolchain-viewer-policy" {
  access_group_id = ibm_iam_access_group.toolchain-viewer-group.id
#  Custom Roles not supported by the IBM Cloud Provider https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/iam_access_group_policy#roles
  roles           = ["Viewer"]
  resources {
    service         = "toolchain"
  }
}

# A user, belonging to the above group
# This is how you invite a new user but I do not think that's what the question was for.
# I think what you are looking for is what IBM Cloud calls a Service ID
#resource "ibm_iam_user_invite" "invite_user" {
#  users         = ["test_user@ibm.com"]
#  access_groups = [ibm_iam_access_group.toolchain-viewer-group.id]
#}
resource "ibm_iam_service_id" "toolchain-viewer-service-id" {
  name        = "${local.prefix}toolchainviewer-service-id"
  description = "New Service ID with toolchain viewer access"
}

resource "ibm_iam_access_group_members" "toolchain-viewer-group-members" {
  access_group_id = ibm_iam_access_group.toolchain-viewer-group.id
  iam_service_ids = [ibm_iam_service_id.toolchain-viewer-service-id.id]
}