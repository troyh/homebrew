#!/bin/bash

TUMBLR_SITE_NAME="geekbrewing"
GH_PAGES_REPO="$HOME/homebrew-pages"
BATCH_ID=$1

curl --silent "http://$TUMBLR_SITE_NAME.tumblr.com/api/read?tagged=$BATCH_ID" > batches/$BATCH_ID/log.xml

# Get version of recipe 
read F <<<$(xml sel -t -v "/batch/recipe/filename"   batches/$BATCH_ID/recipe.xml)
read V <<<$(xml sel -t -v "/batch/recipe/commit_sha" batches/$BATCH_ID/recipe.xml)
git show $V:"recipes/$F" > batches/$BATCH_ID/tmp.xml

# If the results.xml file doesn't exist, create an empty one
if [ ! -f batches/$BATCH_ID/results.xml ]; then
	cat - > batches/$BATCH_ID/results.xml <<EOF
	<results/>
EOF
fi

# Combine the Tumblr log and the recipe into on XML document
xsltproc \
	--stringparam filename batches/$BATCH_ID/tmp.xml \
	--stringparam recipefile "$F" \
	--stringparam commit_sha $V \
	--stringparam results_file batches/$BATCH_ID/results.xml \
	combine.xsl \
	batches/$BATCH_ID/log.xml > batches/$BATCH_ID/batch.xml
rm -f batches/$BATCH_ID/tmp.xml

# Make the HTML page for the batch
xsltproc batch.xsl batches/$BATCH_ID/batch.xml > batches/$BATCH_ID/batch.html
# Put them in the separate gh-pages branch repo
cp batches/$BATCH_ID/batch.html $GH_PAGES_REPO/batch/$BATCH_ID.html

#
# Make the index page
#
xml ls batches/ | xsltproc batchindex.xsl > batches/index.xml
ls  recipes/*.xml | while read F; do xml sel -t -m '/RECIPES/RECIPE' -c .   <(cat "$F"); done | sed -e '1i\
<RECIPES>' -e '$a\
</RECIPES>' > recipes.xml
xsltproc --stringparam recipes_doc recipes.xml home.xsl batches/index.xml > index.html

