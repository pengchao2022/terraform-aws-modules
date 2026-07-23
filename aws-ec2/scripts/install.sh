#!/bin/bash
set -e

echo "=== Starting Ubuntu environment setup ==="

# update os
apt-get update -y
apt-get upgrade -y

# install aws cli
sudo apt install -y awscli

# install traceroute
sudo apt install traceroute -y

# install Docker
echo "=== Installing Docker ==="
apt-get install -y docker.io
systemctl start docker
systemctl enable docker
usermod -a -G docker ubuntu  

# install helm
echo "=== Installing Helm from GitHub (fixed version) ==="
HELM_VERSION="v3.16.2"
wget -q "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" -O /tmp/helm.tar.gz
tar -xzf /tmp/helm.tar.gz -C /tmp
install -m 755 /tmp/linux-amd64/helm /usr/local/bin/helm
rm -rf /tmp/linux-amd64 /tmp/helm.tar.gz

# verify helm
helm version

# install git
echo "=== Installing Git ==="
apt-get install -y git

# install CloudWatch Agent
echo "=== Installing CloudWatch Agent ==="
wget -q https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb -O /tmp/amazon-cloudwatch-agent.deb
dpkg -i /tmp/amazon-cloudwatch-agent.deb
rm /tmp/amazon-cloudwatch-agent.deb

echo "=== Creating CloudWatch Agent config ==="
sudo mkdir -p /opt/aws/amazon-cloudwatch-agent/etc/

sudo tee /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json > /dev/null <<'EOF'
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "root"
  },
  "metrics": {
    "append_dimensions": {
      "InstanceId": "${aws:InstanceId}"
    },
    "metrics_collected": {
      "mem": {
        "measurement": [
          "mem_used_percent"
        ]
      },
      "disk": {
        "measurement": [
          "used_percent"
        ],
        "resources": [
          "/"
        ]
      },
      "cpu": {
        "measurement": [
          "cpu_usage_idle",
          "cpu_usage_iowait"
        ]
      }
    }
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/syslog",
            "log_group_name": "/aws/vpc/gopay-dev-flow-logs",
            "log_stream_name": "{instance_id}"
          }
        ]
      }
    }
  }
}
EOF

# use the config file to start the agent
echo "=== Starting CloudWatch Agent ==="
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
  -s

# start the service
systemctl enable amazon-cloudwatch-agent
systemctl start amazon-cloudwatch-agent

# check the status
sleep 2
if systemctl is-active --quiet amazon-cloudwatch-agent; then
    echo "CloudWatch Agent is running"
else
    echo "CloudWatch Agent failed to start"
    journalctl -u amazon-cloudwatch-agent --no-pager -n 20
fi

echo "=== Ubuntu environment setup complete! ==="