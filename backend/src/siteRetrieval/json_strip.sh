#!/bin/bash
# Strip JSON structure from URL results file
# usage is:
# json_strip input_file
# Input file will be assumed to have extension .res and output .url
grep link $1 | awk '{ print $2 }' | cut -f 2 -d \" > $2
