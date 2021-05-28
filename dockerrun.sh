#!/bin/bash
docker build -t buildenv:latest --build-arg uid=$(id -u) --build-arg gid=$(id -g) .

if [[ ! "$(docker ps -q -f name=buildenv_dev)" ]]
then
    if [ "$(docker ps -aq -f name=buildenv_dev)" ]; then
        # cleanup
        docker rm buildenv_dev
    fi
    # if the container is not running then start it
    mkdir -p devenv
    chown -R $USER:$USER devenv
    docker run -it --name buildenv_dev \
        -e DISPLAY=$DISPLAY \
        -p 3000:3000 \
        -p 3001:3001 \
        -p 3002:3002 \
        -p 3003:3003 \
        --mount type=bind,source="$(pwd)"/devenv,target=/opt/workspace/dev \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        buildenv:latest bash
else
    # if our container is running then attach to it
    docker exec -it buildenv_dev sh
fi

