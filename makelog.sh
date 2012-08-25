#!/bin/bash

TUMBLR_SITE_NAME="geekbrewing"
BATCH_ID=$1

curl --silent "http://$TUMBLR_SITE_NAME.tumblr.com/api/read?tagged=$BATCH_ID" > batches/$BATCH_ID/log.xml
# xml sel -t -v "/batch/recipe/filename" -n -v "/batch/recipe/commit_sha" -n batches/011/recipe.xml

# Get version of recipe 
# git show $V:"recipes/$F" > batches/$BATCH_ID/recipe.xml
