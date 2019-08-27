#!/usr/bin/env sh

es_node=192.168.203.101
es_port=9400
log_path=./reindex_file.log
index_file=$1

for index_name in `cat $index_file`;
do
    echo " " | tee -a $log_path
    echo $index | tee -a $log_path
    echo " " | tee -a $log_path
    #create new index
    curl -XPUT http://$es_node:$es_port/${index_name}_alias -H 'Content-Type:application/json' -d '{"settings": { "index": {"number_of_shards":1, "number_of_replicas": 0}}}' | tee -a $log_path
    
    ##reindex 
    curl -XPOST http://$es_node:$es_port/_reindex -H 'Content-Type:application/json' -d '{ "source": {"index": "'"${index_name}"'"}, "dest": {"index":"'"${index_name}_alias"'"}}' | tee -a $log_path
    
    ##remove old index
    curl -XDELETE http://$es_node:$es_port/$index_name | tee -a $log_path
    
    ##set alias for new index
    curl -XPOST http://$es_node:$es_port/_aliases -H 'Content-Type:application/json' -d '{"actions" : [{ "add" : { "index" : "'"${index_name}"'_alias", "alias" : "'"$index_name"'" } }]}' | tee -a $log_path
done
