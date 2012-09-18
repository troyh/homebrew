#!/bin/bash

GH_PAGES_REPO="$HOME/homebrew-pages"

# Make recipe index page
find recipes -type f -name "*.xml" | 
while read R; do 
	xml sel -t -m '//RECIPE' -e recipe -a filename -o "$R"  -b -c NAME   <(cat "$R"); 
done | 
sed -e '1i\
<recipes>' -e '$a\
</recipes>' > recipeindex.xml 

# Make index of recipes that were used in a batch
find batches -name recipe.xml | while read R; do B=$(dirname $R | sed -e 's:^batches/::'); xml ed --omit-decl --insert /batch --type attr -n id -v $B $R;  done | sed -e '$a\
</batches>
' -e '1i\
<batches>
' > batchindex.xml



#
# Make the yeast index
#
for B in $(find  batches -type d -depth 1 | sed -e 's:^batches/::'); do 
	xml sel -t -m '/batch' -v '@id' -o ' ' -m 'recipe/beerxml/RECIPE/YEASTS/YEAST' -v PRODUCT_ID batches/$B/batch.xml;
done | 
	awk '{print $2" "$1 }' | 
	sort | 
	perl -n -e '
	chomp;
	($yid,$bid)=split(/ /);
	if ($lastyid != $yid) {
		if (length($lastyid)) {
			print "</yeast>"
		};
		print "<yeast id=\"$yid\">";
	}
	print "<batch id=\"$bid\"/>"; 
	$lastyid=$yid;
' | 
sed -e '$a\
</yeast></yeasts>' -e '1i\
<yeasts>' |
xml fo > yeasts.xml

#
# Make the index page
#
xml ls batches/ | xsltproc batchindex.xsl - > batches/index.xml
ls  recipes/*.xml | while read F; do xml sel -t -m '/RECIPES/RECIPE' -c .   <(cat "$F"); done | sed -e '1i\
<RECIPES>' -e '$a\
</RECIPES>' > recipes.xml
xsltproc home.xsl batches/index.xml > $GH_PAGES_REPO/index.html

