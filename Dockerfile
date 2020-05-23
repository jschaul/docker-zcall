FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y git sudo && \
        ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime && \
        apt-get install -y tzdata && \
        dpkg-reconfigure --frontend noninteractive tzdata

# TODO back to upstream after PR
RUN mkdir -p /src && cd /src && \
        git clone https://github.com/jschaul/wire-audio-video-signaling.git --branch update-instructions && \
        cd wire-audio-video-signaling/ && \
        ./scripts/ubuntu_18.04_dependencies.sh

RUN apt-get install -y openjdk-8-jdk
# RUN apt-get install -y icedtea-8-plugin
# RUN apt-get install -y icedtea-plugin

RUN update-java-alternatives --jre-headless --jre --plugin -s java-1.8.0-openjdk-amd64 || true

WORKDIR /src/wire-audio-video-signaling

# takes ~30 minutes or more
RUN cd webrtc && ./scripts/build.sh

RUN cd webrtc && ./scripts/package.sh

RUN touch contrib/webrtc/webrtc_m79.local_ios.zip && \
    touch contrib/webrtc/webrtc_m79.local_osx.zip && \
    ./prepare.sh

RUN apt-get install -y rsync
RUN export PATH="$HOME/.cargo/bin:$PATH"; make WEBRTC_VER=m79.local

RUN export PATH="$HOME/.cargo/bin:$PATH"; make WEBRTC_VER=m79.local zcall

RUN apt-get install -y x11-xserver-utils x11-apps
