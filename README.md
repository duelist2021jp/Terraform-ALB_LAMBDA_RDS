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
あくまでも個人環境での検証用なので、利用される際にはコピーいただいた上で、ご自身の環境に合わせてカスタマイズください。

## コード作成環境
Ubuntu 24.04.3 LTS

## 各モジュールの概要
### Network-Setup
AWS VPC内のネットワーク環境を作成します。作成するリソースは下記の通りです。
* VPC：1個
* Private Subnet：4個 (内訳：Private Subnet1と2はALBとLambda配置用、Private Subnet3と4はRDS(Postgresql)配置用) ※ Private Subnet1には作業用にEC2インスタンスも配置
* 各種セキュリティーグループの作成 (Client-VPNエンドポイントへのアタッチ用、ALBへのアタッチ用、Lambdaへのアタッチ用、EC2へのアタッチ用、RDSへのアタッチ用、SSMエンドポイントへのアタッチ用)
* SSMエンドポイント
### EC2-Setup
* RDSのテーブル作成などの作業用のEC2インスタンスを作成。※このEC2インスタンスには、外部からSSM Session Manager経由でアクセス。
### RDS-Setup
* Secret Managerにシークレットを作成し、RDSのユーザーIDとパスワードを登録
* RDSインスタンス(Postgresql)をマルチAZ構成で作成
### Lambda-Setup
* Lambdaレイヤーの作成 (Pythonの標準モジュールでは不足しているため)
* Lambda関数がSecret Manager上のシークレットにアクセスするためのIAMポリシーを作成
* 既存のLambda関数で利用するIAMロール内に、上記のIAMポリシーを追加
* Lambda関数を作成
  * RDS上のユーザー作成テーブル(accounts)の情報を取得する関数。
  * python 3.12で作成。
### ALB-Setup
* 内部ALBを作成
* ALBのターゲットにLambdaを指定
* ALBからLambdaを実行できるようにするためのパーミッションを作成
* ACM証明書をALBのリスナーにアタッチ ※ポート番号：443、プロトコル：HTTPS
### Route53-Setup
* プライベートホストゾーン(internal.cloudlab-km.com)の作成
* 親ドメイン(cloudlab-km.com)のパブリックホストゾーンに、上記プライベートホストゾーンのNSレコードを登録

## Lambda関数
* get_rds_table.zip：lambda_function.pyをzip圧縮したもの。
* psycopg2_layer.zip：Lambdaレイヤーに登録するためのモジュールをzip圧縮したもの。
