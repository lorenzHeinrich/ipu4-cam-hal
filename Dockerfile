# Use Ubuntu 21.04 as a base image
FROM ubuntu:22.04

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update and install dependencies (including glibc 2.27 and build tools)
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    g++ \
    make \
    cmake \
    libglib2.0-dev \
    autoconf \
    libtool \
    linux-libc-dev \
    libexpat1-dev \
    rpm \
    alien \
    && apt-get clean

# Install any other dependencies as required by the IPU build process
# COPY your source code or set up volume mounts to access your local files

# Set up working directory for the build process
WORKDIR /build

# Optional: Add source code and binaries to the container
COPY ./IPU_binary/lib /lib
COPY ./IPU_binary/usr /usr
COPY ./libcamerahal /libcamerahal

RUN cmake ../libcamerahal \ 
    && make -j \
    && make package \
    && alien --to-deb libcamhal*.rpm \
    && dpkg -i libcamhal*.deb
