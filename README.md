Docker MultiarchBuilder - Docker image
=============================

DISCLAIMER: As-of 2021, this product does not have a free support team anymore. If you want this product to be maintained, please support on Patreon.

The purpose of this project is to build a Multiarch Docker image in a x86/64 CI/CD context.

Sample
------

Here is an example if `.gitlab-ci.yml` file to compile
```yaml
image: femtopixel/multiarchbuilder
variables:
    DOCKER_HOST: "tcp://docker:2375"
services:
    - docker:dind

stages:
    - build

build:
    stage: build
    only:
        - master
    before_script:
        - docker run --rm --privileged multiarch/qemu-user-static:register --reset
        - git clone https://github.com/estesp/manifest-tool && cd manifest-tool && make && make install && cd .. && rm -Rf manifest-tool
        - git clone https://github.com/computermouth/qemu-static-conf.git && mkdir -p /lib/binfmt.d && cp qemu-static-conf/*.conf /lib/binfmt.d/ && systemctl restart systemd-binfmt.service
        - echo "$DOCKER_HUB_PASSWORD" | docker login -u "$DOCKER_HUB_LOGIN" --password-stdin
    script:
        - make build
```

With this, your build task in your Makefile will be able to build an image for other architectures without needing to add qemu into your dockerfiles. Here is the magic :
 - `binfmt-support` is installed in `femtopixel/multiarchbuild`
 - `qemu` is installed in `femtopixel/multiarchbuild`
 - `docker` is installed in `femtopixel/multiarchbuild`
 - qemu-user-static is registered as available binfmt interpreter
 - manifest-tool is installed so you'll be able to create hub manifest to deploy multiple image arch to your docker repository
 - qemu-static-conf are added/registered to binfmt so qemu will be used to interpret in your build context

Appendixes
---

### Install Docker

If you don't have Docker installed yet, you can do it easily in one line using this command
 
```
curl -sSL "https://gist.githubusercontent.com/jaymoulin/e749a189511cd965f45919f2f99e45f3/raw/0e650b38fde684c4ac534b254099d6d5543375f1/ARM%2520(Raspberry%2520PI)%2520Docker%2520Install" | sudo sh && sudo usermod -aG docker $USER
```


