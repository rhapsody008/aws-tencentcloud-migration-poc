resource "tencentcloud_cam_role" "zy_test_cvm_role" {
  name = "read_only_db_secrets_tcop_role"
  document = jsonencode(
    {
      statement = [
        {
          action = "name/sts:AssumeRole"
          effect = "allow"
          principal = {
            service = [
              "cvm.qcloud.com",
            ]
          }
        },
      ]
      version = "2.0"
    }
  )
}

resource "tencentcloud_cam_policy" "zy_test_cvm_policy" {
  name     = "zy_ro_policy"
  document = <<EOF
{
  "version": "2.0",
  "statement": [
    {
      "action": [
        "cdb:Describe*",
        "cdb:List*",
        "monitor:Describe*",
        "monitor:Get*",
      ],
      "effect": "allow",
      "resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "tencentcloud_cam_role_policy_attachment" "ro_policy_attachment" {
    role_id = tencentcloud_cam_role.zy_test_cvm_role.id
    policy_id = tencentcloud_cam_policy.zy_test_cvm_policy.id
}
