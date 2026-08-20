## Function

perform as aws EC2 creation also with the user_data script template

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

Please put the scripts directory to you root folder where you will call this module

```shell

 module "gopay-ec2-dev" {
  source = "./modules/aws-ec2"
  project_name = "gopay-service"
  environment  = "dev"

  instance_suffix = ["jump-server-1", "web-1"]

  public_ip_instances = ["jump-server-1"]

  subnet_map = {
    jump-server-1 = module.gopay-service-dev.public_subnet_ids[0]
    web-1         = module.gopay-service-dev.private_subnet_ids[0]
  }

  ami_id          = "ami-0b6d9d3d33ba97d99" # ubuntu linux 
  instance_type   = "t3.micro"

  public_key_content = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGItthHZvUum/HO2EKun7jkPUvDUkc6ZjQ0P6LfVRm8iyosphuOxBEA7pQUt3cldYnzyC5u5zwQ+zL8/2SmGZwfUsk3L0pGMSzWaA3fmGcCVj3vkH4BINQ1UWI7RPE04/UUAv/LLecwKS+q7lubugJKNpuyrt027U+1a5FcKcKurK/MrCLx9UaQ08cFYORrddx/qcfIwTPvsAjRNldaZpU+q+Nl0GCHDi+RJlm5ZlOfi7XQ0BznPpQezAVT4DcFU50hCzkDLTwo7/1kPkdO3OG5pysS75S5t2OnKPbZWGqdhjiUX6KdoXOMjaoZC6rwegChrgjrKvtfg5MPXT8FWbCkCBV/I/0D0/yTthe8bmHX9PyUG8VztfT5D795biCRZx06ZyRNfAUXCLCG//5AbTezMTxfCkNkC8O3xDKuy6A/Aj5jWMldlLbxpXoAddidiLttpeMV+ROTHNmHqoN/i65Mb8+Ovet1WgWX2HG0u5S2T0pSz9jZJNWf69GSMp/ZtQri4+KZ4dMdO+rUTxfnKa7oH4rblYVjAF0ENUNT9T+S6nXhmr3qV2gnXS/KTREYoi1InwZCA0cKiJq+sWRtO02tao662dW4BCYwOer8gojBMERY2aZ6d24ye89uyt+9C4GYnqDz+zw1L2CdPi0EraP8xP9zpeux1J8pFV95pFWIw== pengchao.ma2@outlook.com"
  
  existing_security_group_ids = [
    module.gopay_dev_web_server_ssh_sg.security_group_ssh_id,
    module.icmp_sg_gopay_dev.security_group_icmp_id,
    module.web_server_dev_http_8080_sg.security_group_http_8080_id,
    module.web_server_dev_http_sg.security_group_http_id,
    module.web_server_dev_https_sg.security_group_https_id
  ]
 
  root_volume_size = 30

  iam_instance_profile = module.gopay-ec2-iam.instance_profile_name
  user_data = file("${path.root}/scripts/install.sh")

  depends_on = [
    module.gopay_dev_web_server_ssh_sg,
    module.icmp_sg_gopay_dev,
    module.web_server_dev_http_sg,
    module.web_server_dev_http_8080_sg,
    module.web_server_dev_https_sg
  ]
}

```
For more available zones supported
```shell


module "maxwell_ec2_dev" {
  source = "./modules/aws-ec2"
  project_name = "maxwell"
  environment  = "dev"

  instance_suffix = ["jump-server", "rabbitmq-1", "rabbitmq-2", "rabbitmq-3"]

  public_ip_instances = ["jump-server"]

  vpc_id       = module.maxwell_dev_vpc.vpc_id

  subnet_map = {
    jump-server = module.maxwell_dev_vpc.public_subnet_ids[0]
    rabbitmq-1 = module.maxwell_dev_vpc.private_subnet_ids[0]
    rabbitmq-2 = module.maxwell_dev_vpc.private_subnet_ids[1]
    rabbitmq-3 = module.maxwell_dev_vpc.private_subnet_ids[2]
  }

  ami_id        = "ami-0b6d9d3d33ba97d99"
  instance_type = "t3.small"

  public_key_content = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGItthHZvUum/HO2EKun7jkPUvDUkc6ZjQ0P6LfVRm8iyosphuOxBEA7pQUt3cldYnzyC5u5zwQ+zL8/2SmGZwfUsk3L0pGMSzWaA3fmGcCVj3vkH4BINQ1UWI7RPE04/UUAv/LLecwKS+q7lubugJKNpuyrt027U+1a5FcKcKurK/MrCLx9UaQ08cFYORrddx/qcfIwTPvsAjRNldaZpU+q+Nl0GCHDi+RJlm5ZlOfi7XQ0BznPpQezAVT4DcFU50hCzkDLTwo7/1kPkdO3OG5pysS75S5t2OnKPbZWGqdhjiUX6KdoXOMjaoZC6rwegChrgjrKvtfg5MPXT8FWbCkCBV/I/0D0/yTthe8bmHX9PyUG8VztfT5D795biCRZx06ZyRNfAUXCLCG//5AbTezMTxfCkNkC8O3xDKuy6A/Aj5jWMldlLbxpXoAddidiLttpeMV+ROTHNmHqoN/i65Mb8+Ovet1WgWX2HG0u5S2T0pSz9jZJNWf69GSMp/ZtQri4+KZ4dMdO+rUTxfnKa7oH4rblYVjAF0ENUNT9T+S6nXhmr3qV2gnXS/KTREYoi1InwZCA0cKiJq+sWRtO02tao662dW4BCYwOer8gojBMERY2aZ6d24yeyLVcI+9C4GYnqDz+zw1L2CdPi0EraP8xP9zpeux1J8pFV95pFWIw== pengchao.ma2@outlook.com"
  
  existing_security_group_ids = [ 
    module.ec2_sg_icmp_dev.security_group_icmp_id,
    module.ec2_sg_ssh_dev.security_group_ssh_id,
   ]
  
  root_volume_size = 30
  iam_instance_profile = module.maxwell_ec2_iam_role_with_rabbit_secret.instance_profile_name
  user_data = file("${path.root}/scripts/install.sh")
  
}

```


Get the ssh key id_rsa.pub command
```shell
cat ~/.ssh/id_rsa.pub

```
Get the instance profile using aws cli
```shell
aws iam list-instance-profiles

```




