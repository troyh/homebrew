<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:param name="recipe_file"/>
<xsl:param name="batchid"/>
<xsl:variable name="recipe" select="document($recipe_file)"/>
<xsl:variable name="recipexml" select="document(concat('batches/',$batchid,'/recipe.xml'))"/>

<xsl:template match="/">
	<batch>
		<xsl:attribute name="id"><xsl:value-of select="$batchid"/></xsl:attribute>
		<recipe>
			<xsl:element name="beerxml">
				<xsl:attribute name="recipefile">
					<xsl:value-of select="$recipexml/batch/recipe/filename"/>
				</xsl:attribute>
				<xsl:attribute name="commit_sha">
					<xsl:value-of select="$recipexml/batch/recipe/commit_sha"/>
				</xsl:attribute>
				<xsl:copy-of select="$recipe/RECIPES/RECIPE"/>
			</xsl:element>
			<data>
				<xsl:apply-templates select="$recipe/RECIPES/RECIPE/FERMENTABLES"/>
			</data>
		</recipe>
		<xsl:copy-of select="document(concat('batches/',$batchid,'/results.xml'))"/>
		<log>
			<xsl:copy-of select="."/>
		</log>
	</batch>
</xsl:template>

<xsl:template match="FERMENTABLE">
	<ppg><xsl:value-of select="AMOUNT * 2.20462 * (YIELD div 100 * 46)"/></ppg>
</xsl:template>


</xsl:stylesheet>