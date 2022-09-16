#!/bin/bash
# TODO: make sh-compatible

OLDIFS=$IFS

IFS='/'
read -a strarr <<<"$1"
USER=${strarr[0]}
REPO=${strarr[1]} 
BRANCH=$2

# Reset IFS to prevent trouble later
IFS=$OLDIFS

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
    BRANCH=$2
 else
    BRANCH="master"
 fi

URL="http://github.com/$USER/$REPO/archive/$BRANCH.tar.gz"

wget -qO- $URL | tar -xvz --one-top-level=$REPO

echo "Cleaning up..."
rm -rf $REPO.tar.gz
