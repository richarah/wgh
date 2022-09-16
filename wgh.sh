#!/bin/sh

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
    wget http://github.com/$1/archive/$2.tar.gz
 else
    wget http://github.com/$1/archive/master.tar.gz
 fi

# Use pigz (parallel implementation of gzip) if available
if which pigz >/dev/null; then
    echo "Decompressing with pigz..."
    pigz -dc *.tar.gz | tar -xv
else
    echo "Decompressing with tar..."
    tar -xvf *.tar.gz
fi

# BUG: dirname should not include branch

echo "Cleaning up..."
if $has_branch_flag;
  then
    rm -rf $2.tar.gz
 else
    rm -rf master.tar.gz
 fi
