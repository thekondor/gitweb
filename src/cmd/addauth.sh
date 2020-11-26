#!/bin/bash
 
error(){ 
    	echo "ERROR : parameters invalid !" >&2 
    	exit 1 
} 

usage(){ 
    	echo "Usage: addauth user password" 
    	echo "--help or -h : view help" 
} 

load(){
    if [ ! -f ${_HTPASSWD} ]; then
        htpasswd -bc ${_HTPASSWD} $1 $2
    else
        htpasswd -b ${_HTPASSWD} $1 $2
    fi
}

# no parameters
[[ $# -lt 1 ]] && error

case "$1" in
        --help)
            usage
            ;;
         
        -h)
            usage
            ;;
         
        *)
            [[ $# -ne 2 ]] && error
            load $1 $2
             
esac
