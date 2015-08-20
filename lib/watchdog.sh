#!/bin/zsh

function watchdog() {
    local color=$COLOR_WHITE
    local default_msg="No message passed."
    local message=${1:-$default_msg}
    
    local level=${2:-INFO}
    
    echo -en "\n"
    case $level in
    INFO)
         echo -en "${COLOR_GREEN}";;
    WARN|WARNING)
         echo -en "$COLOR_WHITE" ;;
    ERROR|ERR)
         echo -en "$COLOR_RED" ;;
    NOTICE)
         echo -en "$COLOR_WHITE" ;;
    *)
         echo -en "$COLOR_WHITE" ;;
    esac

    echo -en "$message$COLOR_RESET \n" 
    #tput sgr0         # Reset to normal

    echo $(date)': '$1 >> /tmp/install_log
}

