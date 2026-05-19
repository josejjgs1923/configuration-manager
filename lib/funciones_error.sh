#!/usr/bin/env zsh

error(){
  echo "$1" 1>&2
}

error_exit(){
  echo "$1" 1>&2 && exit 1
}


