## Function

perform as aws Customer Managed Keys creation 

- CMK creation

## Usage

### Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.7 |
| aws | >= 6.28 |

### Providers

| Name | Version |
|------|---------|
| aws | >= 6.28 |


### Deploy

download this module in your lcoal directory and call this module like this:

```shell

module "maxwell_kms_cmk_frontend" {
  source = "./modules/aws-kms-cmk"
  description = "KMS CMK for production s3"
  alias_name  = "alias/prod-s3-custom-key-01"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  tags = {
    Environment = "production"
    Project     = "infrastructure"
    Terraform   = "true"
  }
}

```

AWS KMS (Key Management Service) 是一项托管型密码服务，主要用于创建和控制加密密钥，保护您在云端存储的数据。  


在以下几种典型场景和需求下，您会经常用到 AWS KMS：
一、 满足合规与严格的安全监管要求（安全与合规）行业与法律合规：当您的业务涉及金融、医疗、政务等领域，受到诸如 GDPR、HIPAA、PCI-DSS 等合规性约束时，通常被强制要求对核心敏感数据（如用户隐私、交易流水）进行静态加密。自主掌控控制权（客户托管密钥 CMK）：虽然许多云服务支持默认加密，但监管往往要求您必须拥有并掌控加密密钥的生命周期。通过 KMS，您可以创建、轮换、禁用甚至销毁密钥，确保在必要时通过切断密钥来“瞬间”销毁或锁定数据访问权限。  

二、 对 AWS 托管的云服务进行静态数据加密（Server-Side Encryption）  

当您在 AWS 上使用各类存储和数据库服务，希望对保存在硬盘上的静态数据进行加密时，KMS 是底层的核心：  Amazon S3 存储桶加密：配置 S3 对象的服务器端加密（SSE-KMS），确保上传到特定 Bucket 的敏感文件自动加密。  云服务器与数据库：对 Amazon EBS 硬盘卷、Amazon RDS / Aurora 关系型数据库、DynamoDB 表或 Amazon ElastiCache 缓存进行加密，防止底层物理硬件流出时数据泄露。  容器镜像与日志：对 Amazon ECR 中的 Docker 镜像、CloudWatch 中的日志组进行加密保护。

三、 在应用程序代码中实现客户端加密（Client-Side Encryption）应用层敏感字段加密：如果您的业务对安全性要求极高（如不希望明文数据离开应用服务器），您可以使用 AWS Encryption SDK 结合 KMS，在应用程序本地对敏感字段（如身份证号、银行卡号、手机号）进行加密后再写入数据库。  数字签名与验证：当您的系统需要对关键交易、API 请求或代码包进行数字签名（Digital Signature）或生成消息身份验证码（MAC）时，可以调用 KMS 的加解密及签名 API 来完成。  四、 多账号与跨区域的安全治理（多租户/企业级架构）AWS Organizations 统一管控：当企业拥有几十个甚至上百个 AWS 账号时，您可以通过 KMS 的密钥策略（Key Policies）和 AWS 资源控制策略 (RCP)，集中控制哪些子账号或哪些 IAM 角色有权使用特定的加密密钥。  跨区域灾备与多区域密钥：如果您的业务分布在全球不同区域，或者需要做跨区容灾备份，可以使用 KMS 多区域密钥（Multi-Region Keys），让不同区域的系统能够使用具有相同密钥材料的密钥无缝加解密数据。  五、 审计与追踪（谁在什么时候访问了数据）  操作审计追踪：您想知道是谁、在什么时间、通过哪个应用或 IP 地址解密或访问了某份核心数据。KMS 与 AWS CloudTrail 深度集成，会记录每一次对密钥的调用请求（API Log），帮助您进行安全事件的溯源与审计。  💡 总结一个简单的判断标准：如果您只是想把普通的日志或非敏感文件存放在云端，使用 AWS 默认提供的免费加密或托管服务即可；但只要涉及到“谁能看这些核心数据”、“出了安全事故怎么合规审计”、“密钥能不能由我们自己全权掌控并随时吊销”，就必须用到 AWS KMS。

