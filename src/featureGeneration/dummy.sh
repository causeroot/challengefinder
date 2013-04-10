#!/bin/bash
(cat $1;cat $2) | sort > /tmp/tmp
mv /tmp/tmp $1
