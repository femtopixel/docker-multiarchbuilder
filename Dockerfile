FROM ubuntu

ENV TZ=Europe/Paris
RUN apt update && \
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
apt install \
qemu-user-static \
qemu-user \
binfmt-support \
build-essential \
curl git -y && \
(curl -sSL https://get.docker.com | sh)
