#!/bin/bash
# TODO: make sh-compatible

# Split user and repo on delimiter
IFS='/'
read -a strarr <<<"$1"

USER=${strarr[0]}
REPO=${strarr[1]} 
BRANCH=$2

has_branch_flag=false
while getopts :ht opt; do
    case $opt in
        b) has_branch_flag=true ;;
        :) echo "Missing argument for option -$OPTARG"; exit 1;;
       \?) echo "Unknown option -$OPTARG"; exit 1;;
    esac
done

if $has_branch_flag;
  then
    wget http://github.com/$USER/$REPO/archive/$BRANCH.tar.gz
 else
    wget http://github.com/$USER/$REPO/archive/master.tar.gz
 fi

# Use pigz (parallel implementation of gzip) if available
# WIP: refactoring
if which pigz >/dev/null; then
    echo "Decompressing with pigz..."
    pigz -dc *.tar.gz | tar -xv
else
    echo "Decompressing with tar..."
    tar -xvf *.tar.gz
fi


echo "Cleaning up..."
if $has_branch_flag;
  then
    rm -rfv $REPO-$BRANCH.tar.gz
 else
    rm -rfv $REPO-master.tar.gz
 fi
