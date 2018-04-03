#!/bin/bash

OUTPUTS='./graphs/outputs/'
ERR='./graphs/err/'

#Create directory with outputs
if [[ -d ${OUTPUTS} ]]; then
    rm -r ${OUTPUTS}
fi

if [[ -d ${ERR} ]]; then
    rm -r ${ERR}
fi


mkdir ${OUTPUTS}
mkdir ${ERR}

echo "=======TESTS======="


for input_file in ./graphs/inputs/*.in; do
    fn_without_ext=$(echo ${input_file} | cut -d "/" -f 4 | cut -d "." -f 1)
    ./flp18-log < $input_file >> ${OUTPUTS}/${fn_without_ext}".out" 2> /dev/null
done