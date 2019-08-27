#!/usr/bin/env sh

es_node=192.168.203.101
es_port=9400

curl -XGET http://$es_node:$es_port/_cat/shards?h=index,shard,prirep,state,unassigned.reason | awk -F ' ' '{print $1"\t"$4}' | uniq 2>&1
