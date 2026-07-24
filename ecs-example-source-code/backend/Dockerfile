# 使用轻量级 Python 3.11 镜像
FROM python:3.11-slim

# 设置工作目录
WORKDIR /app

# 1. 优化 apt-get：合并安装命令，减少层数，同时安装 curl 和 build-essential
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 先复制 requirements.txt 并安装依赖 (利用 Docker 缓存层优化速度)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 复制 backend 目录下所有代码到工作目录
COPY . .

# 暴露端口
EXPOSE 8000

# 启动命令
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]