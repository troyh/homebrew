#!/bin/bash

TUMBLR_SITE_NAME="geekbrewing"
GH_PAGES_REPO="$HOME/homebrew-pages"
BATCH_ID=$1

curl --silent "http://$TUMBLR_SITE_NAME.tumblr.com/api/read?tagged=$BATCH_ID" > batches/$BATCH_ID/log.xml

# If the results.xml file doesn't exist, create an empty one
if [ ! -f batches/$BATCH_ID/results.xml ]; then
	cat - > batches/$BATCH_ID/results.xml <<EOF
<results>
	<mash type="" duration="">
		<infusion>
			<strike volume="" temp=""/>
		</infusion>
		<measurement temp=""/>
		<measurement temp=""/>
		<measurement temp=""/>
		<measurement temp=""/>
	</mash>
	<boil volume="" sg="" time="" end_volume=""/>
	<gravity volume="" og="" fg=""/>
</results>

EOF
fi

TMPFILE=$(mktemp -t brewlog)
# Grab any keywords from log posts
xml sel -t -m '/tumblr/posts/post' -v . -n  batches/$BATCH_ID/log.xml | 
		tail -r | 
		perl -n -e 'while (/[^\w](OG|FG|BG|BV|EV|FV|BT)=([\d\.]+)/g) { print "$1 $2\n";  }' |
		while read K V; do
			# Convert volume gallons to liters
			if [[ $K == "BV" || $K == "EV" || $K == "FV" ]]; then
				V=$(bc <<<"$V * 3.78541")
			fi
			echo $K $V;
		done > $TMPFILE

# Edit the results.xml with values taken from keywords in log posts
for K in OG FG BV BG EV FV BT; do 
	grep $K $TMPFILE |
	tail -n 1 | 
	sed -f keywords.sed | 
	while read X V; do 
		xml ed --inplace --update $X -v $V batches/$BATCH_ID/results.xml; 
	done ; 
done
rm -f $TMPFILE

# Get filename and version of recipe for this batch
IFS='	' read RECIPEFILE RECIPEVERSION < <(xml sel -t -m '/batch/recipe' -v filename -o '	' -v commit_sha batches/$BATCH_ID/recipe.xml)

# Combine the Tumblr log and the recipe into on XML document
xsltproc \
	--stringparam filename <(git show $RECIPEVERSION:"recipes/$RECIPEFILE") \
	--stringparam recipefile "$RECIPEFILE" \
	--stringparam commit_sha $RECIPEVERSION \
	--stringparam results_file batches/$BATCH_ID/results.xml \
	combine.xsl \
	batches/$BATCH_ID/log.xml > batches/$BATCH_ID/batch.xml

# Make the HTML page for the batch
xsltproc batch.xsl batches/$BATCH_ID/batch.xml > batches/$BATCH_ID/batch.html
# Put them in the separate gh-pages branch repo
cp batches/$BATCH_ID/batch.html $GH_PAGES_REPO/batch/$BATCH_ID.html

#
# Make the index page
#
xml ls batches/ | xsltproc batchindex.xsl - > batches/index.xml
ls  recipes/*.xml | while read F; do xml sel -t -m '/RECIPES/RECIPE' -c .   <(cat "$F"); done | sed -e '1i\
<RECIPES>' -e '$a\
</RECIPES>' > recipes.xml
xsltproc --stringparam recipes_doc recipes.xml home.xsl batches/index.xml > index.html

cp index.html $GH_PAGES_REPO/