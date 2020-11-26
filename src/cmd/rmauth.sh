#!/bin/bash
 
error(){ 
    	echo "ERROR : parameters invalid !" >&2 
    	exit 1 
} 

usage(){ 
    	echo "Usage: rmauth user" 
    	echo "--help or -h : view help" 
} 

load(){
    if [ -f ${_HTPASSWD} ]; then
        htpasswd -bD ${_HTPASSWD} $1
    fi
}

# no parameters
[[ $# -ne 1 ]] && error

case "$1" in
        --help)
            usage
            ;;
         
        -h)
            usage
            ;;
         
        *)
            load $1
 
esac
