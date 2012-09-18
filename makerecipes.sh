#!/bin/bash

GH_PAGES_REPO="$HOME/homebrew-pages"

find recipes -maxdepth 1 -type f -name "*.xml" | 
while read R; do 
	cp "$R" $GH_PAGES_REPO/recipes/;
	RECIPE_ID=$(basename "$R" .xml)
	RECIPE_ID_MD5=$(echo -n "$RECIPE_ID" | md5)
	
	git log --reverse --pretty=format:'<version commit="%h" id="%H"><author email="%ae">%an</author><date>%ad</date><message>%s</message></version>'  "$R" | 
	sed -e '1i\
<versions>' -e '$a\
</versions>' | xml ed -a /versions -t attr -n id -v $RECIPE_ID_MD5 > $GH_PAGES_REPO/recipes/versions/$RECIPE_ID_MD5.xml
	
	P=$GH_PAGES_REPO/recipes/"$RECIPE_ID".html
	cat "$R" | xsltproc \
		--stringparam md5 $RECIPE_ID_MD5 \
		--stringparam versions_file $GH_PAGES_REPO/recipes/versions/$RECIPE_ID_MD5.xml \
		recipe.xsl - > "$P"
	
	# Get each version
	xml sel -t -m '/versions/version' -v "@id" -n $GH_PAGES_REPO/recipes/versions/$RECIPE_ID_MD5.xml |
	while read RV; do 
		if [ ! -d $GH_PAGES_REPO/recipes/versions/$RECIPE_ID_MD5 ]; then
			mkdir $GH_PAGES_REPO/recipes/versions/$RECIPE_ID_MD5
		fi
		git show $RV:"$R" > $GH_PAGES_REPO/recipes/versions/$RECIPE_ID_MD5/$RV.xml
		xsltproc recipe.xsl $GH_PAGES_REPO/recipes/versions/$RECIPE_ID_MD5/$RV.xml > $GH_PAGES_REPO/recipes/versions/$RECIPE_ID_MD5/$RV.html
	done	
done
