#!/bin/bash

TUMBLR_SITE_NAME="geekbrewing"
BATCH_ID=$1

curl --silent "http://$TUMBLR_SITE_NAME.tumblr.com/api/read?tagged=$BATCH_ID" > batches/$BATCH_ID/log.xml

# Get version of recipe 
read F <<<$(xml sel -t -v "/batch/recipe/filename"   batches/$BATCH_ID/recipe.xml)
read V <<<$(xml sel -t -v "/batch/recipe/commit_sha" batches/$BATCH_ID/recipe.xml)
git show $V:"recipes/$F" > batches/$BATCH_ID/tmp.xml

# Combine the Tumblr log and the recipe into on XML document
xsltproc --stringparam recipeurl batches/$BATCH_ID/tmp.xml combine.xsl batches/$BATCH_ID/log.xml > batches/$BATCH_ID/batch.xml
rm -f batches/$BATCH_ID/tmp.xml

# Make the HTML page for the batch
xsltproc batch.xsl batches/$BATCH_ID/batch.xml > batches/$BATCH_ID/batch.html
