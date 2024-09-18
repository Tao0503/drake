# 使用官方的 Ubuntu 20.04 作为基础镜像
FROM ubuntu:20.04

# 设置非交互模式以避免在安装过程中卡住
ENV DEBIAN_FRONTEND=noninteractive

# 更新包管理器并安装必要的工具和依赖
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    libeigen3-dev \
    libgflags-dev \
    libgoogle-glog-dev \
    && rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /app

# 复制项目文件到容器中
COPY . .

# 创建构建目录并构建项目
RUN mkdir -p build && cd build && cmake .. && make

# 运行项目（替换为您的可执行文件名称）
CMD ["./build/your_executable_name"]
