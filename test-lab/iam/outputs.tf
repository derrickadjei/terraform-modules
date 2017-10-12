# - Users

output "iam_user_arn" {
  value = "${module.user.iam_user_arn}"
}
output "iam_user_name" {
  value = "${module.user.iam_user_name}"
}
output "iam_user_access_key_id" {
  value = "${module.user.iam_user_access_key_id}"
}
output "iam_user_access_secret" {
  value = "${module.user.iam_user_access_secret}"
}
output "iam_user_access_key_user" {
  value = "${module.user.iam_user_access_key_user}"
}
output "iam_user_login_profile_password" {
  value = "${module.user.iam_user_login_profile_password}"
}

#-
output "iam_user_group_membership_group_name" {
  value = "${module.user.iam_user_group_membership_group_name}"
}
output "iam_user_group_membership_group_users" {
  value = "${module.user.iam_user_group_membership_group_users}"
}
output "iam_user_group_membership_group_group" {
  value = "${module.user.iam_user_group_membership_group_group}"
}


#- Roles
output "iam_role_name" {
  value = "${module.user.iam_role_name}"
}
output "iam_role_arn" {
  value = "${module.user.iam_role_arn}"
}
output "iam_role_unique_id" {
  value = "${module.user.iam_role_unique_id}"
}
output "iam_role_policy_id" {
  value = "${module.user.iam_role_policy_id}"
}
output "iam_role_policy_name" {
  value = "${module.user.iam_role_policy_name}"
}
output "iam_role_policy_policy" {
  value = "${module.user.iam_role_policy_policy}"
}


#- Groups
output "iam_group_name" {
  value = "${module.user.iam_group_name}"
}
output "iam_group_policy_name" {
  value = "${module.user.iam_group_policy_name}"
}


# - Name and {access_key. secret_key, password}
output "name_and_access_key" {
  value = "${module.user.name_and_access_key}"
}
output "name_and_secret_key" {
  value = "${module.user.name_and_secret_key}"
}
output "name_and_password" {
  value = "${module.user.name_and_password}"
}
