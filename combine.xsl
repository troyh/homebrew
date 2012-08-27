<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:param name="recipeurl"/>
<xsl:variable name="recipe" select="document($recipeurl)"/>

<xsl:template match="/">
	<batch>
		<recipe>
			<xsl:element name="beerxml">
				<xsl:attribute name="url"><xsl:value-of select="$recipeurl"/></xsl:attribute>
				<xsl:copy-of select="$recipe/RECIPES/RECIPE"/>
			</xsl:element>
		</recipe>
		<log>
			<xsl:copy-of select="."/>
		</log>
	</batch>
</xsl:template>

</xsl:stylesheet>