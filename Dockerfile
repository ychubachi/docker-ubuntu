## -*- dockerfile-image-name: "docker-alpine-texlive:latest" -*-
# In Emacs dockerfile-mode, hit C-c C-b to build the Docker image.

# Currently WSLg does not support Docker. To install X11
# > winget install marha.VcXsrv

FROM ubuntu:22.04

# Package
RUN apt-get update && apt-get -y upgrade

# Timezone
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y tzdata \
    && ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# Language
RUN apt-get -y install language-pack-ja
ENV LANG=ja_JP.UTF-8 LC_ALL=ja_JP.UTF-8 LANGUAGE=ja_JP.UTF-8

# User
RUN apt-get -y install sudo
RUN useradd -s /bin/bash docker \
    && echo "docker:docker" | chpasswd \
    && adduser docker sudo

# X11
ENV DISPLAY host.docker.internal:0.0
RUN apt-get -y install x11-apps gedit

# XIM (fcitx+mozc), Japanese fonts
RUN apt-get -y install fcitx-mozc
ENV GTK_IM_MODULE=fcitx QT_IM_MODULE=fcitx XMODIFIERS=@im=fcitx
RUN apt-get -y install fonts-takao
COPY --chown=docker fcitx-config /home/docker/.config/fcitx/config
COPY --chown=docker mozc-config1.db /home/docker/.config/mozc/config1.db

# Tools
RUN apt-get -y install less vim
RUN apt-get -y install emacs
RUN apt-get -y install git gh

# Texlive
WORKDIR /tmp
RUN apt-get -y install wget perl
RUN wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz && \
    zcat install-tl-unx.tar.gz | tar xf - && \
    cd install-tl-* && \
    perl ./install-tl --no-interaction
ENV PATH /usr/local/texlive/2022/bin/x86_64-linux:$PATH
RUN tlmgr install collection-langjapanese collection-langcjk

# Clean up
RUN apt-get clean \
    && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# User settings
USER docker

WORKDIR /home/docker
COPY --chown=docker .bashrc .
