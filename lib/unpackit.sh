#!/bin/zsh

function unpackit() {
    if [ -f "$1" ]
    then
        tar -xzvf $1 
    else
        watchdog "[ERROR] unpack file $1, not found ...failure" ERROR
        exit 1
    fi

    echo $(pwd)
}


