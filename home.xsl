<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
	<html>
		<head>
			<title>Homebrewing</title>
		</head>
		<body>
			<h1>Homebrewing</h1>
			<h2>Batches</h2>
			<xsl:apply-templates select="batches"/>
			<h2>Yeasts</h2>
			<xsl:apply-templates select="//batches/batch/yeasts/yeast"/>
		</body>
	</html>
</xsl:template>
	
<xsl:template match="batches">
	<table>
		<tr>
			<th>#</th>
			<th>Name</th>
			<th></th>
			<th></th>
		</tr>
		<xsl:apply-templates select="*"/>
	</table>
</xsl:template>

<xsl:template match="batch">
	<tr>
		<td>
			<xsl:value-of select="@id"/>
		</td>
		<td>
			<a>
				<xsl:attribute name="href">batch/<xsl:value-of select="@id"/>.html</xsl:attribute>
				<xsl:value-of select="name" disable-output-escaping="yes"/>
			</a>
		</td>
		<td></td>
		<td></td>
	</tr>
</xsl:template>

<xsl:template match="yeast">
	<li>
		<xsl:value-of select="lab"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="prodid"/>
	</li>
</xsl:template>

</xsl:stylesheet>
