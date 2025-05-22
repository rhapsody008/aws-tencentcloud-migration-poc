# AWS - Tencent Cloud 迁移PoC

## 应用架构
![image](https://github.com/user-attachments/assets/936471ca-b82a-4d2f-a684-b413dd33de53)

## Terraform文档架构

terraform/
│
├── module/
│   ├── aws/
│   │   └── ... (contents of aws module)
│   │
│   └── tencentcloud/
│       └── ... (contents of tencentcloud module)
│
├── varfile/
│   ├── dev.tfvars
│   └── prod.tfvars
│
├── main.tf
├── providers.tf
└── variables.tf

## 在线迁移步骤

## 离线迁移步骤
