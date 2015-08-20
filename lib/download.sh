#!/bin/zsh

function download_src() {
    if [ "$#" -ne 2 ];then
        watchdog  "[ERROR] Usage: $0 <filename> <remote_addr>" ERROR
    elif [ -f  ./$1 ];then

        watchdog  "[INFO] $1 is exists";

    else

        watchdog "[INFO] Downloading $1  From $2" 

        wget --no-check-certificate -O $1 $2
        
        if [[ "$?" -ne 0 ]];then 
            watchdog "[FAILURE] $1 is download failure" ERROR && kill -9 $$ 
        else
            watchdog "[SUCCESS] $1 is downloaded" INFO 
        fi 
    fi
    
}

