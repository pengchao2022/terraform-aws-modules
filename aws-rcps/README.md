## Function

perform as aws Organization RCPs, RCP is short for Resource Control Policies.

The RCP is designed to eastablish an enterprise level data perimeter, 

Ensure that sensitive resources  are not accessed by unauthorized external users or external organizations

In this demo, I will create one RCP policy module to prevent S3 bucket been accessed from External users or organizations


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


module "enterprise_rcp" {
  source = "./modules/aws-rcps"

  # 通常 RCP 建议直接作用于整个组织根节点（Root）或高风险 OU
  target_id      = "r-9nci"             # Root ID
  trusted_org_id = "o-15kch7po6w"       # Organization ID
}


```

