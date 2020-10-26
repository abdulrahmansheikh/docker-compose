#!/bin/bash

target_up() {
  echo "Creating and starting the systems required for $1"
  cd $1
  docker-compose up -d --build
}

target_up-force() {
  echo "Creating and starting the systems required for $1 in force mode"
  cd $1
  docker-compose up -d --build --force-recreate
}

target_down() {
  echo "Stopping the systems required for $1"
  cd $1
  docker-compose kill
}

target_remove() {
  echo "Stopping and removing the systems required for $1"
  cd $1
  docker-compose down
}

target_ps() {
  echo "Listing the process state of the systems required for $1"
  cd $1
  docker-compose ps
}


if type -t "target_$1" &>/dev/null; then
  target_$1 ${@:2}
else
  echo "usage: $0 <target>

target:
    up <servicename>                 --  Starts all the containers of a compose
    up-force <servicename>           --  Force starts/restarts all the containers of a compose
    down <servicename>               --  Stops all the containers of a compose
    remove <servicename>             --  Stops and removes all the containers of a compose
    ps <servicename>                 --  Lists the status of all the containers of a compose
"
  exit 1
fi
