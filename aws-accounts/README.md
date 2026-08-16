## Function

perform as aws Organization Accounts creation.

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


module "maxwell_workload_accounts" {
  source = "./modules/aws-accounts"

  accounts = {
    dev_app = {
      name       = "maxwell-app-development"
      email      = "18510656167@ibm.com" # plese make sure this email didn't registerd on AWS
      parent_id  = "ou-9nci-yaoobo6x"       # put the dev account in Development OU
    },
    prod_app = {
      name       = "maxwell-app-production"
      email      = "18510656167@yahoo.com"
      parent_id  = "ou-9nci-occ1puis"      # put the prod account in Production OU
    }
  }
}

```

If you need to switch the new created aws account, use the following infomation:

```shell


Account ID 

915275040359

IAM role name

OrganizationAccountAccessRole

Display name

Dev-Admin

Display color

Green

```


