FROM ubuntu:18.04

RUN mkdir -p /src

WORKDIR /src

RUN apt-get update && apt-get install -y git

ENV DEBIAN_FRONTEND=noninteractive

RUN ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime && \
        apt-get install -y tzdata && \
        dpkg-reconfigure --frontend noninteractive tzdata

# TODO back to upstream after PR
RUN git clone https://github.com/jschaul/wire-audio-video-signaling.git --branch update-instructions && \
        cd wire-audio-video-signaling/ && \
        which python || true && \
        ./scripts/ubuntu_18.04_dependencies.sh && \
        which python || true && \
        echo poop2

RUN apt-get install -y sudo

RUN apt-get install -y x11-utils rpm p7zip libxt-dev

RUN cd wire-audio-video-signaling/webrtc && \
        ./scripts/build.sh

RUN xhost local:root


