FROM adoptopenjdk/openjdk11:alpine-slim

ARG user=dev
ARG uid=676
ARG gid=676

# update alpine
RUN apk update && apk upgrade

#create new user
RUN mkdir /opt/workspace && mkdir /opt/workspace/$user && \
    addgroup -S -g $gid $user && \
    adduser -S -h /opt/workspace/$user -u $uid -G $user $user

# install base modules, python, node.js (java comes with)
RUN apk add --update-cache \
    bash \
    ttf-dejavu \
    python3 \
    build-base \
    nodejs \
    npm \
    git \
    && rm -rf /var/cache/apk/*

# ensure pip3
RUN python3 -m ensurepip && \
    python3 -m pip install \
        --no-cache --upgrade \
        pip \
        setuptools

# install sublime and firefox
RUN apk add --update-cache \
    geany \
    firefox \
    && rm -rf /var/cache/apk/*

# Install IntelliJ Idea
RUN mkdir /opt/tools && mkdir /opt/tools/idea
RUN wget https://download-cf.jetbrains.com/idea/ideaIC-2021.1.1-no-jbr.tar.gz && \
    tar -xf ideaIC-2021.1.1-no-jbr.tar.gz --directory /opt/tools/idea --strip-components 1 && \
    rm ideaIC-2021.1.1-no-jbr.tar.gz && \
    ln -s /opt/tools/idea/bin/idea.sh /usr/bin/idea

# change default user and settings
WORKDIR /opt/workspace/$user
RUN chown -R $user:$user /opt/workspace/$user

USER $user

# expose necessary ports for testing your application
EXPOSE 3000 3001 3002 3003
