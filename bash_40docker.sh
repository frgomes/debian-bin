#!/bin/bash

function docker_remove_images_none {
  docker images | sed -r 's/[ \t]+/ /g' | tail -n +2 | fgrep "<none>" | cut -d' ' -f3 | xargs docker rmi --force
}

function docker_remove_containers_exited {
  docker ps -a | sed -r 's/[ \t]+/ /g' | tail -n +2 | fgrep "Exited (" | cut -d' ' -f1 | xargs docker rm --force
}

function docker_registry_start {
  docker run -d -p 5000:5000 --restart=always --name registry registry:2
}

function docker_registry_stop {
  docker stop registry && docker rm -v registry
}

function docker_registry_import {
  for image in $* ::nil:: ;do
    if [ ${image} != "::nil::" ] ;then
      docker pull ${image}
      docker tag  ${image} localhost:5000/${image}
      docker push localhost:5000/${image}
      docker pull localhost:5000/${image}
    fi
  done
}
