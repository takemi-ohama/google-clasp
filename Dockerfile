FROM ubuntu:bionic

LABEL maintainer="takemi.ohama@gmail.com"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y apt-utils
RUN apt-get install -y vim wget curl tzdata git ca-certificates sudo 
RUN apt-get install -y locales language-pack-ja-base language-pack-ja 
RUN apt-get install -y nodejs npm 

#npmとnodeを最新版に更新
RUN npm cache clean
RUN npm install --no-progress -g n
RUN n latest
RUN apt-get purge -y nodejs npm
RUN npm install --no-progress -g typings typescript
RUN npm install --no-progress -g @google/clasp
RUN npm install --no-progress -g create-react-app loopback-cli 

#aptインストール完了
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

#日本語化
RUN sed -i -e "s/# ja_JP.UTF-8 UTF-8/ja_JP.UTF-8 UTF-8/" /etc/locale.gen
RUN locale-gen
RUN update-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja"

#dockerユーザ作成
RUN useradd -m -s /bin/bash docker && \
    usermod -G users docker && \
    usermod -G users root && \
    echo '%users ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    mkdir /home/docker/.ssh && chown docker.docker /home/docker/.ssh

USER docker
WORKDIR /opt
ENV LANG=ja_JP.UTF-8

CMD ["tail","-f","/dev/null"]
