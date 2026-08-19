## Function

perform as aws Standard SQS creation

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


module "maxwell_app_order_queue" {
  source = "./modules/aws-sqs"

  queue_name = "maxwell-order-processing"
  visibility_timeout_seconds = 60 # 比如你的消费者处理一条订单需要 60 秒
  receive_wait_time_seconds  = 10 # 开启长轮询

  # 启用死信队列，重试 3 次后进入 DLQ
  enable_dlq        = true
  max_receive_count = 3

  tags = {
    Environment = "production"
    Project     = "maxwell-app"
  }
}

module "maxwell_app_billing_queue" {
  source = "./modules/aws-sqs"

  queue_name = "maxwell-billing-processing"
  visibility_timeout_seconds = 60
  receive_wait_time_seconds = 10

  enable_dlq = true
  max_receive_count = 3

  tags = {
    Environment = "production"
    Project     = "maxwell-app"
  }
}


```

微服务之间的主要工作方式可以归纳为两类核心的通信模式：
同步通信 
异步通信（事件驱动）
同时，它们还需要依赖基础设施进行服务治理。

服务发现
服务启动时会把自己的 IP 和端口注册到注册中心（如 Consul、Nacos 或 Kubernetes 内部 DNS）。其他服务想调用它时，先去注册中心问：“某某服务现在在哪几个 IP 上？”然后再去发起调用。

API 网关
外部的客户端（App、网页端）不会直接访问内部的几十个微服务，而是统一请求 API 网关。ALB 一般充当 API 网关 

配置中心
微服务们的数据库密码、第三方 API Key、开关配置等，不会写死在代码里，而是统一托管在配置中心。当配置修改时，各个微服务可以实现动态热更新，不用重新打包部署。

CRUD - post , Get, Put/Patch, Delete


异步通信 一 对 多

一个非常经典且贴合实际的 Fan-out（扇出）业务场景是：电商平台的“用户下单成功”通知。

假设用户在电商网站（Service A 生产者）成功支付了一笔订单，此时系统不能只干一件事，而是需要同时触发多个后续业务：

业务诉求（一发多收）
库存服务：扣减对应商品的库存。

积分/会员服务：给用户的账户增加相应的消费积分。

消息推送/通知服务：给用户发送一条短信或站内信：“您的订单已支付成功”。

数据统计/大数据服务：将订单数据推送到数仓，用于实时大屏展示或销量统计。



