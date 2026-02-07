# Terraform-ALB_LAMBDA_RDS
AWSのVPC作成から、Route 53プライベートホストゾーンの作成までを行うTerraformサンプルコードです。
このコードは、下記のツリー構成をしています。
<pre>
 .
tqq main.tf
tqq modules
x   tqq ALB-Setup
x   x   tqq main.tf
x   x   tqq outputs.tf
x   x   mqq variables.tf
x   tqq EC2-Setup
x   x   tqq main.tf
x   x   tqq outputs.tf
x   x   mqq variables.tf
x   tqq Lambda-Setup
x   x   tqq main.tf
x   x   tqq outputs.tf
x   x   mqq variables.tf
x   tqq Network-Setup
x   x   tqq main.tf
x   x   tqq outputs.tf
x   x   mqq variables.tf
x   tqq RDS-Setup
x   x   tqq main.tf
x   x   tqq outputs.tf
x   x   mqq variables.tf
x   mqq Route53-Setup
x       tqq main.tf
x       mqq variables.tf
mqq versions.tf 
</pre>



npm install

