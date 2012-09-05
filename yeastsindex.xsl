<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/yeasts">
	<xsl:apply-templates select="*"/>
</xsl:template>
	
<xsl:template match="yeast">
	<xsl:apply-templates select="*"/>
</xsl:template>

<xsl:template match="batch">
	<xsl:variable name="batch" select="document(concat('batches/',@id,'/batch.xml'))"/>
	<xsl:copy-of select="."/>
	<name>
</xsl:template>
	
</xsl:stylesheet>
