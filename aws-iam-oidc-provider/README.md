## Function

perform as aws OIDC provider creation, for example, you can create github or gitlab OIDC provider using this module

this module is the base of github or gitlab actions role creation when you need to use github or gitlab to deploy AWS resources

next we will use aws-iam-role module to create a github workflow action role as an example

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

locals {

  github_oidc_url = "https://token.actions.githubusercontent.com"
  gitlab_oidc_url = "https://gitlab.com"
  bitbucket_oidc_url = "https://api.bitbucket.org/2.0/workspaces/"
}

module "github_oidc" {
  source = "./modules/aws-iam-oidc-provider"
  url    = local.github_oidc_url

  client_id_list = [ "sts.amazonaws.com" ]

}

module "gitlab_oidc_provider" {
  source = "./modules/iam-oidc-provider"
  url = local.gitlab_oidc_url

  client_id_list = [ "sts.amazonaws.com" ]
}

```
the module will return OIDC Provider arn

then you can check and confirm the arn in AWS console ---> IAM ---> Identity Providers




