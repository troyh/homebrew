#!/bin/bash

GH_PAGES_REPO="$HOME/homebrew-pages"

find recipes -type f -name "*.xml" | 
while read R; do 
	cp "$R" $GH_PAGES_REPO/recipes/;
	P=$GH_PAGES_REPO/recipes/$(basename "$R" .xml).html
	cat "$R" | xsltproc recipe.xsl - > "$P"
done
