# Terraform-ALB_LAMBDA_RDS
AWSのVPC作成から、Route 53プライベートホストゾーンの作成までを行うTerraformサンプルコードです。
このコードは、下記のツリー構成をしています。

```
│  main.tf
│  versions.tf
│
└─modules
    ├─ALB-Setup
    │      main.tf
    │      outputs.tf
    │      variables.tf
    │
    ├─EC2-Setup
    │      main.tf
    │      outputs.tf
    │      variables.tf
    │
    ├─Lambda-Setup
    │      main.tf
    │      outputs.tf
    │      variables.tf
    │
    ├─Network-Setup
    │      main.tf
    │      outputs.tf
    │      variables.tf
    │
    ├─RDS-Setup
    │      main.tf
    │      outputs.tf
    │      variables.tf
    │
    └─Route53-Setup
            main.tf
            variables.tf
```
