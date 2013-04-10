#!/bin/bash

if [ $# -ne 2 ]
then
    echo Need two arguments 
    exit
fi
(cat $1;cat $2) | sort | uniq > /tmp/tmp
mv /tmp/tmp $1
