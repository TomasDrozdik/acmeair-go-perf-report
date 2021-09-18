#!/bin/bash

set -e

OUTNAME=${1:?Provide output file name}
INTERVAL=${2:?Provide sleep interval in seconds}

HEADER="Time,Name,ID,CPUPerc,MemUsage,MemTotal,MemPerc,NetInput,NetOutput,BlockInput,BlockOutput,PIDs"
FORMAT="{{.Name}},{{.ID}},{{.CPUPerc}},{{.MemUsage}},{{.MemPerc}},{{.NetIO}},{{.BlockIO}},{{.PIDs}}"

update_file() {
    TIME=$(date +'%s')
    docker stats --all --no-stream --format ${FORMAT} | sed "s/^/${TIME},/" | sed -r 's|([[:alnum:].]+) / ([[:alnum:].]+)|\1,\2|g' >> ${OUTNAME}
}

echo ${HEADER} > ${OUTNAME}
while true;
do
	update_file &
	sleep $INTERVAL;
    wait
done
