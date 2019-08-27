!/usr/bin/env sh

es_node=192.168.203.101
es_port=9400
index_name=$1

#create new index
curl -XPUT http://$es_node:$es_port/${index_name}_alias -H 'Content-Type:application/json' -d '{"settings": { "index": {"number_of_shards":1, "number_of_replicas": 0}}}'
echo $?

##reindex 
curl -XPOST http://$es_node:$es_port/_reindex -H 'Content-Type:application/json' -d '{ "source": {"index": "'"${index_name}"'"}, "dest": {"index":"'"${index_name}_alias"'"}}'
echo $?

##remove old index
curl -XDELETE http://$es_node:$es_port/$index_name
echo $?

##set alias for new index
curl -XPOST http://$es_node:$es_port/_aliases -H 'Content-Type:application/json' -d '{"actions" : [{ "add" : { "index" : "'"${index_name}"'_alias", "alias" : "'"$index_name"'" } }]}'
echo $?
