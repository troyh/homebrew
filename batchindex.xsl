<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/dir">
	<batches>
		<xsl:apply-templates select="d"/>
	</batches>
</xsl:template>

<xsl:template match="d">
	<xsl:variable name="batchdoc" select="document(concat('batches/',@n,'/batch.xml'))"/>
	<batch>
		<xsl:attribute name="id"><xsl:value-of select="@n"/></xsl:attribute>
		<name><xsl:value-of select="$batchdoc/batch/recipe/beerxml/RECIPE/NAME"/></name>
		<type><xsl:value-of select="$batchdoc/batch/recipe/beerxml/RECIPE/TYPE"/></type>
		<styles>
			<xsl:apply-templates select="$batchdoc/batch/recipe/beerxml/RECIPE/STYLES"/>
		</styles>
		<yeasts>
			<xsl:apply-templates select="$batchdoc/batch/recipe/beerxml/RECIPE/YEASTS"/>
		</yeasts>
		<xsl:copy-of select="$batchdoc/batch/recipe/data"/>
		<xsl:copy-of select="$batchdoc/batch/results"/>
	</batch>
</xsl:template>

<xsl:template match="STYLE">
	<style>
		<name><xsl:value-of select="NAME"/></name>
	</style>
</xsl:template>

<xsl:template match="YEAST">
	<yeast>
		<lab><xsl:value-of select="LABORATORY"/></lab>
		<prodid><xsl:value-of select="PRODUCT_ID"/></prodid>
		<name><xsl:value-of select="NAME"/></name>
	</yeast>
</xsl:template>
	
</xsl:stylesheet>
