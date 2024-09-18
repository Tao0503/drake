# 使用官方的 Ubuntu 20.04 作为基础镜像
FROM ubuntu:20.04

# 设置非交互模式以避免在安装过程中卡住
ENV DEBIAN_FRONTEND=noninteractive

# 更新包管理器并添加软件源
RUN apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository ppa:ubuntu-toolchain-r/test && \
    apt-get update

# 安装 GCC 11、G++ 11、以及其他必要的工具和依赖库
RUN apt-get install -y \
    gcc-11 \
    g++-11 \
    pkg-config \
    libfmt-dev \
    libeigen3-dev \
    build-essential \
    cmake \
    git \
    python3 \
    python3-pip \
    unzip \
    openjdk-11-jdk \
    curl \
    libspdlog-dev \
    libboost-all-dev \
    libgflags-dev \
    libgoogle-glog-dev \
    libprotobuf-dev \
    protobuf-compiler \
    && rm -rf /var/lib/apt/lists/*

# 更新默认的 GCC 和 G++ 版本到 11
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 100 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 100

# 安装 Bazelisk（用于自动管理 Bazel 版本）
RUN curl -L https://github.com/bazelbuild/bazelisk/releases/download/v1.17.0/bazelisk-linux-amd64 -o /usr/local/bin/bazelisk && \
    chmod +x /usr/local/bin/bazelisk

# 设置工作目录
WORKDIR /app

# 复制项目文件到容器中
COPY . .

# 创建缺少的配置文件目录和空文件
RUN mkdir -p /app/gen && touch /app/gen/environment.bazelrc

# 使用 Bazelisk 构建项目的所有目标
RUN /usr/local/bin/bazelisk build //...

# 运行项目 - 使用实际可执行文件的路径（需要在构建完成后确定）
CMD ["/bin/bash"]
