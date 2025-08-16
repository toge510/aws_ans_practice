# 62. VPC Interface Endpoint

## 構成図

```mermaid
flowchart TD
    %% AWS Console
    AWSConsole["AWS Management Console"]:::console

    %% VPC
    subgraph VPC["VPC A: 10.10.0.0/16"]
        subgraph Subnet1["Private Subnet: 10.10.0.0/24"]
            EC2Connect["EC2 Instance Connect Endpoint"]:::ec2connect
        end

        subgraph Subnet2["Private Subnet: 10.10.1.0/24"]
            EC2["EC2 Instance\n(Private IP, SG outbound)"]:::ec2
        end

        subgraph Subnet3["Private Subnet: 10.10.2.0/24"]
            VPCE["Interface Endpoint"]:::vpce
        end
    end

    SQS["SQS Queue"]:::sqs

    %% Connections
    AWSConsole -->|SSH via EC2 Instance Connect| EC2Connect
    EC2Connect -->|Connect| EC2
    VPCE -->|Access SQS| SQS

    %% Styles
    classDef console fill:#fef3c7,stroke:#f59e0b,stroke-width:2px,color:#b45309;
    classDef ec2connect fill:#fcd34d,stroke:#b45309,stroke-width:2px,color:#78350f;
    classDef ec2 fill:#fbbf24,stroke:#b45309,stroke-width:2px,color:#78350f;
    classDef vpce fill:#a5b4fc,stroke:#4338ca,stroke-width:2px,color:#312e81;
    classDef sqs fill:#bef264,stroke:#4d7c0f,stroke-width:2px,color:#365314;

```


## 準備

### Installation

* aws cli
* terraform

### tfstate 用の S3 を作成

```bash
YOUR_NAME="toge510" <- ここを更新

CURRENT_TIME=$(date +"%Y%m%d%H%M%S")
BUCKET_NAME="tfstate-${YOUR_NAME}-${CURRENT_TIME}"
echo "$BUCKET_NAME"

aws s3api create-bucket \
  --bucket "$BUCKET_NAME" \
  --region ap-northeast-1 \
  --create-bucket-configuration LocationConstraint=ap-northeast-1
```

### main.tf を変更

`./terraform/main.tf`の 3 行目を変更

```bash
terraform {
  backend "s3" {
    bucket  = "tfstate-toge510-20250721182240" <- ここを更新
    key     = "terraform.tfstate"
    region  = "ap-northeast-1"
    encrypt = true
  }
}
```

### git clone 

```bash
git clone https://github.com/toge510/aws_ans_practice.git
cd aws_ens_practice
```

### terraform 適用

```bash
cd ./terraform
terraform apply
-> yes
```

## EC2からSQSにメッセージを送る

EC2に、EC2 Instance Connect Endpointを使って、ssh接続する。


VPC Endpoint for sqsにおいて、`private_dns_enabled = true` のため、nslookup でEndpointのDNS名を名前解決すると、pravate IPアドレスに解決されることを確認。

```bash
nslookup sqs.ap-northeast-1.amazonaws.com
```

sqsにメッセージを送信

```
aws sqs send-message --queue-url https://sqs.ap-northeast-1.amazonaws.com/624838222411/my-queue --message-body "This is test message 1" --region ap-northeast-1 --endpoint-url https://vpce-0a6784e1fe5fe105c-c5voyzfg.sqs.ap-northeast-1.vpce.amazonaws.com
```

sqsにおいて、メッセージを送受信でメッセージをポーリングして、メッセージを確認。