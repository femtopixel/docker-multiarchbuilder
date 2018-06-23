FROM ubuntu

RUN apt update && \
apt install qemu qemu-user-static qemu-user binfmt-support build-essential curl git -y && \
(curl -sSL https://get.docker.com | sh)
