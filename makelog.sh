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
		perl -n -e 'while (/[^\w](OG|FG|BG|BV|EV|FV|BT|ST|SV|LT)=([\d+\.]*\d+)/g) { print "$1 $2\n";  }' |
		while read K V; do
			# Convert volume gallons to liters
			if [[ $K == "BV" || $K == "EV" || $K == "FV" || $K == "SV" ]]; then
				V=$(bc <<<"$V * 3.78541")
			elif [[ $K == "ST" ]]; then
				# Convert temperature from F to C
				V=$(bc <<<"($V - 32) / 1.8")
			fi
			echo $K $V;
		done > $TMPFILE

# Edit the results.xml with values taken from keywords in log posts
for K in OG FG BV BG EV FV BT ST SV; do 
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
	--stringparam recipe_file <(git show $RECIPEVERSION:"recipes/$RECIPEFILE") \
	--stringparam batchid $BATCH_ID \
	combine.xsl \
	batches/$BATCH_ID/log.xml > batches/$BATCH_ID/batch.xml

# Make the HTML page for the batch
xsltproc batch.xsl batches/$BATCH_ID/batch.xml > $GH_PAGES_REPO/batch/$BATCH_ID.html

