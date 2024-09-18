# 使用官方的 Ubuntu 20.04 作为基础镜像
FROM ubuntu:20.04

# 设置非交互模式以避免在安装过程中卡住
ENV DEBIAN_FRONTEND=noninteractive

# 更新包管理器并安装必要的工具和依赖
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    python3 \
    python3-pip \
    unzip \
    openjdk-11-jdk \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 安装 Bazelisk（用于自动管理 Bazel 版本）
RUN curl -L https://github.com/bazelbuild/bazelisk/releases/download/v1.17.0/bazelisk-linux-amd64 -o /usr/local/bin/bazelisk && \
    chmod +x /usr/local/bin/bazelisk

# 设置工作目录
WORKDIR /app

# 复制项目文件到容器中
COPY . .

# 使用 Bazelisk 构建项目
RUN /usr/local/bin/bazelisk build //:install

# 运行项目
CMD ["/usr/local/bin/bazelisk", "run", "//:install"]
